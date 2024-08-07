USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGetReimbursementClientMIS]    Script Date: 5/25/2024 3:35:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- select * from AppointmentLog where AppointmentId=222053 order by AppointmentLogId desc                                             
-- exec [USPGETBookingAppointmentDetails_Reimbursement]  null,null,null,null,null,1,50,null,null,null,null,null,'Confirmation',null              
-- exec [USPGetReimbursementClientMIS]  null,'2023-08-01','2023-09-30'
-- exec [USPGetReimbursementClientMIS]  '7','2023-08-01','2023-09-30',null
-- exec [USPGETBookingAppointmentDetails_Reimbursement]  null,'2023-05-10','2023-10-13',null,null,1,50,null,null,null,null,null,'Confirmation',null 
---exec USPGetReimbursementClientMIS null,'2019-10-03','2024-01-10',null,'N'
  
ALTER PROCEDURE [dbo].[USPGetReimbursementClientMIS]          
 @AppointmentStatus varchar (50)=null,                                                      
 @FromDate datetime = null,                                                      
 @ToDate datetime =null,
 @ClientId varchar(50)=null,
  @IsShowMaskData VARCHAR(20)=NULL
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
    IFSC varchar(100),UserMemberId int ,AmountReimburseDate DATETIME,AppointmentStatus varchar(100)
	,MemberPlanBucketID BIGINT)                            
                         
                                                      
                                                        
 if (@FromDate is not null and @ToDate is not null  ) 
 begin                                                      
 print 'case 5'                                                     
   insert into #Temporary (AppointmentId,CaseNo ,AppointmentType,UserLoginId,MemberId,CustomerName,MobileNo,
    HealthAssureRemark,DateOfReimbursementRequest ,ClientName ,ReimburseRequestAmount,	
    ApprovedAmount,Clientid ,ApprovedDate,PolicyNo,PrimaryInsuredname,PolicyStartDate,Reimbursement ,UserName,BankName
   ,AccountDetails, IFSC,UserMemberId ,AmountReimburseDate,AppointmentStatus,MemberPlanBucketID)                            
                               
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name', 
  --IIF(@IsShowMaskData='Y',mem.EmailId,[dbo].[GetMaskedEmail](mem.EmailId)),
  --IIF(@IsShowMaskData='Y',mem.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](mem.MobileNo)),
  --mem.MobileNo,
  IIF(@IsShowMaskData='Y',mem.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](mem.MobileNo)),
  null,apt.CreatedDate,C.ClientName
  --,mpd.TxnAmount,                                                        
  --mpd.ApprovedAmt,
  ,isnull(apt.TotalAmount ,0)
  ,null as ApprovedAmount
  ,apt.ClientId,mpd.UpdatedDate,ISNULL(le.PolicyNo,''),Concat(m.FirstName,' ',m.LastName) as 'Customer Name',
  null,s.ShortDesc,
  --u.UserName,
  IIF(@IsShowMaskData='Y', u.UserName,[dbo].[GetMaskedEmail]( u.UserName)),
  MPD.Bank,
  --MPD.AccountNumber,
  IIF(@IsShowMaskData='Y',  MPD.AccountNumber,[dbo].[GetMaskedAllCharExceptLast_4_Digit]( MPD.AccountNumber)),
  MPD.IFSCCode,MPD.MemberId,MPD.UpdatedDate,sm.StatusName
  ,apt.MemberPlanBucketID
     
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
  left join MemberPlanDetails mpdd on mpdd.AppointmentId=apt.AppointmentId                          
             
  where (@FromDate is null and @ToDate is null OR cast (MPD.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))                        
  and (@AppointmentStatus is null OR apt.ScheduleStatus like '%'+@AppointmentStatus+'%')                                         
  and (@ClientId is null OR c.clientid in(@ClientId))                                         
                            
 and apt.AppointmentType='RI'                                                
                                                    
                                          
  end   
  
  
 select * into #oldplandata
 from   #Temporary
 where MemberPlanBucketID is null    
 
select * into #newplandata
 from   #Temporary
 where MemberPlanBucketID is not null    
 
 
 --select * from #oldplandata;

 --select * from #newplandata;

 update T
 set T.ApprovedAmount=isnull(mpd.points,mpd.TxnAmount)
 from #Temporary T
 left join #oldplandata o on  T.AppointmentId=o.AppointmentId
 left join MemberPlanDetails mpd on mpd.AppointmentId=T.AppointmentId
 where  T.AppointmentId=o.AppointmentId
                                     
 update T
 set T.ApprovedAmount=isnull(TransactionAmount,0)
 from #Temporary T
 left join #newplandata o on  T.AppointmentId=o.AppointmentId
 left join MemberBucketBalance mpd on mpd.AppointmentId=T.AppointmentId
 where  T.AppointmentId=o.AppointmentId
                                     
                                                                      
                 
--  /*****************Select All table*************************************************/                                                        
                                                           
  select  AppointmentId,	CaseNo,	AppointmentType,	UserLoginId	,MemberId,	CustomerName,	MobileNo	,HealthAssureRemark,	DateOfReimbursementRequest	,ClientName,	ReimburseRequestAmount	,ApprovedAmount,	Clientid	,ApprovedDate,	PolicyNo,
  	PrimaryInsuredname,	PolicyStartDate	,Reimbursement	,UserName,	BankName,	AccountDetails,	IFSC,	UserMemberId	,
	AmountReimburseDate,	AppointmentStatus

  into #FinalTemporary
  from #Temporary
                    
   select distinct * from #FinalTemporary  tmp                                                          
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                        
 
  end 