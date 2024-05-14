USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPgetVaccinationMISReport_OPS]    Script Date: 4/18/2024 5:58:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- [USPgetVaccinationMISReport_OPS] '2016-01-01','2023-08-07',null,null,1,5,null
ALTER PROCEDURE [dbo].[USPgetVaccinationMISReport_OPS]                       
                                                   
 @FromDate datetime = null,                                                                                            
 @ToDate datetime =null,                                                                                            
 @Plan varchar(100)=null,                                                                                                                    
 @ClientId varchar(100)=null,                                                                                              
 @pageNumber int=1,  --page Number                                                                                                                
 @recordPerPage int=20000,                                                                                               
 @AppointmentStatus varchar(100) = null                                                                                   
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
                                                                                     
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,20000)                      
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,20000)                       
                                                                                     
   set @myoffset=((@recordPerPage * @pageNumber) - @recordPerPage ) + 0;                                                  
   print @myoffset                                                   
                                          
/***************************Start Declare Table**************************************************************/                                                                                              
     
    Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),
	                         EmailId varchar(100),MobileNo varchar(100),Gender varchar(10),FacilityName varchar(5000),StatusName varchar(100),ProviderId bigint,
							 ProviderName varchar(200),RequestedDate VARCHAR(50),Clientid int,ClientName varchar(255),AppointmentDate datetime,ClientType VARCHAR(50),
							 ProviderMobileNo VARCHAR(100),ISHNI VARCHAR(10),UpdatedBy VARCHAR(100),Relation VARCHAR(100),Username VARCHAR(100),AgentName varchar(100),
							 AgentMobileNo bigint, DocCoachApptType varchar(100),AppDeviceType Varchar(100),PlanName varchar(100),BookedBy varchar(50),
							 LoginUserName varchar(100),PointOfContactName varchar(100),LastCallStatus varchar(200),ProviderAddress varchar(max),
							 IsPrescriptionConsent varchar(50),MemberPlanId bigint,UserHomeVisitAddress varchar(max),VisitType varchar(50),TestName varchar(max),
							 FacilityId bigint,FacilityType varchar(100),TAT VARCHAR(20),CnfDt datetime,LastUpdatedDate datetime,AppVersion varchar(100),
							 PackageName varchar(5000), PartialShowTests varchar(max),ProviderResponse varchar(max),DCConfirmationFlag varchar(50),
							 DCConfirmationStage CHAR(50),TestCategory varchar(Max),ViewRemarks  varchar(Max),ProviderAvailableTimeSlots VARCHAR(100),
							 PartnerOrderId varchar(100),PhleboName varchar(255),PhleboTime varchar(255),PhleboContact varchar(255),MemberPaymentDetailsId varchar(100),
							 MemberName varchar(100),HomeCentrevisit varchar(100),Empno varchar(50),EmpContactNo varchar(20),FacilityGroupName varchar(100),
							 ClosedDateTime datetime,StatusDate datetime,ConfirmationDate datetime,AppointmentConfirmationTAT varchar(100),CreatedBy varchar(100),
							 OnHoldReason varchar(max),TranId varchar(100),PaymentMode varchar(100),DCCity varchar(100),MetroNonMetro varchar(100),
							 ReportClosureTAT varchar(50),ReportPendingTAT varchar(50),PartialStatusDatetime datetime,NoshowDatetime datetime,
							 PartialStatusUpdatebyName varchar(100),NoShowUpdatedDatebyName varchar(100), ConfirmationByName varchar(100),
							 ReportPenidngbyName varchar(100),FollowupDateTime datetime,FollowupUpdatebyName varchar(100),DCConfirmationStatusDatetime Datetime,
							 DCConfirmationUpdatebyDateTime datetime,FristResponseTimeonRequest varchar(50),  ReshduledDateTime datetime,ReshduledUpdatedBy varchar(100),
							 CancelledbyCustomerOrDC varchar(100),AppointmentConfirmationOutofTATWithinTAT varchar(100),AppointmentAddress varchar(max),
							 RoutineNonRoutine varchar(100))                                                                                                
                                                                                              
/****************************End DECLARE VARIABLES********************************************************/                                                                                                                                                          
/****************************Start Main Logic************************************************/                          
 print 'Diagnostic MIS Data'                              
                    
  insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,Gender,FacilityName,StatusName,ProviderId,ProviderName,
                          RequestedDate,Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,ISHNI,UpdatedBy,Relation,Username,AgentName ,AgentMobileNo,
						  DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,LastCallStatus,ProviderAddress,IsPrescriptionConsent,MemberPlanId,
						  UserHomeVisitAddress,VisitType,TestName,FacilityId,FacilityType,TAT,LastUpdatedDate,AppVersion,PackageName,PartialShowTests,ProviderResponse,
						  DCConfirmationFlag,DCConfirmationStage,TestCategory,ViewRemarks,ProviderAvailableTimeSlots,PartnerOrderId,PhleboName,PhleboTime,PhleboContact,
						  MemberPaymentDetailsId,MemberName,HomeCentrevisit,Empno ,EmpContactNo,FacilityGroupName,ClosedDateTime,StatusDate,ConfirmationDate,
						  AppointmentConfirmationTAT,CreatedBy,OnHoldReason,TranId,PaymentMode,DCCity ,MetroNonMetro ,ReportClosureTAT,ReportPendingTAT,
						  PartialStatusDatetime,NoshowDatetime,PartialStatusUpdatebyName,NoShowUpdatedDatebyName,ConfirmationByName,ReportPenidngbyName,FollowupDateTime,
						  FollowupUpdatebyName,DCConfirmationStatusDatetime,DCConfirmationUpdatebyDateTime, FristResponseTimeonRequest,ReshduledDateTime, 
                          ReshduledUpdatedBy,CancelledbyCustomerOrDC,AppointmentConfirmationOutofTATWithinTAT,AppointmentAddress,RoutineNonRoutine)                                                                                     
                                               
  select distinct apt.AppointmentId,
                  apt.CaseNo,
				  apt.AppointmentType as 'Appointment Type',
				  isnull(apt.UserLoginId,0),
				  mem.MemberId,
				  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                               
                  mem.EmailId,
				  mem.MobileNo,
				  CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender','',--fm.FacilityName,                                      
                  st.StatusName,ISNULL(pr.ProviderId,0),
				  '' as 'Provider Name',
				  CONVERT(VARCHAR,apt.CreatedDate,126),                                                                                             
                  apt.ClientId,
				  c.ClientName,
				  '' as AppointmentDate,
				  Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                
                  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,
				  apt.UpdatedBy,
				  mem.Relation,
				  apt.CreatedBy,                                                                     
                  IsNull(le.AgentName,'NA'  )as AgentName,
				  IsNull(le.AgentMobileNo,'') as AgentMobileNo,
				  apt.DocCoachApptType as DocCoachApptType,                                                                                    
                  ISNULL(ut.DeviceType,'NA') as AppDeviceType,
				  cj.PlanName,
				  u.UserName,
				  apt.PointOfContactName,
				  ISNULL(al.CallStatus,'') as LastCallStatus,                                                      
                  CONCAT( '',REPLACE(CONCAT(isnull(pr.HouseNumber,''),isnull(pr.HouseName,''),isnull(pr.StreetAddress1,''),',',isnull(pr.StreetAddress2,''),','+pr.CityName,','+pr.StateName),'&','and')) as ProviderAddress,                                                 
                  apt.IsPrescriptionConsent,
				  MPD.MemberPlanId,
				  IsNull(apt.AppointmentAddress,'') as UserHomeVisitAddress,
				  ''  as VisitType,
				  '',
				  null,
				  null,
				  '' as TAT,
				  ISNULL(apt.UpdatedDate,'') as LastUpdatedDate,
				  ISNULL(ut.app_version,'NA') as AppVersion,
				  '' as PackageName,
				  '' as PartialShowTests,
				  '' as ProviderResponse,
				  apt.DCConfirmationFlag,
				  apt.DCConfirmationStage,
				  '' as TestCategory,
				  ISNULL(apt.Remarks,'') as ViewRemarks,
				  '' as ProviderAvailableTimeSlots,
				  apt.Partner_orderid,
				  '' as PhleboName,
				  '' asPhleboTime,
				  '' as PhleboContact,
				  isnull(MPD.MemberPaymentDetailsId,'0'),
				  Concat(mem.FirstName,' ',mem.LastName),                    
                  case when apt.VisitType='CV' THEN 'Center Visit' when  apt.VisitType='HV' THEN 'Home Visit' ELSE  apt.VisitType end AS HomeCentrevisit,                
                  u.EmpNo,
				  m.MobileNo,
				  fm.FacilityGroup,      
                  (select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=6) as ClosedateTime,      
                  (select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=1) as StatusDate,                   
                  (select top 1 ISnull(CreatedDate,'') from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=2) as ConfirmationDate,
				  '',
				  al.CreatedBy,                    
                  (select top 1 Remarks from AppointmentLog where appointmentid=apt.appointmentId and ScheduleStatus=11),                    
                  (SELECT top 1 isnull(mpdi.TransactionId,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId),          
                  (SELECT top 1 isnull(mpdi.ModeOfPayment,'') FROM memberplanDetails mpds  join MemberPaymentDetails mpdi on mpds.MemberPaymentDetailsId=mpdi.MemberPaymentDetailsId where mpds.memberplanid=MPD.memberplanid and mpds.AppointmentId=apt.appointmentId),          
                  (select isnull(pr.CityName,'') from provider where providerid=pr.ProviderId),                    
                  (select top 1 case when c.IsMetro = 'Y' then 'Metro' else 'Non-Metro' end as MetroNonMetro from city c join haportal.dbo.provider p on p.CityName=c.CityName where providerid=pr.ProviderId),                    
                  '' as ReportClosureTAT,
				  '' as ReportPendingTAT,                
                  (select top 1 CreatedDate from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusDatetime,                
                  (select top 1 CreatedDate from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoshowDatetime,                
                  --al.CreatedBy as PartialStatusUpdatebyName,  
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=4 and AppointmentId=apt.AppointmentId) as PartialStatusUpdatebyName,  
                  --al.CreatedBy as NoShowUpdatedDatebyName,   
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=3 and AppointmentId=apt.AppointmentId) as NoShowUpdatedDatebyName,         
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=2 and AppointmentId=apt.AppointmentId) as ConfirmationByName,           
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=8 and AppointmentId=apt.AppointmentId) as ReportPenidngbyName,
				  (select top 1 CreatedDate from Appointmentlog where ScheduleStatus=6 and AppointmentId=apt.AppointmentId) as FollowupDateTime,                
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=6 and AppointmentId=apt.AppointmentId ) as FollowupUpdatebyName,
				  (select top 1 CreatedDate from Appointmentlog where DCConfirmationFlag in('A','R') and AppointmentId=apt.AppointmentId ) as DCConfirmationStatusDatetim,
                  (select top 1 CreatedDate from Appointmentlog where DCConfirmationFlag in('A','R') and AppointmentId=apt.AppointmentId ) as DCConfirmationUpdatebyDateTime,                
                --(select top 1 CreatedDate from Appointmentlog where ScheduleStatus=2 and AppointmentId=apt.AppointmentId ) as FristResponseTimeonRequest,                
                  '',           
                  (select top 1 CreatedDate from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledDateTime,                
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=10 and AppointmentId=apt.AppointmentId ) as ReshduledUpdatedBy,
                  (select top 1 isnull(CreatedBy,'') from Appointmentlog where ScheduleStatus=7 and AppointmentId=apt.AppointmentId ) as CancelledbyCustomerOrDC, 
                  '' as AppointmentConfirmationOutofTATWithinTAT,
				  apt.AppointmentAddress,
				  ''                    

  from Appointment apt with (nolock)                                                                                 
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                                            
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                                                         
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                             
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                       
  join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                                     
  join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId                                                                                            
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                       
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'       
  left join city ct with (nolock) on apt.CityId=ct.CityId     
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId      
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                    
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId              
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                                                          
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId                                           
   left join AppointmentLog al on al.AppointmentId=apt.AppointmentId                                                                                              
  where (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))        
  and (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                                                  
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                            
  and apt.AppointmentType in ('VAC','INF','PNE','CER','HEP','TYP','COVIDVAC')                              
                                    
                           
  update ww set ww.BookedBy=IIF(ISNULL(ww.Username,'') = ww.CustomerName,'Self',ww.Username) from #Temporary ww                                                                                                
                                                      
  update #Temporary                                                                     
  set ProviderName = (select string_agg(pr.ProviderName,',')                                                     
  from [HAPortal].dbo.Provider pr                                                     
  where #Temporary.ProviderId = pr.ProviderId)                                                                
                          
   ------------Delete duplicate caseno in temporary----------------------------                                                                                                  
----------------------------------------------------------------------------                                                                
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
   --UPDATE #Temporary SET TestName =  STUFF((SELECT distinct ', ' + CAST(f1.FacilityNAme AS VARCHAR(max)) [text()]                                                              
   --FROM PackageTestMaster p                                                               
   --join facilitiesMaster f1 on p.TestId=f1.FacilityId                                                              
   --WHERE PackageId = t.FacilityId AND isSearch = 'N'                                                              
   --FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') FROM #Temporary t --where FacilityType='PACKAGE' ;                                                            
                                                            
   -- UPDATE #Temporary SET FacilityId =  STUFF((SELECT distinct ', ' + CAST(f1.FacilityId AS VARCHAR(max)) [text()]                                                              
   --FROM PackageTestMaster p                                                               
   --join facilitiesMaster f1 on p.TestId=f1.FacilityId                                                              
   --WHERE PackageId = t.FacilityId AND isSearch = 'N'                                                
   --FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ') FROM #Temporary t                                                     
                                                      
    --UPDATE #Temporary SET TestName =                                                         
    --( SELECT                                                      
    --STRING_AGG(fm.FacilityName, ',')                                                       
    --WITHIN GROUP (ORDER BY fm.FacilityName DESC)                                                      
    --from appointment a                                                       
    --join AppointmentDetails ad on a.appointmentid=ad.AppointmentId                                                      
    --join FacilitiesMaster fm on fm.FacilityId=ad.TestId                                                      
    --where  a.AppointmentId= #Temporary.AppointmentId    --and #Temporary.FacilityType='TEST'                                           
    --GROUP BY ad.AppointmentId )                                                       
                     
	UPDATE #Temporary
	set TestName=fm.FacilityName
	From #Temporary T
	Join AppointmentDetails ad on ad.AppointmentId=T.AppointmentId
	join FacilitiesMaster fm on fm.FacilityId=ad.PakageId
-------Packagename                                                          
                                                          
                                                          
 UPDATE #Temporary SET  PackageName=                                                           
 (select fm.facilityname from FacilitiesMaster fm join AppointmentDetails ad                                                          
 on fm.Facilityid=ad.PakageId                                                
 where ad.PakageId=#Temporary.FacilityId and #Temporary.FacilityType='PACKAGE'                                                          
 group by fm.facilityname)                                                          
                                                      
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
                                                    
                                                    
                                                    
 ----------------------------------------------------------------------------------                                                                          
                               
/*******************End Main Logic****************************************************/                                                                                                  
--------------------------------------------------------------------------------------                                                                             
                                                                                                  
                                                                                                  
                                                                                                     
  /*****************Select All table*************************************************/                                                                                                  
   print @FromDate                        
   print @ToDate                                                                                            
   select   distinct * from #Temporary                                                     
   ORDER BY AppointmentId DESC                                   
   offset @myoffset rows                                                                                                                    
   FETCH NEXT @RecordPerPage rows only                                                   
                                                                       
                                                                            
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                                                         
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                                                  
                                    
                                                                                                     
/*****************End Select All Table********************************************/                                                                                                  
   drop table #Temporary                                                                     
   drop table #TEMP                                                              
End