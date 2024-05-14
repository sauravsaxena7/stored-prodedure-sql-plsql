USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPGetReimbursementClientMIS]    Script Date: 1/10/2024 4:36:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 -- select * from AppointmentLog where AppointmentId=222053 order by AppointmentLogId desc                                             
 -- exec [USPGETBookingAppointmentDetails_Reimbursement]  null,null,null,null,null,1,50,null,null,null,null,null,'Confirmation',null              
 -- exec [USPGetReimbursementClientMIS]  null,'2023-08-01','2023-09-30'
    -- exec [USPGetReimbursementClientMIS]  '7','2023-08-01','2023-09-30',null

 -- exec [USPGETBookingAppointmentDetails_Reimbursement]  null,'2023-05-10','2023-10-13',null,null,1,50,null,null,null,null,null,'Confirmation',null 
 
 ---exec USPGetReimbursementClientMIS null,'2023-10-03','2024-01-10','389'
  
ALTER PROCEDURE [dbo].[USPGetReimbursementClientMIS]          
 @AppointmentStatus varchar (50)=null,                                                      
 @FromDate datetime = null,                                                      
 @ToDate datetime =null,
 @ClientId varchar(50)=null
AS                                                        
BEGIN                                                        
                                                        
 SET NOCOUNT ON                                                        
                                                        
/****************************Start DECLARE VARIABLES*********************************/                                                        
          Declare @UserId bigint,@Userloginidbookfor varchar(50),@Status int =1,@SubCode INT=200,@Message VARCHAR(MAX)='Successful',          
    @CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100)                                                     
                                                 
 if (@FromDate is null and @ToDate is null )
 Begin
 set @FromDate= Cast((GETDATE()-1) as date)
 set @ToDate= Cast((GETDATE()) as date)
 end
        
		print @FromDate
		print @ToDate
    --select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                                                
                                               
                                              
/***************************Start Declare Table**************************************************************/                                    
       Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),MobileNo varchar(100),
    HealthAssureRemark varchar(100),DateOfReimbursementRequest DATETIME,ClientName varchar(255),ReimburseRequestAmount varchar(100),	
	ApprovedAmount varchar(50),Clientid int,ApprovedDate datetime,PolicyNo VARCHAR(100),PrimaryInsuredname VARCHAR(100),
	PolicyStartDate datetime, Reimbursement VARCHAR(100),UserName VARCHAR(100),BankName VARCHAR(100),AccountDetails VARCHAR(50),
    IFSC varchar(100),UserMemberId int ,AmountReimburseDate DATETIME,AppointmentStatus varchar(100))                            
                         
                                                      
                                                        
 if (@FromDate is not null and @ToDate is not null  ) 
 begin                                                      
 print 'case 5'                                                     
   insert into #Temporary (AppointmentId,CaseNo ,AppointmentType,UserLoginId,MemberId,CustomerName,MobileNo,
    HealthAssureRemark,DateOfReimbursementRequest ,ClientName ,ReimburseRequestAmount,	
    ApprovedAmount,Clientid ,ApprovedDate,PolicyNo,PrimaryInsuredname,PolicyStartDate,Reimbursement ,UserName,BankName
   ,AccountDetails, IFSC,UserMemberId ,AmountReimburseDate,AppointmentStatus)                            
                               
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                       
  mem.MobileNo,null,apt.CreatedDate,C.ClientName,mpd.TxnAmount,                                                        
  mpd.ApprovedAmt,apt.ClientId,mpd.UpdatedDate,ISNULL(le.PolicyNo,''),Concat(m.FirstName,' ',m.LastName) as 'Customer Name',
  null,s.ShortDesc,u.UserName,MPD.Bank,
  MPD.AccountNumber,MPD.IFSCCode,MPD.MemberId,MPD.UpdatedDate,sm.StatusName
     
  from Appointment apt with (nolock)                                                            
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                  
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                        
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'   
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                             
  join ReimbursementMemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                                       
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                                                          
  join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                        
  join LibertyEmpRegistration le with (nolock) on le.UserLoginId = u.UserLoginId                           
  join StatusMaster sm with (nolock) on sm.StatusId = apt.ScheduleStatus                           
             
  where (@FromDate is null and @ToDate is null OR cast (MPD.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))                        
  and (@AppointmentStatus is null OR apt.ScheduleStatus like '%'+@AppointmentStatus+'%')                                         
  and (@ClientId is null OR c.clientid in(@ClientId))                                         
                            
 and apt.AppointmentType='RI'                                                
 --ORDER BY al.CreatedDate                     
--DESC offset @RecordPerPage * (@PageNumber-1)rows                                             
--FETCH NEXT @RecordPerPage rows only                                                        
                                          
  end                                                      
                                                                     
                 
--  /*****************Select All table*************************************************/                                                        
                                                           
                    
   select distinct * from #Temporary  tmp                                                          
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                        
 
  end 