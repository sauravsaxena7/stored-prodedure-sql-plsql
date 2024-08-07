USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPgetTELE_MISReport_OPS]    Script Date: 5/23/2024 7:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		<ANURAG KHULLAR
-- Create date: <26-07-2023>
-- Description:	<Get TELE MIS Report Details>
-- =============================================
-- exec [USPgetTELE_MISReport_OPS] '2023-10-28','2024-04-24',null,null,1,500,2,null ,'N'           

 ALTER PROCEDURE [dbo].[USPgetTELE_MISReport_OPS]                                       
 @FromDate datetime = null,                                                                                      
 @ToDate datetime =null,                                                                                      
 @Plan varchar(100)=null,                                                                                                              
 @ClientId varchar(100)=null,                                                                                        
 @pageNumber int=1,  --page Number                                                                                                          
 @recordPerPage int=50 ,                                                                                         
 @DaysofActived INT = 2,                                                     
 @AppointmentStatus varchar(100) = null,
 @IsShowMaskData VARCHAR(20)=NULL
AS                                                                                        
BEGIN                
 SET NOCOUNT ON                                                                                        
       set @pageNumber=1 
	  
/****************************Start DECLARE VARIABLES*********************************/                                                                                        
   Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100),@myoffset int=0                                                         
  
  
                  
   if(@FromDate is null and @ToDate is null)                  
   Begin                  
   set @FromDate = DATEADD(DAY, -1, GETDATE())
   set @ToDate = GETDATE()                 
                    
   ENd                   
                  
   print '@FromDate'                  
   print '@ToDate'
				
     select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,100000)                        
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,100000)             
                                                                               
    
                                                                                       
     set @myoffset=((@recordPerPage * @pageNumber) - @recordPerPage ) + 0;                                       

print('@myoffset')    
  print @myoffset
  print('@myoffset')    

  
                                    
/***************************Start Declare Table**************************************************************/                                                   
                                         
    Create table #Temporary (ApptId int,PatientName varchar(100),Status varchar(100),CaseType varchar(100),CaseID nvarchar(100),ClientType varchar(100),ClientName varchar(100), AppointmentBookedAt varchar(100),RequestedconsultationSlotDatetime varchar(100),RecallRequestedDatetime varchar(100),ConsultationStartDate Varchar(100),PrescriptionSavedDateTime varchar(100),AppointmentClosedDateTime varchar(100),Agencies varchar(100),ConsultantName	varchar(100),ConsultantNumber varchar(100),PatientMobileNo varchar(100),CancelReason varchar(max),CancelDate varchar(100),ServiceBookedFor varchar(100),RefundId VARCHAR(200) ,RefundRemark varchar(300),RefundAmount Varchar(100)  ,RefundDoneBy varchar(300) )                                                                                           
/****************************End DECLARE VARIABLES********************************************************/

/****************************Start Main Logic************************************************/                                                                                                                                                           
 INSERT INTO #Temporary (ApptId,PatientName,Status,CaseType,CaseID,ClientType,ClientName,AppointmentBookedAt,RequestedconsultationSlotDatetime,
 RecallRequestedDatetime,ConsultationStartDate,PrescriptionSavedDateTime,AppointmentClosedDateTime,Agencies,ConsultantName,ConsultantNumber,
 PatientMobileNo,CancelReason,CancelDate,ServiceBookedFor,RefundId, RefundRemark, RefundAmount  )                                                                               
                                         
  select distinct apt.AppointmentId,
                  null as PatientName,
                  st.StatusName,
				  'TELE-CONSULTATION' as CaseType,
				  apt.CaseNo,
				  c.ClientType,
				  c.ClientName,
				  FORMAT(ISNULL(apt.CreatedDate,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
				  FORMAT(ISNULL(ad.AppointmentDateTime,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
				  null,
				  null,
				  null,
				  null,
				  mtc.ProviderName as Agencies,
				  d.name,
				  d.phone,
				  --m.MobileNo as PateientMobileNumber,
				  IIF(@IsShowMaskData='Y',m.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](m.MobileNo)),
				  al.Remarks,
				  FORMAT(ISNULL(al.CreatedDate,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
				  fm.DisplayFacilityName
				  ,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,CAST(srh.RefundAmount as varchar(300))
				 
  from Appointment apt with (nolock) 
  left join ServiceRefundHistory srh with(nolock) on apt.AppointmentId=srh.Appointmentid
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                                                   
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                       
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                          
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                   
  join MapTCAppointment mtc with (nolock) on mtc.AppointmentId=apt.AppointmentId
  join HAModule.tele_consultaion.Doctor d with (nolock) on mtc.doctorId=d.DoctorId
  join AppointmentLog al with (nolock) on apt.AppointmentId=al.AppointmentId --and al.ScheduleStatus=7 
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                 
  join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                               
  join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId                                                                              
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                 
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                               
  where (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))  
  and (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                               
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                      
  and apt.AppointmentType in('TEL','TDR','NT','TC','TELECOUN','TELEGP','TELEGYN','TELEDEN','TELEAYUR','TELEHOMEO','TELEOPTHAL','TELEPEDIA','TELEENDO','TELEPUL','TELEDERMA','TELEDIAB','FITCOACH','YOGA','DANCEFIT','FUNCTRAIN','FITCOUN','TELEPHYSIO','TELESPEC','Ortho','Urol','Card','ENT','Gast','Sexo','Menta','DIET')                 


	
	
/*******************Start Additional Logic****************************************************/                                                                     
     DECLARE @datacount int
	 set @datacount= (select count( DISTINCT CaseID) as 'RecordsCount' from #Temporary  tmp)                                                                   
       PRINT @datacount                                                                            
            PRINT 'DATACOUNT'                                                                                
     set @myoffset=((@datacount * @pageNumber) - @datacount ) + 0;                                            

------------Delete duplicate caseno in temporary--------------------------------------------------------------------------------------------                                                                            
  ;WITH cte AS (                                                                            
   SELECT *, ROW_NUMBER() OVER (                                                               
            PARTITION BY                                                                             
              CaseId,AppointmentBookedAt                                                                           
           ORDER BY                                                      
             CaseId,AppointmentBookedAt                                                                           
        ) row_num                                                                            
     FROM #Temporary                                                                            
   )                              
   DELETE FROM cte                                                                            
   WHERE row_num > 1;                                                                            
----------------End Delete duplicate caseno logic----------------------------------------------------------------------------------------------    

 ---------------------Refund Logic start------------------------------
select max(AppointmentLogId) as maxlogid 
into #maxlogid
from appointmentlog where StatusReason in ('Initiate Refund','Refund Rejected') and appointmentid in (select appointmentid from #Temporary)
group by appointmentid 

--select * from #maxlogid;

create table #Refunddata (AppointmentLogId int,	AppointmentId int, Remarks varchar(500),UserLoginId	 int,CreatedBy varchar(100),StatusReason varchar(100))
insert into #Refunddata
select m.maxlogid,al.AppointmentId,al.Remarks,al.UserLoginId,al.CreatedBy,al.StatusReason
from #maxlogid m  join appointmentlog al on m.maxlogid=al.appointmentlogid

--select * from #Refunddata;

update T
set T.RefundRemark= R.Remarks,T.RefundDoneBy=R.CreatedBy
from #Temporary T left join #Refunddata R on T.ApptId=R.AppointmentId
where  T.ApptId=R.AppointmentId
---------------------Refund Logic end------------------------------


   UPDATE #Temporary 
   SET Agencies = m.ProviderName
   FROM #Temporary t
   JOIN MapTCAppointment m ON t.ApptId = m.AppointmentId;

   UPDATE #Temporary
   SET RecallRequestedDatetime=FORMAT(ISNULL(tc.HealthCoachRecallDttm,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
       ConsultationStartDate=FORMAT(ISNULL(tc.InProgressConsultationDateTime,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
       PrescriptionSavedDateTime=FORMAT(ISNULL(tc.CompletedConsultationDateTime,null), 'yyyy-MM-ddTHH:mm:ss.fff'),
	   AppointmentClosedDateTime=FORMAT(ISNULL(tc.ClosedConsultationDateTime,null), 'yyyy-MM-ddTHH:mm:ss.fff')	   
   FROM #Temporary t
   JOIN HAModule.tele_consultaion.Consultation tc on t.ApptId=tc.HaAppointmentId

   UPDATE #Temporary
   SET PatientName=isnull(t.PatientName,concat(m.FirstName,' ',m.LastName))
      FROM #Temporary t
   JOIN Appointment a on a.AppointmentId=t.ApptId
   JOIN Member m on m.MemberId=a.MemberId

   UPDATE #Temporary
   SET CancelReason=a.Remarks
      FROM #Temporary t
   JOIN AppointmentLog a on a.AppointmentId=t.ApptId where a.ScheduleStatus=7

/*******************End Additional Logic****************************************************/ 

  /*****************Select All table*************************************************/                                                                                            
   PRINT @FromDate                  
   PRINT @ToDate                                                                                      
   SELECT distinct * from #Temporary
   where CaseID is not null
   ORDER BY AppointmentBookedAt  DESC
   offset @myoffset rows                                                                                                              
   FETCH NEXT @datacount rows only                                                                                            
                                                                                                                                       
   SELECT count( DISTINCT CaseID) as 'RecordsCount' from #Temporary  tmp                                                                   
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                                            
                              
                                                                                               
/*****************End Select All Table********************************************/                                                                                            
   drop table #Temporary                                                               
   --drop table #TEMP                                                        
End
