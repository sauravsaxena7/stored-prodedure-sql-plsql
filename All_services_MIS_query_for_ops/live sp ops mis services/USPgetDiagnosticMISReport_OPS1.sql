USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPgetDiagnosticMISReport_OPS1]    Script Date: 6/6/2024 12:45:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sp_helptext [USPGETBookingAppointmentDetailsFor_Diagnostics]                                                                 
   -- select * from StatusMaster                                        
-- exec [USPGETBookingAppointmentDetailsFor_Diagnostics]  'HA28032023HIJHJ'  ,null,null,null,null,1,10,null,null,null,null,1,'Confirmation',null                                                           
-- select distinct VisitType from Appointment                                             
-- exec [USPgetDiagnosticMISReport_OPS1]  '2023-03-31','2023-03-31',null,null,1,50,2,'Closed'                          
-- exec [USPgetDiagnosticMISReport_OPS1]  '2023-07-14','2023-07-14',null,null,1,null,2,'Cancelled'          
-- exec [USPgetDiagnosticMISReport_OPS1]  '2024-04-01','2024-04-10',null,null,1,50,2,'Cancelled'                         
   --select * from statusMaster      
-- exec [USPgetDiagnosticMISReport_OPS1] '2024-04-01','2024-04-10',null,null,1,1000,2,null,null,'N'
      
ALTER PROCEDURE [dbo].[USPgetDiagnosticMISReport_OPS1]   
                        
                                                     
 @FromDate datetime = null,                                                                                              
 @ToDate datetime =null,                                                                                              
 @Plan varchar(100)=null,                                                                                                                      
 @ClientId varchar(100)=null,                                                                                                
 @pageNumber int=1,  --page Number                                                                                                                  
 @recordPerPage int=100000,                                                                                                 
 @DaysofActived INT = 2,                                                             
 @AppointmentStatus varchar(100) = null ,
 @DateFilterType varchar(500) = null  ,
 @IsShowMaskData VARCHAR(20)=NULL
AS                                                                                                
BEGIN                        
 SET NOCOUNT ON                                                                                                
       set @pageNumber=1                                                                                         
/****************************Start DECLARE VARIABLES*********************************/                                                                                                
   Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100),@myoffset int=0                                                         
   Declare @AppoinrmentFromDate datetime,@AppoinrmentToDate datetime            
   if(@FromDate is null and @ToDate is null)                          
   Begin                          
     set @FromDate = DATEADD(DAY, -1, GETDATE())        
     set @ToDate = GETDATE()     
   ENd        
   
   If(@DateFilterType='AppointmentDate')
   Begin
   set @AppoinrmentFromDate=@FromDate
   set @AppoinrmentToDate=@ToDate
   set @FromDate=null;
   set @ToDate=null;
   print 'AppointmentDate'
   print @AppoinrmentFromDate
   print @AppoinrmentToDate
   End
   Else
   begin
   set @AppoinrmentFromDate=null
   set @AppoinrmentToDate=null
   print 'AppointmentDate1'
   print @AppoinrmentFromDate
   print @AppoinrmentToDate
   End
                                                                             
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,100000)                        
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,100000)                         
                                                                                       
     set @myoffset=((@recordPerPage * @pageNumber) - @recordPerPage ) + 0;                                                    
  print @myoffset                                                     
                                            
/***************************Start Declare Table**************************************************************/                                                           
       
    Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(max),UserLoginId bigint,MemberId bigint,                        
 CustomerName varchar(max),EmailId varchar(max),MobileNo varchar(max),Gender varchar(10),FacilityName varchar(max),StatusName varchar(max),                        
 ProviderId bigint,ProviderName varchar(max),RequestedDate VARCHAR(max),Clientid int,ClientName varchar(max),AppointmentDate datetime,                        
 ClientType VARCHAR(max),ProviderMobileNo VARCHAR(max),ISHNI VARCHAR(max),UpdatedBy VARCHAR(300),Relation VARCHAR(max),Username VARCHAR(max),                        
   AgentName varchar(max),AgentMobileNo bigint, DocCoachApptType varchar(max),AppDeviceType Varchar(max),PlanName varchar(max),BookedBy varchar(max),                                      
   LoginUserName varchar(max),PointOfContactName varchar(max),LastCallStatus varchar(max),ProviderAddress varchar(max),IsPrescriptionConsent varchar(50),                        
   MemberPlanId bigint,UserHomeVisitAddress varchar(max),VisitType varchar(350),TestName varchar(max),FacilityId bigint,FacilityType  varchar(max)                                                        
   ,TAT VARCHAR(max),CnfDt datetime,LastUpdatedDate datetime,AppVersion varchar(max),PackageName varchar(max), PartialShowTests varchar(max),ProviderResponse varchar(max)                                                  
   ,DCConfirmationFlag varchar(max),DCConfirmationStage CHAR(700),TestCategory varchar(Max),ViewRemarks  varchar(Max),ProviderAvailableTimeSlots VARCHAR(400)                                    
   ,PartnerOrderId varchar(300),PhleboName varchar(255),PhleboTime varchar(255), PhleboContact varchar(255),                                  
  MemberPaymentDetailsId varchar(max),                        
  MemberName varchar(max),HomeCentrevisit varchar(max),Empno varchar(max),EmpContactNo varchar(20),FacilityGroupName varchar(max),                        
  ClosedDateTime datetime,StatusDate datetime,ConfirmationDate datetime,AppointmentConfirmationTAT varchar(400),CreatedBy varchar(400),OnHoldReason varchar(max),                        
  TranId varchar(max),PaymentMode varchar(max),DCCity varchar(max),MetroNonMetro varchar(100),ReportClosureTAT varchar(max),ReportPendingTAT varchar(max),                        
  PartialStatusDatetime datetime,NoshowDatetime datetime,PartialStatusUpdatebyName varchar(400),NoShowUpdatedDatebyName varchar(300), ConfirmationByName varchar(300),                        
  ReportPenidngbyName varchar(400),FollowupDateTime datetime,FollowupUpdatebyName varchar(100),DCConfirmationStatusDatetime Datetime,DCConfirmationUpdatebyDateTime datetime,                        
  FristResponseTimeonRequest varchar(450),  ReshduledDateTime datetime,ReshduledUpdatedBy varchar(100),CancelledbyCustomerOrDC varchar(400),AppointmentConfirmationOutofTATWithinTAT varchar(100),        
  AppointmentAddress varchar(max),RoutineNonRoutine varchar(300) 
  ,HRName varchar(500)  ,SubClient  varchar(500) ----Added by sayali for HAP-2121 On 22 sep 2023      
   ,First_Date_of_Appointment  datetime ,ChangeAppDate_OR_RescheduleAptDate   datetime   ,RescheduledReason varchar(max),   CancelReason varchar(max) ,RefundId VARCHAR(300) ,RefundRemark varchar(300),RefundAmount Varchar(400)  ,RefundDoneBy varchar(max)                       
   )                                                                                                  
                                                                                                
/****************************End DECLARE VARIABLES********************************************************/                                                                                                 
                                                                                                
---------------------------------------------------------------------------------------------------------                                                                                                
----------------------------------------------------------------------------------------------------------                                                                                                
                                                                                               
/****************************Start Main Logic************************************************/                            
                                                                                                
                
print '@IsShowMaskData'
print @IsShowMaskData
                                                              
                                            
 print 'Diagnostic MIS Data'                                
                      
  insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                                                                  
   Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                                                   
   Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo, ISHNI,UpdatedBy,Relation,Username,                                                                   
   AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,LastCallStatus,ProviderAddress,IsPrescriptionConsent,MemberPlanId,UserHomeVisitAddress,VisitType,TestName,FacilityId,FacilityType,                       
   
   TAT,LastUpdatedDate,AppVersion,PackageName                                                         
   ,PartialShowTests                        
   ,ProviderResponse                                                   
   ,DCConfirmationFlag                                                   
   ,DCConfirmationStage                                                  
   ,TestCategory                                                  
    ,ViewRemarks                          
 ,ProviderAvailableTimeSlots,PartnerOrderId, PhleboName,PhleboTime, PhleboContact                                  
 ,MemberPaymentDetailsId,----                         
 MemberName, HomeCentrevisit,                      
 Empno ,EmpContactNo,FacilityGroupName, ClosedDateTime,StatusDate,ConfirmationDate,
 AppointmentConfirmationTAT,CreatedBy,OnHoldReason,                        
  TranId,PaymentMode,DCCity ,MetroNonMetro ,ReportClosureTAT,ReportPendingTAT,PartialStatusDatetime,NoshowDatetime,PartialStatusUpdatebyName,NoShowUpdatedDatebyName, ConfirmationByName,                        
  ReportPenidngbyName,FollowupDateTime,FollowupUpdatebyName,DCConfirmationStatusDatetime,DCConfirmationUpdatebyDateTime, FristResponseTimeonRequest,ReshduledDateTime,                        
  ReshduledUpdatedBy,CancelledbyCustomerOrDC,AppointmentConfirmationOutofTATWithinTAT,AppointmentAddress,RoutineNonRoutine
  ,HRName,SubClient

   ,First_Date_of_Appointment  ,ChangeAppDate_OR_RescheduleAptDate,RescheduledReason, CancelReason ,
   RefundId, RefundRemark, RefundAmount  
   )                                                                                     
                                                 
  select distinct apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name', 
  mem.EmailId,
  mem.MobileNo,
  --IIF(@IsShowMaskData='Y',mem.EmailId,[dbo].[GetMaskedEmail](mem.EmailId)),
  --IIF(@IsShowMaskData='Y',mem.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](mem.MobileNo)),
  CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender','',--fm.FacilityName,                                                                                                
  st.StatusName,
  ISNULL(pr.ProviderId,0),pr.ProviderName,
  CONVERT(VARCHAR,apt.CreatedDate,126),                                                                                               
  apt.ClientId,c.ClientName,'' as AppointmentDate,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',
  CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                
   
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                                                
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                                                      
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,
  u.UserName,
  --IIF(@IsShowMaskData='N',[dbo].[GetMaskedEmail](u.UserName) ,u.UserName),
  apt.PointOfContactName,ISNULL(al.CallStatus,'') as LastCallStatus,                                                        
  CONCAT( '',REPLACE(CONCAT(isnull(pr.HouseNumber,''),isnull(pr.HouseName,''),isnull(pr.StreetAddress1,''),',',
  isnull(pr.StreetAddress2,''),','+pr.CityName,','+pr.StateName),'&','and')) as ProviderAddress,                                                 
 
  apt.IsPrescriptionConsent,MPD.MemberPlanId,IsNull(apt.AppointmentAddress,'') as UserHomeVisitAddress                                                  
  ,''  as VisitType,  fm.FacilityName,fm.FacilityId,fm.FacilityType,'' as TAT,ISNULL(apt.UpdatedDate,'') as LastUpdatedDate ,ISNULL(ut.app_version,'NA') as AppVersion                                                         
  ,'' as PackageName ,'' as PartialShowTests ,'' as ProviderResponse,apt.DCConfirmationFlag ,apt.DCConfirmationStage                                                  
  ,'' as TestCategory  ,ISNULL(apt.Remarks,'') as ViewRemarks,'' as ProviderAvailableTimeSlots,apt.Partner_orderid,'' as PhleboName,'' asPhleboTime,'' as PhleboContact                                     
  ,isnull(MPD.MemberPaymentDetailsId,'0')                        
                        
  ,Concat(mem.FirstName,' ',mem.LastName),                      
  case when apt.VisitType='CV' THEN 'Center Visit'                      
  when  apt.VisitType='HV' THEN 'Home Visit'                      
  ELSE  apt.VisitType                      
  end AS  HomeCentrevisit,                      
  u.EmpNo,
  m.MobileNo,
  -- IIF(@IsShowMaskData='Y',m.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](m.MobileNo)),
  
  fm.FacilityGroup,        
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=6) as ClosedateTime,   --1
  null as      ClosedateTime,
  null as StatusDate, 
  null as ConfirmationDate       
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=1) as StatusDate,     --2                     
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=2) as ConfirmationDate   --3      
  ,'',al.CreatedBy,                      
  (select Max(Remarks) from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=11),                      
    --select * from statusMaster                                                     
  (SELECT top 1 isnull(mpdi.TransactionId,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId                      
   where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId) ,                      
                        
   (SELECT top 1 isnull(mpdi.ModeOfPayment,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId                      
   where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId) ,                      
                        
  (select isnull(pr.CityName,'') from provider where providerid=pr.ProviderId),                      
                      
  (select top 1 case when c.IsMetro = 'Y' then 'Metro' else 'Non-Metro' end as MetroNonMetro                       
  from city c join haportal.dbo.provider p on p.CityName=c.CityName                      
  where providerid=pr.ProviderId),                      
                        
  '' as ReportClosureTAT,
  '' as ReportPendingTAT,
  
  
        
 --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusDatetime,   
 null as PartialStatusDatetime,                
                    
  --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoshowDatetime, 
  null as NoshowDatetime,                                   
    
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusUpdatebyName,    
  null as  PartialStatusUpdatebyName,
      
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoShowUpdatedDatebyName,   
  null as  NoShowUpdatedDatebyName, 
                        
  ----(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=2 and AppointmentId=apt.AppointmentId) as ConfirmationByName,                       

  null  as ConfirmationByName, 
                      
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=8 and AppointmentId=apt.AppointmentId) as ReportPenidngbyName,   
  null as ReportPenidngbyName,                 
       
  --(select top 1 CreatedDate from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N')) as FollowupDateTime,  
  null as FollowupDateTime,  
                
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N') ) as FollowupUpdatebyName,  
  null as FollowupUpdatebyName,                  
             
  --(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationStatusDatetime,    
  null as DCConfirmationStatusDatetime,  
                
  --(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationUpdatebyDateTime,  
  null as DCConfirmationUpdatebyDateTime,
                  
                                    
   '',             
  --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledDateTime,  
  null as ReshduledDateTime,
                  
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledUpdatedBy,      
  null as ReshduledUpdatedBy,
                        
  --(select top 1 CreatedBy from Appointmentlog al where ScheduleStatus=7 and AppointmentId=apt.AppointmentId ) as CancelledbyCustomerOrDC,   
  null as CancelledbyCustomerOrDC,                
                       
  '' as AppointmentConfirmationOutofTATWithinTAT,
  apt.AppointmentAddress,
  '' 

  
 ,  '' as HRName    
 , 
  CASE 
  WHEN u.SubClientName='Mylan Pharma Pre Employment' then 'Mylan Pharma Pre Employment' 
  WHEN u.SubClientName='Mylan Lab Pre Employment' then 'Mylan Lab Pre Employment' 
  ELSE '' END as 'SubClient' 
  ,null as First_Date_of_Appointment 
  ,null as ChangeAppDate_OR_RescheduleAptDate
  ,null as RescheduledReason
  ,null as    CancelReason
  ,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,CAST(srh.RefundAmount as varchar(300))
  
  
 
                        
  from Appointment apt with (nolock)      
  left join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                                              
  join UserLogin u with(nolock) on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                                                           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                               
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                                                               
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                                                                    
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                         
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                                                                     
  join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                                       
  join CorporatePlan cj with(nolock) on cj.CorporatePlanId=MPD.CorporatePlanId                                                                                              
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                         
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                                                     
  left join city ct with (nolock) on apt.CityId=ct.CityId       
  join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                                                                    
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                                                                    
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                      
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                                                                
  left join LibertyEmpRegistration le with(nolock) on le.UserLoginId = u.UserLoginId                                                                                            
  left join UserTokan ut with(nolock) on ut.UserLoginId=u.UserLoginId                                             
   left join AppointmentLog al with(nolock) on al.AppointmentId=apt.AppointmentId                                                                                                
  where (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))
  and (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                  
  and (@AppoinrmentFromDate is null and @AppoinrmentToDate is null OR 
  ad.AppointmentDateTime >= cast (@AppoinrmentFromDate as date ) and ad.AppointmentDateTime < dateadd(d,1,cast (@AppoinrmentToDate as date )))                  
  --and ((@FromDate is null AND @ToDate is null) OR(CASE
  --      WHEN @DateFilterType = 'AppointmentDate' THEN CAST(ad.AppointmentDateTime as date)
  --      WHEN @DateFilterType = 'BookingDate' THEN CAST(apt.CreatedDate as date)
		--ELSE CAST(apt.CreatedDate as date)
  --     END
  --  BETWEEN CAST(@FromDate as date) AND CAST(@ToDate as date)))
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                                                    
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                              
  and apt.AppointmentType in ('HC')   
  
  print'lola pola'
 -----------plan refactor------- 

   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                                                                  
   Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                                                   
   Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo, ISHNI,UpdatedBy,Relation,Username,                                                                   
   AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,LastCallStatus,ProviderAddress,IsPrescriptionConsent,MemberPlanId,UserHomeVisitAddress,VisitType,TestName,FacilityId,FacilityType,                       
   
   TAT,LastUpdatedDate,AppVersion,PackageName                                                         
   ,PartialShowTests                        
   ,ProviderResponse                                                   
   ,DCConfirmationFlag                                                   
   ,DCConfirmationStage                                                  
   ,TestCategory                                                  
    ,ViewRemarks                          
 ,ProviderAvailableTimeSlots,PartnerOrderId, PhleboName,PhleboTime, PhleboContact                                  
 ,MemberPaymentDetailsId,----                         
 MemberName, HomeCentrevisit,                      
 Empno ,EmpContactNo,FacilityGroupName, ClosedDateTime,StatusDate,ConfirmationDate,
 AppointmentConfirmationTAT,CreatedBy,OnHoldReason,                        
  TranId,PaymentMode,DCCity ,MetroNonMetro ,ReportClosureTAT,ReportPendingTAT,PartialStatusDatetime,NoshowDatetime,PartialStatusUpdatebyName,NoShowUpdatedDatebyName, ConfirmationByName,                        
  ReportPenidngbyName,FollowupDateTime,FollowupUpdatebyName,DCConfirmationStatusDatetime,DCConfirmationUpdatebyDateTime, FristResponseTimeonRequest,ReshduledDateTime,                        
  ReshduledUpdatedBy,CancelledbyCustomerOrDC,AppointmentConfirmationOutofTATWithinTAT,AppointmentAddress,RoutineNonRoutine
  ,HRName,SubClient

   ,First_Date_of_Appointment  ,ChangeAppDate_OR_RescheduleAptDate,RescheduledReason, CancelReason ,
   RefundId, RefundRemark, RefundAmount  
   )     

 select distinct apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                 
  mem.EmailId,
  mem.MobileNo,
   --IIF(@IsShowMaskData='Y',mem.EmailId,[dbo].[GetMaskedEmail](mem.EmailId)),
   --IIF(@IsShowMaskData='Y',mem.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](mem.MobileNo)),
  CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender','',--fm.FacilityName,                                                                                                
  st.StatusName,ISNULL(pr.ProviderId,0),pr.ProviderName ,CONVERT(VARCHAR,apt.CreatedDate,126),                                                                                               
  apt.ClientId,c.ClientName,'' as AppointmentDate,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                
   
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                                                
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                                                      
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,
  u.UserName,
   --IIF(@IsShowMaskData='N',[dbo].[GetMaskedEmail](u.UserName) ,u.UserName),
  apt.PointOfContactName,ISNULL(al.CallStatus,'') as LastCallStatus,                                                        
  CONCAT( '',REPLACE(CONCAT(isnull(pr.HouseNumber,''),isnull(pr.HouseName,''),isnull(pr.StreetAddress1,''),',',isnull(pr.StreetAddress2,''),','+pr.CityName,','+pr.StateName),'&','and')) as ProviderAddress,                                                 
 
  apt.IsPrescriptionConsent,apt.MemberPlanBucketID,IsNull(apt.AppointmentAddress,'') as UserHomeVisitAddress                                                  
  ,''  as VisitType,  fm.FacilityName,fm.FacilityId,fm.FacilityType,'' as TAT,ISNULL(apt.UpdatedDate,'') as LastUpdatedDate
  ,ISNULL(ut.app_version,'NA') as AppVersion                                                         
  ,'' as PackageName ,'' as PartialShowTests ,'' as ProviderResponse,apt.DCConfirmationFlag ,apt.DCConfirmationStage                                                  
  ,'' as TestCategory  ,ISNULL(apt.Remarks,'') as ViewRemarks,'' as ProviderAvailableTimeSlots,apt.Partner_orderid,'' as PhleboName,'' asPhleboTime,'' as PhleboContact                                     
  ,0                       
                        
  ,Concat(mem.FirstName,' ',mem.LastName),                      
  case when apt.VisitType='CV' THEN 'Center Visit'                      
  when  apt.VisitType='HV' THEN 'Home Visit'                      
  ELSE  apt.VisitType                      
  end AS  HomeCentrevisit,                      
  u.EmpNo,
  m.MobileNo,
   --IIF(@IsShowMaskData='Y',m.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](m.MobileNo)),
  fm.FacilityGroup,        
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=6) as ClosedateTime,   --1
  null as      ClosedateTime,
  null as StatusDate, 
  null as ConfirmationDate       
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=1) as StatusDate,     --2                     
  --(select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=2) as ConfirmationDate   --3      
  ,'',al.CreatedBy,                      
  (select Max(Remarks) from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=11),                      
    --select * from statusMaster  
	                                                   
  --(SELECT top 1 isnull(mpdi.TransactionId,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId                      
  -- where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId) , 

  mbb.transactionid  ,                   
                        
   --(SELECT top 1 isnull(mpdi.ModeOfPayment,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId                      
   --where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId) ,   
   
   utt.TransactionMedium,                   
                        
  (select isnull(pr.CityName,'') from provider where providerid=pr.ProviderId),                      
                      
  (select top 1 case when c.IsMetro = 'Y' then 'Metro' else 'Non-Metro' end as MetroNonMetro                       
  from city c join haportal.dbo.provider p on p.CityName=c.CityName                      
  where providerid=pr.ProviderId),                      
                        
  '' as ReportClosureTAT,
  '' as ReportPendingTAT,
  
  
        
 --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusDatetime,   
 null as PartialStatusDatetime,                
                    
  --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoshowDatetime, 
  null as NoshowDatetime,                                   
    
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusUpdatebyName,    
  null as  PartialStatusUpdatebyName,
      
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoShowUpdatedDatebyName,   
  null as  NoShowUpdatedDatebyName, 
                        
  ----(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=2 and AppointmentId=apt.AppointmentId) as ConfirmationByName,                       

  null  as ConfirmationByName, 
                      
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=8 and AppointmentId=apt.AppointmentId) as ReportPenidngbyName,   
  null as ReportPenidngbyName,                 
       
  --(select top 1 CreatedDate from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N')) as FollowupDateTime,  
  null as FollowupDateTime,  
                
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N') ) as FollowupUpdatebyName,  
  null as FollowupUpdatebyName,                  
             
  --(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationStatusDatetime,    
  null as DCConfirmationStatusDatetime,  
                
  --(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationUpdatebyDateTime,  
  null as DCConfirmationUpdatebyDateTime,
                  
                                    
   '',             
  --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledDateTime,  
  null as ReshduledDateTime,
                  
  --(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledUpdatedBy,      
  null as ReshduledUpdatedBy,
                        
  --(select top 1 CreatedBy from Appointmentlog al where ScheduleStatus=7 and AppointmentId=apt.AppointmentId ) as CancelledbyCustomerOrDC,   
  null as CancelledbyCustomerOrDC,                
                       
  '' as AppointmentConfirmationOutofTATWithinTAT,
  apt.AppointmentAddress,
  '' 

  
 ,  '' as HRName    
 , 
  CASE 
  WHEN u.SubClientName='Mylan Pharma Pre Employment' then 'Mylan Pharma Pre Employment' 
  WHEN u.SubClientName='Mylan Lab Pre Employment' then 'Mylan Lab Pre Employment' 
  ELSE '' END as 'SubClient' 
  ,null as First_Date_of_Appointment 
  ,null as ChangeAppDate_OR_RescheduleAptDate
  ,null as RescheduledReason
  ,null as    CancelReason            
  ,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,CAST(srh.RefundAmount as varchar(300))
 
                        
  from Appointment apt with (nolock)  
  left join ServiceRefundHistory srh with(nolock) on apt.AppointmentId=srh.Appointmentid
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                                              
  join UserLogin u with(nolock) on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                                                           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                               
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                                                               
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                                                                    
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                         
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                                                                     
  --join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                                       
  --join CorporatePlan cj with(nolock) on cj.CorporatePlanId=MPD.CorporatePlanId 
  
  
  join UserPlanDetails updd on updd.UserPlanDetailsId=apt.UserPlanDetailsId

  join MemberPLanBucket mpb on mpb.MemberPLanBucketId=apt.MemberPlanBucketID

  join CNPlanDetails cj on cj.CNPlanDetailsId=updd.CNPlanDetailsId

  left join  memberbucketbalance mbb on mbb.AppointmentId=apt.AppointmentId

  left join  UserTransactions utt on utt.TransactionId=mbb.TransactionId
  
                                                                                               
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                         
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                                                     
  left join city ct with (nolock) on apt.CityId=ct.CityId       
  join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                                                                    
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                                                                    
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                      
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                                                                
  left join LibertyEmpRegistration le with(nolock) on le.UserLoginId = u.UserLoginId                                                                                            
  left join UserTokan ut with(nolock) on ut.UserLoginId=u.UserLoginId                                             
   left join AppointmentLog al with(nolock) on al.AppointmentId=apt.AppointmentId                                                                                                
  where  (@Plan is null or updd.CNPlanDetailsId in(select * from SplitString(@Plan,',')))
  and (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                  
  and (@AppoinrmentFromDate is null and @AppoinrmentToDate is null OR 
  ad.AppointmentDateTime >= cast (@AppoinrmentFromDate as date ) and ad.AppointmentDateTime < dateadd(d,1,cast (@AppoinrmentToDate as date )))                  
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                                                    
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                              
  and apt.AppointmentType in ('HC')   
  and apt.MemberPlanBucketID is not null
 -----------plan refactor-------
                               
                                      
                             
  --update ww set ww.BookedBy=IIF(ISNULL(ww.Username,'') = ww.CustomerName,'Self',ww.Username) from #Temporary ww                                                                                                  
                                                        
  --update #Temporary                                                                       
  --set ProviderName = (select string_agg(pr.ProviderName,',')                                                       
  --from [HAPortal].dbo.Provider pr                                                       
  --where #Temporary.ProviderId = pr.ProviderId)                                                                  
                            
   ------------Delete duplicate caseno in temporary----------------------------                                                                                                    
----------------------------------------------------------------------------

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
from #Temporary T left join #Refunddata R on T.AppointmentId=R.AppointmentId
where  T.AppointmentId=R.AppointmentId
---------------------Refund Logic end------------------------------

  ;WITH cte AS (                                                                                                    
   SELECT *, ROW_NUMBER() OVER (                                                                                       
            PARTITION BY                                                                                                     
              CaseNo,FacilityType                                                                                                   
           ORDER BY                                                                              
             CaseNo,FacilityType                                                                                                   
        ) row_num                                                                                                    
     FROM #Temporary                                            
   )                                                      
   DELETE FROM cte                                                                                                    
   WHERE row_num > 1;                                          
---------------------------------------------------------------------------                                                                                       
--------------------------End Delete duplicate caseno logic----------------                                             
                                                                          
   SELECT t.AppointmentId,                                                                                                        
   MAX(AppointmentDateTime)  AS AppointmentDate                               
   INTO #TEMP                                                                                                        
   FROM #TEMPORARY T                                    
   JOIN AppointmentDetails AD                                                                                                        
   ON T.AppointmentId = AD.AppointmentId                                                    
   GROUP BY T.AppointmentId                                        
                                                               
   UPDATE #Temporary                                                                                                        
   SET AppointmentDate = T.AppointmentDate                                                                                                        
   FROM #TEMP T                                                                                                        
   WHERE T.AppointmentId = #Temporary.AppointmentId                                                                 
                                                               
                                                               
------------------------testname-----------------                                                            
   UPDATE #Temporary SET TestName =  STUFF((SELECT distinct ', ' + CAST(f1.FacilityNAme AS VARCHAR(max)) [text()]                                                                
   FROM PackageTestMaster p                                                                 
   join facilitiesMaster f1 on p.TestId=f1.FacilityId                                                                
   WHERE PackageId = t.FacilityId AND isSearch = 'N'                                                                
   FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') FROM #Temporary t --where FacilityType='PACKAGE' ;                                                              
                                                              
   -- UPDATE #Temporary SET FacilityId =  STUFF((SELECT distinct ', ' + CAST(f1.FacilityId AS VARCHAR(max)) [text()]                                                                
   --FROM PackageTestMaster p                                                                 
   --join facilitiesMaster f1 on p.TestId=f1.FacilityId                                                                
   --WHERE PackageId = t.FacilityId AND isSearch = 'N'                                                  
   --FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') FROM #Temporary t                                                       
                                                        
    UPDATE #Temporary SET TestName =                                                           
    ( SELECT                                                        
    STRING_AGG(fm.FacilityName, ',')                                                         
    WITHIN GROUP (ORDER BY fm.FacilityName DESC)                                                        
    from appointment a                                                         
    join AppointmentDetails ad on a.appointmentid=ad.AppointmentId                                                        
    join FacilitiesMaster fm on fm.FacilityId=ad.TestId                                                        
    where  a.AppointmentId= #Temporary.AppointmentId    --and #Temporary.FacilityType='TEST'                                             
    GROUP BY ad.AppointmentId )                                                         
                                                            
-------Packagename                                                            
                                                            
                                                            
 UPDATE #Temporary SET  PackageName=                                                             
 (select fm.facilityname from FacilitiesMaster fm join AppointmentDetails ad                                                            
 on fm.Facilityid=ad.PakageId                                                  
 where ad.PakageId=#Temporary.FacilityId and #Temporary.FacilityType='PACKAGE'                                                            
 group by fm.facilityname)     
 

 --select top 100 * from  #Temporary
                                                        
-------------PartialTestNames                                                        
                                                        
   UPDATE #Temporary SET  PartialShowTests =   ( SELECT                                                        
    STRING_AGG(FM.FacilityName, ',')                                                         
    WITHIN GROUP (ORDER BY FM.FacilityName DESC)                                                
    from appointment a                                   
    join AppointmentDetails ad on a.appointmentid=ad.AppointmentId                                             
    join FacilitiesMaster fm on fm.FacilityId=ad.TestId                                                        
    where ad.TestCompletionStatus=4 and a.AppointmentId=#Temporary.AppointmentId                                      
    GROUP BY ad.AppointmentId )                                                       
--select * from #Temporary where AppointmentId=                                                       
            --select * from #Temporary where CaseNo= #Temporary.CaseNo                                                                                                   
                                           
-------------visit support                                                      
                                 
UPDATE #Temporary SET  visittype=                                                         
(                                                      
select                                                       
CASE                                                      
    WHEN visittype = 'CV' THEN 'Center Visit'                                                      
    WHEN visittype = 'HV' THEN 'Home Visit'                                                      
 WHEN visittype = 'DC' THEN 'Center Visit'                                
    ELSE ''                                                      
END AS VisitType                                                      
FROM Appointment where AppointmentId=#Temporary.AppointmentId  )                                                      
                                                        
-------------------TAT--------------------                                                            
                                                                
update #Temporary                                                                
set CnfDt = (select max(CreatedDate) as CreatedDate from AppointmentLog al where ScheduleStatus=1 and al.AppointmentId=#Temporary.AppointmentId)                                                                
   
update #Temporary                                        
set TAT = (CAST(DATEDIFF(ss,  CnfDt, GETDATE()) / 3600 AS VARCHAR(10)) + ' hr ' +                                                       
CAST((DATEDIFF(ss,  CnfDt, GETDATE()) -  3600 * (DATEDIFF(ss,  CnfDt, GETDATE()) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )                                                                
      
UPDATE #Temporary SET  AppointmentConfirmationOutofTATWithinTAT = 'Within TAT'                                                        
from Appointment a where a.appointmentid=#Temporary.AppointmentId and DATEDIFF(HH,StatusDate,ConfirmationDate)<=1        
        
UPDATE #Temporary SET  AppointmentConfirmationOutofTATWithinTAT = 'OutOf TAT'                                                        
from Appointment a where a.appointmentid=#Temporary.AppointmentId and DATEDIFF(HH,StatusDate,ConfirmationDate)>1        
--update #Temporary                                        
--set AppointmentConfirmationTAT = (select max(CreatedDate) as CreatedDate from AppointmentLog al where ScheduleStatus=1 and al.AppointmentId=#Temporary.AppointmentId)                                                                
                        
 ---------------ReportClosureTAT--                        
 UPDATE #Temporary                                        
SET ReportClosureTAT =  (CAST(DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) / 3600 AS VARCHAR(10)) + ' hr ' +                                                       
CAST((DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) -  3600 * (DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )                                          
            
                         
 --------------------------End ReportClosureTAT---------                        
 UPDATE #Temporary                                        
SET ReportPendingTAT =  (CAST(DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) / 3600 AS VARCHAR(10)) + ' hr ' +                                                       
CAST((DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) -  3600 * (DATEDIFF(ss,  ConfirmationDate, ClosedDateTime) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )                                                                                                    
  
    
      
         
                                                       
 ------------------ProviderResponse--------------------                                                        
UPDATE #Temporary  SET  ProviderResponse= (                                                       
  CASE                                                       
 WHEN ISNULL(T.DCConfirmationStage, T.DCConfirmationFlag) = 'U' THEN 'REPORT UPLOADED'                                                      
 WHEN ISNULL(T.DCConfirmationStage, T.DCConfirmationFlag) = 'S' THEN 'SHOW'                                                      
 WHEN ISNULL(T.DCConfirmationStage, T.DCConfirmationFlag) = 'N' THEN 'NO SHOW'                                                      
 WHEN ISNULL(T.DCConfirmationStage, T.DCConfirmationFlag) = 'A' THEN 'PROVIDER ACCEPTED'                                                      
 WHEN ISNULL(T.DCConfirmationStage, T.DCConfirmationFlag) = 'R' THEN 'PROVIDER REJECTED'                                                      
 ELSE                                                       
 IIF(                                                      
 ISNULL((SELECT top 1 providerid from [HAPortal].[dbo].[WhatsAppIntegrationProviders] WHERE providerid=ad.ProviderId),0) = ad.providerId                                                       
 AND EXISTS(SELECT top 1 * FROM appointment WHERE appointmentid=T.Appointmentid                                                       
 AND CreatedDate > '2023-01-10' AND T.ScheduleStatus = 1 ) ,'Waiting for DC Confirmation','')                                                       
    END ) --AS ProviderResponse                                                      
FROM Appointment T                                                       
join AppointmentDetails ad on T.AppointmentId=ad.AppointmentId where T.AppointmentId=#Temporary.AppointmentId                                                        
                                            
                                                      
                                                 
------------------ProviderAvailableTimeSlots -----------------------------------------                                                      
UPDATE #Temporary  SET ProviderAvailableTimeSlots=                                                      
(                                                        
 SELECT STRING_AGG( CONCAT( FromTime, ' - ', ToTime),',') AS Timselot FROM Appointment                                                   
 INNER JOIN HAPortal.dbo.ProviderTimeSlotsMaster TimeSlots                                                       
 ON TimeSlots.ProviderTimeSlotMasterId IN ( SELECT Item FROM SplitString(Appointment.ProviderAvailableTimeSlots,',') )                                                      
 WHERE DCConfirmationFlag in ('R') and appointmentId =#Temporary.AppointmentId                                                        
)                                      
                                         
                                                      
 ----------------------------------------------------------------------------------                                                       
 UPDATE #Temporary                                        
SET AppointmentConfirmationTAT = (CAST(DATEDIFF(ss,  StatusDate, ConfirmationDate) / 3600 AS VARCHAR(10)) + ' hr ' +                                                       
CAST((DATEDIFF(ss, StatusDate, ConfirmationDate) -  3600 * (DATEDIFF(ss,  StatusDate, ConfirmationDate) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )                                                          
       
--Declare @UpdatedDate datetime;
--set @UpdatedDate =(select * from Appointmentlog al where al.AppointmentId=#Temporary.AppointmentId)
UPDATE #Temporary                                        
SET FristResponseTimeonRequest = (CAST(DATEDIFF(ss,  StatusDate, ConfirmationDate) / 3600 AS VARCHAR(10)) + ' hr ' +                                                       
CAST((DATEDIFF(ss, StatusDate, ConfirmationDate) -  3600 * (DATEDIFF(ss,  StatusDate, ConfirmationDate) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )                                                          
                                                       
                                                      
                                                       
 -----------------TestCategory by deepak-----------------------------------------------------                                                        
 UPDATE t SET t.TestCategory='Package with Test' from #Temporary t join(select t,AppointmentId from(select IIF(fm.facilitytype='PACKAGE',1,1) t,ap.AppointmentId from AppointmentDetails ap join FacilitiesMaster fm on fm.Facilityid= iif (ISNULL(ap.PakageId 
  
    
     
         
,0)<>0,ap.pakageid,ap.testid)                                                      
group by fm.facilitytype,ap.AppointmentId) p                                                       
group by t,p.AppointmentId having SUM(t)=2) a on t.AppointmentId=a.AppointmentId and Isnull(t.TestCategory,'') = ''                                                      
                                                       
 UPDATE t SET t.TestCategory='Multiple Test' from #Temporary t join                                                       
(select AppointmentId,count(AppointmentId) c from AppointmentDetails where isnull(pakageid,0)=0 and isnull(testid,0)<>0                                                      
group by AppointmentId having count(AppointmentId)>1) a on t.AppointmentId=a.AppointmentId   and Isnull(t.TestCategory,'') = ''                                                      
                                                      
                                                      
UPDATE l SET l.TestCategory=p.TestCategory from #Temporary l join (select distinct case                                                       
when t.FacilityType='Package' then  'Single Package'                                                      
when t.FacilityType='Test' then  'Single Test'  else ''                                                      
end as TestCategory,t.appointmentid from (select fm.FacilityType,ad.appointmentid from  appointmentdetails ad join FacilitiesMaster fm                                      
on fm.FacilityId= iif (isnull(ad.pakageid,0)=0,ad.TestId,ad.pakageid)                                                      
group by fm.FacilityType,ad.appointmentid) t) p on p.AppointmentId=l.AppointmentId  and Isnull(l.TestCategory,'') = ''                                                      
--UPDATE t set UserCurrentLocation= CONCAT(A.UserCurrentCity_State,IIF(A.UserCurrentPincode is not null,CONCAT(',',A.UserCurrentPincode),A.UserCurrentPincode))
--from #Temporary t join Appointment A on t.AppointmentId=A.AppointmentId
                                  
                                                      
  -----------ADDED BY SAYALI FOR HAP-2121 ON 22 SEP 2023-----------
  update #Temporary  
  SET HRName=   (select string_agg(ul.ClientHrName,',')                                                       
  from userlogin ul                                                    
  where #Temporary.UserLoginId = ul.UserLoginId and ul.ClientId=337) 
  ------------ENDED BY SAYALI FOR HAP-2121 ON 22 SEP 2023----------- 
                                                      
 ---------------------------------------------------------------------------------------------------------------------------------  
------------------------------------------26-12-2023-----------------------------------------------------------------------
--------------------------------****Closed Date logic started***********------------------------------------------------------------
  select t.Appointmentid	,t.CaseNo 
  into #tempclosed
   from #Temporary t 
   where t.StatusName='closed'  
   
   --select * from  #tempclosed;   
 
create table #tempclosedlog (Logid int,appointmentid bigint,Closeddate datetime)  
insert into #tempclosedlog 
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as closeddate
from appointmentlog
where ScheduleStatus=6 
and appointmentid in ( select appointmentid from #tempclosed) 
group by   appointmentid  

--select * from   #tempclosedlog;

update  a
set    a.Closeddate = al.CreatedDate 
from appointmentlog al 
left join #tempclosedlog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempclosedlog;  

update #Temporary
set ClosedDateTime=t.Closeddate
from   #tempclosedlog t
where t.appointmentid= #Temporary.AppointmentId

--------------------------------****status Date logic started***********------------------------------------------------------------
--------------------------------****01-05-2024***********------------------------------------------------------------
  select t.Appointmentid	,t.CaseNo 
  into #tempapttatt
   from #Temporary t 
   
   
   --select * from  #tempapttatt;   
 
----------------rquested date
create table #tempRequestlog (Logid int,appointmentid bigint,RequestedDate datetime)  
insert into #tempRequestlog 
select min(appointmentlogid) as 'LogId',appointmentid ,'' as RequestedDate
from appointmentlog
where ScheduleStatus=1
and appointmentid in ( select appointmentid from #tempapttatt) 
group by   appointmentid  

--select * from   #tempconfirmtatlog;

update  a
set    a.RequestedDate = al.CreatedDate 
from appointmentlog al 
left join #tempRequestlog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempRequestlog;  


----------------confirmed date
create table #tempConfirmmlog (Logid int,appointmentid bigint,ConfirmationDate datetime)  
insert into #tempConfirmmlog 
select max(appointmentlogid) as 'LogId',appointmentid ,'' as ConfirmationDate
from appointmentlog
where ScheduleStatus=2
and appointmentid in ( select appointmentid from #tempapttatt) 
group by   appointmentid  

--select * from   #tempConfirmmlog;

update  a
set    a.ConfirmationDate = al.CreatedDate 
from appointmentlog al 
left join #tempConfirmmlog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempConfirmmlog;  


select a.AppointmentId,b.RequestedDate,c.ConfirmationDate,datediff(MINUTE,b.RequestedDate,c.ConfirmationDate) as minutediff

into #apttatafinaldata
from #tempapttatt a 
left join #tempRequestlog b on a.AppointmentId=b.appointmentid
left join #tempConfirmmlog c on a.AppointmentId=c.appointmentid

--select * from #apttatafinaldata;

--CREATE TABLE #fconapt(AppointmentId int,RequestedDate varchar(100),ConfirmationDate varchar(100),ConfirmTat varchar(100))
--insert into #fconapt
--select a.AppointmentId,a.RequestedDate,a.ConfirmationDate,case when a.minutediff is not null then  concat(a.minutediff, ' ','Minute') else a.minutediff end as 'ConfirmTat'
--from #apttatafinaldata a 

--select * from #fconapt;

update #Temporary
set AppointmentConfirmationTAT=t.minutediff
from   #apttatafinaldata t
where t.appointmentid= #Temporary.AppointmentId




select a.appointmentid,a.minutediff,case when minutediff <=30 then 'Within TAT' when minutediff > 30 then 'OutOf TAT'  end as AppointmentConfirmationOutofTATWithinTAT
into #outoftataORwithinTAT
from #apttatafinaldata a

--select * from #outoftataORwithinTAT;

update #Temporary
set AppointmentConfirmationOutofTATWithinTAT=t.AppointmentConfirmationOutofTATWithinTAT
from   #outoftataORwithinTAT t
where t.appointmentid= #Temporary.AppointmentId


-----------------------------------appointmnet close date--------------------------
 select t.Appointmentid	,t.CaseNo 
  into #tempapttattclose
   from #Temporary t 
   
   
   --select * from  #tempapttattclose;   
 
----------------rquested date
create table #tempclosealog (Logid int,appointmentid bigint,RequestedDate datetime)  
insert into #tempclosealog 
select min(appointmentlogid) as 'LogId',appointmentid ,'' as RequestedDate
from appointmentlog
where ScheduleStatus=1
and appointmentid in ( select appointmentid from #tempapttattclose) 
group by   appointmentid  

--select * from  #tempclosealog;

update  a
set    a.RequestedDate = al.CreatedDate 
from appointmentlog al 
left join #tempclosealog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempclosealog;  


----------------closed date
create table #tempclosemmlog (Logid int,appointmentid bigint,ClosedDate datetime)  
insert into #tempclosemmlog 
select max(appointmentlogid) as 'LogId',appointmentid ,'' as ConfirmationDate
from appointmentlog
where ScheduleStatus=6
and appointmentid in ( select appointmentid from #tempapttattclose) 
group by   appointmentid  

--select * from   #tempclosemmlog;

update  a
set    a.ClosedDate = al.CreatedDate 
from appointmentlog al 
left join #tempclosemmlog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempclosemmlog;  


select a.AppointmentId,b.RequestedDate,c.ClosedDate,datediff(MINUTE,b.RequestedDate,c.ClosedDate) as minutediff

into #apttatafinaldataabclose
from #tempapttattclose a 
left join #tempclosealog b on a.AppointmentId=b.appointmentid
left join #tempclosemmlog c on a.AppointmentId=c.appointmentid

--select * from #apttatafinaldataabclose;

update #Temporary
set ReportClosureTAT= t.minutediff
from   #apttatafinaldataabclose t
where t.appointmentid= #Temporary.AppointmentId


--------------------------------****01-05-2024***********------------------------------------------------------------


  select t.Appointmentid	,t.CaseNo 
  into #tempstatus
   from #Temporary t 
  
   
   --select * from  #tempstatus;   
 
create table #tempstatuslog (appointmentid bigint,Requesteddate datetime)  
insert into #tempstatuslog 
select appointmentid ,'' as Requesteddate
from appointment
where appointmentid in ( select appointmentid from #tempstatus) 
group by   appointmentid  

--select * from  #tempstatuslog;

update  a
set   a.Requesteddate = ap.CreatedDate
from appointment ap
left join #tempstatuslog a on ap.AppointmentId=a.appointmentid
where   ap.AppointmentId=a.appointmentid

--select * from  #tempstatuslog;  

update #Temporary
set StatusDate=t.Requesteddate
from   #tempstatuslog t
where t.appointmentid= #Temporary.AppointmentId

--------------------------------****Confirmed Date logic started***********------------------------------------------------------------

  select t.Appointmentid	,t.CaseNo 
  into #tempConfirmed
   from #Temporary t 

   
--select * from #tempConfirmed;   
 
create table  #tempConfirmedlog (Logid int,appointmentid bigint,Confirmeddate datetime)  
insert into  #tempConfirmedlog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as Confirmeddate
from appointmentlog
where ScheduleStatus=2 
and appointmentid in ( select appointmentid from #tempConfirmed) 
group by   appointmentid  

--select * from #tempConfirmedlog;

update  a
set    a.Confirmeddate = al.CreatedDate 
from appointmentlog al 
left join  #tempConfirmedlog a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from  #tempConfirmedlog;  

update #Temporary
set ConfirmationDate=t.Confirmeddate
from   #tempConfirmedlog t
where t.appointmentid= #Temporary.AppointmentId

-------------------27 dec 2023-----------------------------------------------------------   

   select t.Appointmentid	,t.CaseNo ,t.PartialStatusDatetime,t.NoshowDatetime,t.PartialStatusUpdatebyName,
   t.NoShowUpdatedDatebyName,t.ConfirmationByName,t.ReportPenidngbyName,t.FollowupDateTime,
   t.FollowupUpdatebyName,t.DCConfirmationStatusDatetime,t.DCConfirmationUpdatebyDateTime,
   t.ReshduledDateTime,t.ReshduledUpdatedBy,t.CancelledbyCustomerOrDC
  into #tempcheckdata
   from #Temporary t  
   
   --select * from  #tempcheckdata;  

 --  select top 1 CreatedDate from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId
     
create table  #tempPartialStatuslog (Logid int,appointmentid bigint,PartialStatusdate datetime)  
insert into   #tempPartialStatuslog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as PartialStatusdate
from appointmentlog
where ScheduleStatus=4
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set    a.PartialStatusDatetime = al.CreatedDate 
from appointmentlog al 
left join #tempPartialStatuslog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

--(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoshowDatetime, 

create table  #tempNoshowDatetimelog (Logid int,appointmentid bigint,NoshowDatetime datetime)  
insert into  #tempNoshowDatetimelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as NoshowDatetime
from appointmentlog
where ScheduleStatus=3
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.NoshowDatetime = al.CreatedDate 
from appointmentlog al 
left join #tempNoshowDatetimelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

----(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusUpdatebyName,    

create table #tempPartialStatusUpdatebyNamelog (Logid int,appointmentid bigint,PartialStatusUpdatebyName varchar(100))  
insert into #tempPartialStatusUpdatebyNamelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as PartialStatusUpdatebyName
from appointmentlog
where ScheduleStatus=4
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.PartialStatusUpdatebyName = al.createdby
from appointmentlog al 
left join #tempPartialStatusUpdatebyNamelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

----(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoShowUpdatedDatebyName,

create table #tempNoShowUpdatedDatebyNamelog (Logid int,appointmentid bigint,NoShowUpdatedDatebyName varchar(100))  
insert into #tempNoShowUpdatedDatebyNamelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as NoShowUpdatedDatebyName
from appointmentlog
where ScheduleStatus=3
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.NoShowUpdatedDatebyName = al.createdby
from appointmentlog al 
left join #tempNoShowUpdatedDatebyNamelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

----(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=2 and AppointmentId=apt.AppointmentId) as ConfirmationByName,      
create table #tempConfirmationByNamelog (Logid int,appointmentid bigint,ConfirmationByName varchar(100))  
insert into #tempConfirmationByNamelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as ConfirmationByName
from appointmentlog
where ScheduleStatus=2
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.ConfirmationByName = al.createdby
from appointmentlog al 
left join #tempConfirmationByNamelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid


--(select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=8 and AppointmentId=apt.AppointmentId) as ReportPenidngbyName,  

create table #tempReportPenidngbyNamelog (Logid int,appointmentid bigint,ReportPenidngbyName varchar(100))  
insert into #tempReportPenidngbyNamelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as ReportPenidngbyName
from appointmentlog
where ScheduleStatus=8
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.ReportPenidngbyName = al.createdby
from appointmentlog al 
left join #tempReportPenidngbyNamelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

----(select top 1 CreatedDate from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N')) as FollowupDateTime, 
 
create table #tempFollowupDateTimelog (Logid int,appointmentid bigint,FollowupDateTime datetime)  
insert into #tempFollowupDateTimelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as FollowupDateTime
from appointmentlog
where DCConfirmationStage in('S','N') 
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.FollowupDateTime = al.CreatedDate
from appointmentlog al 
left join #tempFollowupDateTimelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

--(select top 1 isnull(CreatedBy,'') from Appointmentlog where AppointmentId=apt.AppointmentId and DCConfirmationStage in('S','N') ) as FollowupUpdatebyName,  

create table #tempFollowupUpdatebyNamelog (Logid int,appointmentid bigint,FollowupUpdatebyName varchar(100))  
insert into #tempFollowupUpdatebyNamelog 
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as FollowupUpdatebyName
from appointmentlog
where DCConfirmationStage in('S','N') 
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set   a.FollowupUpdatebyName = al.CreatedBy
from appointmentlog al 
left join #tempFollowupUpdatebyNamelog  p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

--(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationStatusDatetime,    



update  a
set   a.DCConfirmationStatusDatetime = al.CreatedDate 
from appointmentlog al 
join Appointment ap on ap.AppointmentId=al .AppointmentId
left join #tempcheckdata a on a.AppointmentId=ap.AppointmentId
where ap.DCConfirmationFlag in('A','R') 
and ap.appointmentid=a.appointmentid


  --(select top 1 applog.CreatedDate from Appointmentlog applog join Appointment a on a.AppointmentId=applog.AppointmentId where a.DCConfirmationFlag in('A','R') and a.AppointmentId=apt.AppointmentId ) as DCConfirmationUpdatebyDateTime, 


update  a
set   a.DCConfirmationUpdatebyDateTime = al.CreatedDate 
from appointmentlog al 
join Appointment ap on ap.AppointmentId=al .AppointmentId
left join #tempcheckdata a on a.AppointmentId=ap.AppointmentId
where ap.DCConfirmationFlag in('A','R') 
and ap.appointmentid=a.appointmentid

--(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledDateTime,

    
create table  #tempReshduledDateTimelog (Logid int,appointmentid bigint,ReshduledDateTime datetime) 
insert into  #tempReshduledDateTimelog
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as  ReshduledDateTime
from appointmentlog
where ScheduleStatus=10
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set    a.ReshduledDateTime = al.CreatedDate 
from appointmentlog al 
left join  #tempReshduledDateTimelog p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid

--(select top 1 CreatedBy from Appointmentlog al where ScheduleStatus=7 and AppointmentId=apt.AppointmentId ) as CancelledbyCustomerOrDC,  

create table  #tempCancelledbyCustomerOrDClog (Logid int,appointmentid bigint,CancelledbyCustomerOrDC datetime) 
insert into #tempCancelledbyCustomerOrDClog 
select Max(appointmentlogid) as 'LogId',appointmentid ,'' as  CancelledbyCustomerOrDC
from appointmentlog
where ScheduleStatus=7
and appointmentid in ( select appointmentid from #tempcheckdata) 
group by   appointmentid  


update  a
set    a.CancelledbyCustomerOrDC = al.CreatedBy
from appointmentlog al 
left join  #tempCancelledbyCustomerOrDClog   p on p.Logid=al.AppointmentLogId
left join #tempcheckdata a on a.AppointmentId=p.appointmentid
where   al.AppointmentLogId= p.Logid



-------------------------------------------------
  

-------------Logic for [First Date of Appointment] started ------------------------------------

create table  #firstaptdatelog (Logid int,appointmentid bigint,FirstAppointmentDate datetime)  
insert into  #firstaptdatelog
select Min(appointmentlogid) as 'LogId',appointmentid ,'' as FirstAppointmentDate
from appointmentlog
where ScheduleStatus=1
and appointmentid in ( select appointmentid from #tempConfirmed) 
group by   appointmentid  

--select * from #firstaptdatelog;

create table  #firstaptdate (AppointmentLogDetailsId int,AppointmentLogId bigint,AppointmentDateTime datetime)  
insert into  #firstaptdate
select Min(AppointmentLogDetailsId) as 'AppointmentLogDetailsId',AppointmentLogId ,'' as FirstAppointmentDate
from AppointmentLogDetails
where AppointmentLogId in ( select LogId from #firstaptdatelog) 
group by   AppointmentLogId  

--select * from #firstaptdate;

---****update in #firstaptdate table*****---------

update  a
set    a.AppointmentDateTime = al.AppointmentDateTime 
from AppointmentLogDetails al 
left join  #firstaptdate a on al.AppointmentLogDetailsId=a.AppointmentLogDetailsId
where  al.AppointmentLogDetailsId=a.AppointmentLogDetailsId 

--select * from  #firstaptdate;  

-----update in #firstaptdatelog table

update  a
set    a.FirstAppointmentDate = al.AppointmentDateTime 
from #firstaptdate al 
left join  #firstaptdatelog a on al.AppointmentLogId=a.Logid
where al.AppointmentLogId=a.Logid

--select * from #firstaptdatelog;

update #Temporary
set First_Date_of_Appointment =t.FirstAppointmentDate
from   #firstaptdatelog t
where t.appointmentid= #Temporary.AppointmentId



-------------Logic for [First Date of Appointment] ended ------------------------------------
-------------Logic for [Change App Date/ Reschedule] started ------------------------------------

create table  #Rescheduleaptdatelog (Logid int,appointmentid bigint,FirstAppointmentDate datetime)  
insert into  #Rescheduleaptdatelog
select Min(appointmentlogid) as 'LogId',appointmentid ,'' as FirstAppointmentDate
from appointmentlog
where Remarks='Reschedule'
and appointmentid in ( select appointmentid from #tempConfirmed) 
group by   appointmentid  

--select * from #Rescheduleaptdatelog;

create table  #Rescheduleaptdate (AppointmentLogDetailsId int,AppointmentLogId bigint,AppointmentDateTime datetime)  
insert into  #Rescheduleaptdate
select Min(AppointmentLogDetailsId) as 'AppointmentLogDetailsId',AppointmentLogId ,'' as FirstAppointmentDate
from AppointmentLogDetails
where AppointmentLogId in ( select LogId from #Rescheduleaptdatelog) 
group by   AppointmentLogId  

--select * from #Rescheduleaptdate;

---****update in #firstaptdate table*****---------

update  a
set    a.AppointmentDateTime = al.AppointmentDateTime 
from AppointmentLogDetails al 
left join  #Rescheduleaptdate a on al.AppointmentLogDetailsId=a.AppointmentLogDetailsId
where  al.AppointmentLogDetailsId=a.AppointmentLogDetailsId 

--select * from  #Rescheduleaptdate;  

-----update in #firstaptdatelog table

update  a
set    a.FirstAppointmentDate = al.AppointmentDateTime 
from #Rescheduleaptdate al 
left join  #Rescheduleaptdatelog a on al.AppointmentLogId=a.Logid
where al.AppointmentLogId=a.Logid

--select * from #Rescheduleaptdatelog;

update #Temporary
set ChangeAppDate_OR_RescheduleAptDate=t.FirstAppointmentDate
from   #Rescheduleaptdatelog t
where t.appointmentid= #Temporary.AppointmentId



-------------Logic for [Change App Date/ Reschedule] ended ------------------------------------
-------------Logic for [ Reschedule Reason] started ------------------------------------

create table  #RescheduleReason (Logid int,appointmentid bigint,RescheduleReason varchar(max))  
insert into  #RescheduleReason
select Min(appointmentlogid) as 'LogId',appointmentid ,'' as RescheduleReason
from appointmentlog
where Remarks='Reschedule'
and appointmentid in ( select appointmentid from #tempConfirmed) 
group by   appointmentid  

--select * from #RescheduleReason;

update  a
set    a.RescheduleReason = concat(al.Remarks,' ',al.StatusReason )
from appointmentlog al 
left join  #RescheduleReason a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from #RescheduleReason;

update #Temporary
set RescheduledReason=t.RescheduleReason
from   #RescheduleReason t
where t.appointmentid= #Temporary.AppointmentId



-------------Logic for [ Reschedule Reason] ended ------------------------------------
-------------Logic for [CancelReason] started ------------------------------------

create table  #CancelReason (Logid int,appointmentid bigint,CancelReason varchar(max))  
insert into  #CancelReason
select Min(appointmentlogid) as 'LogId',appointmentid ,'' as CancelReason
from appointmentlog
where ScheduleStatus=7
and appointmentid in ( select appointmentid from #tempConfirmed) 
group by   appointmentid  

--select * from #CancelReason;

update  a
set    a.CancelReason = concat(al.Remarks,' ',al.StatusReason )
from appointmentlog al 
left join  #CancelReason a on al.AppointmentLogId=a.LogId
where   al.AppointmentLogId=  a.LogId    

--select * from #CancelReason;

update #Temporary
set CancelReason=t.CancelReason
from   #CancelReason t
where t.appointmentid= #Temporary.AppointmentId



-------------Logic for [CancelReason] ended ------------------------------------


update #Temporary
set 
--ConfirmationDate=t.PartialStatusDatetime,
NoshowDatetime=t.NoshowDatetime,
PartialStatusUpdatebyName=t.PartialStatusUpdatebyName,
NoShowUpdatedDatebyName=t.NoShowUpdatedDatebyName,
ConfirmationByName=t.ConfirmationByName,
ReportPenidngbyName=t.ReportPenidngbyName,
FollowupDateTime=t.FollowupDateTime,
FollowupUpdatebyName=t.FollowupUpdatebyName,
DCConfirmationStatusDatetime=t.DCConfirmationStatusDatetime,
DCConfirmationUpdatebyDateTime=t.DCConfirmationUpdatebyDateTime,
ReshduledDateTime=t.ReshduledDateTime,
ReshduledUpdatedBy=	t.ReshduledUpdatedBy,
CancelledbyCustomerOrDC=t.CancelledbyCustomerOrDC
from   #tempcheckdata t
where t.appointmentid= #Temporary.AppointmentId



/*******************End Main Logic****************************************************/                                                                                                    
--------------------------------------------------------------------------------------                                                                               
                                                                                                    
                                                                                                    
                                                                                                       
  /*****************Select All table*************************************************/                                                                                                    
   print @FromDate                          
   print @ToDate 
                                                                                                
   --select   distinct * from #Temporary                                                       
   --ORDER BY AppointmentId DESC                                     
   --offset @myoffset rows                                                                                                                      
   --FETCH NEXT @RecordPerPage rows only          
   
   select   distinct AppointmentId	,CaseNo	,AppointmentType	,UserLoginId,	MemberId	,CustomerName,	
   EmailId,
  MobileNo,
  -- IIF(@IsShowMaskData='Y',EmailId,[dbo].[GetMaskedEmail](EmailId)),
   --IIF(@IsShowMaskData='Y',MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](MobileNo)),
   Gender	,FacilityName	,StatusName	,ProviderId	,ProviderName,	RequestedDate	,Clientid,	ClientName,	AppointmentDate	
   ,ClientType	,ProviderMobileNo	,ISHNI,	UpdatedBy	,Relation	,
  Username,
  --IIF(@IsShowMaskData='N',[dbo].[GetMaskedEmail](Username) ,Username),
   AgentName,	
  --AgentMobileNo	,
  IIF(@IsShowMaskData='Y',AgentMobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](AgentMobileNo)),

   DocCoachApptType,	AppDeviceType,	PlanName	,BookedBy,	LoginUserName	,PointOfContactName	
   ,LastCallStatus,	ProviderAddress	,IsPrescriptionConsent,	MemberPlanId,	UserHomeVisitAddress,	VisitType,	TestName,	FacilityId	,FacilityType	,TAT,	CnfDt	,LastUpdatedDate	,AppVersion	,PackageName,	PartialShowTests	,ProviderResponse,	DCConfirmationFlag,	DCConfirmationStage,	TestCategory	,ViewRemarks	,ProviderAvailableTimeSlots,	PartnerOrderId,	PhleboName,	PhleboTime	,PhleboContact	,MemberPaymentDetailsId,	MemberName	,HomeCentrevisit	,Empno	,EmpContactNo,	FacilityGroupName	,ClosedDateTime,	StatusDate,	ConfirmationDate
   	
   ,case when AppointmentConfirmationTAT is not null then concat(AppointmentConfirmationTAT,' ','Minute')
         when AppointmentConfirmationTAT is null then AppointmentConfirmationTAT 
		 END as AppointmentConfirmationTAT

   ,	CreatedBy	,OnHoldReason	,TranId	,PaymentMode	,DCCity	,MetroNonMetro	
    ,case when ReportClosureTAT is not null then concat(ReportClosureTAT,' ','Minute')
         when ReportClosureTAT is null then ReportClosureTAT 
		 END as ReportClosureTAT

   ,	ReportPendingTAT	,PartialStatusDatetime,	NoshowDatetime	,PartialStatusUpdatebyName	,NoShowUpdatedDatebyName	,ConfirmationByName	,ReportPenidngbyName,	FollowupDateTime,	FollowupUpdatebyName	,DCConfirmationStatusDatetime,	DCConfirmationUpdatebyDateTime	,FristResponseTimeonRequest	,ReshduledDateTime,	ReshduledUpdatedBy	,CancelledbyCustomerOrDC,	AppointmentConfirmationOutofTATWithinTAT,	AppointmentAddress	,RoutineNonRoutine,	HRName,	SubClient	,First_Date_of_Appointment,	ChangeAppDate_OR_RescheduleAptDate,	RescheduledReason	,CancelReason	,RefundId,	RefundRemark,	RefundAmount,	RefundDoneBy
 from #Temporary                                                       
   ORDER BY AppointmentId DESC                                     
   offset @myoffset rows                                                                                                                      
   FETCH NEXT @RecordPerPage rows only                                                     
                                                                         
                                                                              
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                                                           
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                                                    
                                      
                                                                                                       
/*****************End Select All Table********************************************/                                                                                                    
   drop table #Temporary                                                                       
   drop table #TEMP 
   


                                                        
End