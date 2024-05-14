USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]    Script Date: 3/6/2024 4:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- exec [USPGETBookingAppointmentDetailsFor_Diagnostics] null,'2024-02-10','2024-02-11',null,null,1,20,null,null,null,null,null,'Confirmation',null , 'AppointmentDate'      
  
ALTER  PROCEDURE [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]                        
 @CaseNo varchar (50)=null,                                                                  
 @FromDate datetime = null,                                                                  
 @ToDate datetime =null,                                                                  
 @Plan varchar(100)=null,                                                                                          
 @ClientId varchar(100)=null,                                                                    
 @pageNumber int=1,  --page Number                                                                                      
 @recordPerPage int=50 ,                                                                      
 @name varchar(100)=null,                                                                                          
 @phone varchar(100)=null,                                                                                          
 @email varchar(100)=null  ,                                                                
 @buType varchar(100) = null ,                                                                
 @DaysofActived INT = null,                                                                                    
 @MenuName varchar(100) = null,                                                         
 @AppointmentStatus varchar(100) = null,    
 @DateFilterType varchar(100) = null  
AS                                                                    
BEGIN                                                                    
                                                                    
 SET NOCOUNT ON                                                                    
                                                                    
/****************************Start DECLARE VARIABLES*********************************/                                                                    
   Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100),@myoffset int=0                                                         
  
    
      
      print '@MenuName'  
    ---live---
   --if(@MenuName='Confirmation')                                                             
   --   Begin                           
   --set @StatusID=('1,2,3,4,56,58,31,47')                                                                   
   --   End                                                                  
   --if(@MenuName='Fulfilment')                                          
   --   Begin                                                                  
   --set @StatusID=('8,9,12,11,5,43,44,45,46,41,50,51,44,37,36')                                                                  
   --   End                                                                  
   --if(@MenuName='Closure')                                                               
   --   Begin                                                                  
   --   set @StatusID=('6,7')                                                                                   
	  --End    
	  ---live end---

       --uat--                    
	  if(@MenuName='Confirmation')                                                           
      Begin                         
        set @StatusID=('1,2,3,4,56,58,31')                                                                 
      End                                                                
   if(@MenuName='Fulfilment')                                        
      Begin                                                                
        set @StatusID=('8,9,12,11,5,43,44,45,46,47,41,50,51,44')                                                                
      End                                                                
   if(@MenuName='Closure')                                                             
      Begin                                                                
       set @StatusID=('6,7')                                                            
      End                              
	  ---uat--

	  IF @DateFilterType IS NULL
	   BEGIN
	      SET @DateFilterType='BookingDate'
	   END

    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                                     
select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                                
                                                           
     set @myoffset=((@recordPerPage * @pageNumber) - @recordPerPage ) + 0;                        
  print @StatusID                         
                
/***************************Start Declare Table**************************************************************/                                                                    
                     
    Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),EmailId varchar(100),MobileNo varchar(100),                                                    
              
    Gender varchar(10),FacilityName varchar(5000),StatusName varchar(100),ProviderId bigint,ProviderName varchar(200),RequestedDate VARCHAR(50),                                                                       
    Clientid int,ClientName varchar(255),AppointmentDate datetime,ClientType VARCHAR(50),ProviderMobileNo VARCHAR(100),                                                                       
   ISHNI VARCHAR(10),UpdatedBy VARCHAR(100),Relation VARCHAR(100),Username VARCHAR(100),                                      
   AgentName varchar(100),AgentMobileNo bigint,                                               
   DocCoachApptType varchar(100),AppDeviceType Varchar(100),PlanName varchar(100),BookedBy varchar(50),                                      
   LoginUserName varchar(100),PointOfContactName varchar(100),LastCallStatus varchar(200),ProviderAddress varchar(max),IsPrescriptionConsent varchar(50),MemberPlanId bigint,UserHomeVisitAddress varchar(max),              
   VisitType varchar(50),TestName varchar(max),FacilityId bigint,FacilityType  varchar(100)                            
   ,TAT VARCHAR(20),CnfDt datetime,LastUpdatedDate datetime                            
   ,AppVersion varchar(100),                            
   PackageName varchar(5000)                          
   , PartialShowTests varchar(max)                      
   ,ProviderResponse varchar(max)                      
   ,DCConfirmationFlag varchar(50)                      
   ,DCConfirmationStage CHAR(50)                      
   ,TestCategory varchar(Max)                      
   ,ViewRemarks   varchar(Max)                      
   ,ProviderAvailableTimeSlots VARCHAR(100)        
   ,PartnerOrderId varchar(100)        
   ,PhleboName varchar(255),          
  PhleboTime varchar(255),          
  PhleboContact varchar(255),      
  MemberPaymentDetailsId varchar(100)               
      ,UserCurrentLocation nvarchar(500),  
   IsNewPlan char null,  
   UserPlanDetailsId bigint null, /*Added by Vikas for PlanRefactoring changes 11Jan24*/  
   MemberPlanBucketId bigint null /*Added by Vikas for PlanRefactoring changes 11Jan24*/  
)                                                                      
                                                                    
/****************************End DECLARE VARIABLES********************************************************/                                                                     
                                                                    
---------------------------------------------------------------------------------------------------------                                                                    
----------------------------------------------------------------------------------------------------------                                                                    
                                                                    
/****************************Start Main Logic************************************************/                                                                    
   
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                                      
  Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                     
  Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo ,                                                                             
  ISHNI,UpdatedBy,Relation,Username,                                                               
  AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,LastCallStatus,ProviderAddress,IsPrescriptionConsent,MemberPlanId,UserHomeVisitAddress,VisitType,TestName,FacilityId,FacilityType,              
  TAT,LastUpdatedDate,AppVersion                            
  ,PackageName,PartialShowTests                  
  ,ProviderResponse                       
  ,DCConfirmationFlag                       
  ,DCConfirmationStage                       
  ,TestCategory                      
  ,ViewRemarks                       
  ,ProviderAvailableTimeSlots,PartnerOrderId, PhleboName,PhleboTime, PhleboContact ,MemberPaymentDetailsId, UserCurrentLocation,IsNewPlan  
  ,UserPlanDetailsId,MemberPlanBucketId  
  )                                                                   
                                                                      
 select distinct apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                                        
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender','',--fm.FacilityName,                                                                    
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                                                   
  apt.ClientId,c.ClientName,'' as AppointmentDate,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),    
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                                                                    
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                                    
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName,ISNULL(al.CallStatus,'') as LastCallStatus,                            
  CONCAT( '',REPLACE(CONCAT(isnull(pr.HouseNumber,''),isnull(pr.HouseName,''),isnull(pr.StreetAddress1,''),',',isnull(pr.StreetAddress2,''),','+pr.CityName,','+pr.StateName),'&','and')),                            
  apt.IsPrescriptionConsent,MPD.MemberPlanId,IsNull(apt.AppointmentAddress,'') as UserHomeVisitAddress,                      
  --IsNull(apt.VisitType,'') as VisitType                      
  '' as VisitType                       
  ,fm.FacilityName,null,null,'' as TAT,apt.UpdatedDate as LastUpdatedDate                            
  ,ISNULL(ut.app_version,'NA') as AppVersion                             
  ,'' as PackageName ,'' as PartialShowTests                       
  ,'' as ProviderResponse                            
  ,apt.DCConfirmationFlag                       
  ,apt.DCConfirmationStage                        
  ,'' as TestCategory                          
   ,ISNULL(apt.Remarks,'') as ViewRemarks                       
   ,'' as ProviderAvailableTimeSlots,apt.Partner_orderid,PhleboName as PhleboName,PhleboTime asPhleboTime,Phlebo_Masked_Number as PhleboContact       
   ,isnull(MPD.MemberPaymentDetailsId,'0'),'',case when apt.UserPlanDetailsID is null then 'N' when apt.UserPlanDetailsId =0 then 'N' else 'Y' end as IsNewPlan   
   ,isnull(apt.UserPlanDetailsId,0),isnull(apt.MemberPlanBucketID,0)  
  from Appointment apt with (nolock)                                                                   
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                   
  join UserLogin u on u.UserLoginId = apt.UserLoginId and u.Status != 'I'                                                            
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                      
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                                        
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                                     
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                          
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                                   
  join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                                   
  join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId                                                                  
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                 
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                         
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                                        
  left join [HAPortalUAT].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                                        
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                           
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                                        
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                                    
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                                    
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId                                       
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId                                                                               
  where ( 
            ( 
			  @DateFilterType='BookingDate' 
			    and (
				      (@FromDate is null and @ToDate is null)
					  or
					  (cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))
				    )
			)
			or
			( 
			  @DateFilterType='AppointmentDate' 
			    and (
				      (@FromDate is null and @ToDate is null)
					  or
					  (cast (ad.AppointmentDateTime as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))
				    )
			)
        )
  
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                                                  
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                                                  
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                                          
  and (@email is null OR mem.EmailId like '%'+@email+'%')                                                                   
  and (@buType is null OR c.BUType like '%'+@buType+'%')                                                                
  and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                                                                  
   and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                     
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                   
  and (apt.ScheduleStatus in (select Item from SplitString(@StatusID,',')))                                   
  and apt.AppointmentType in ('HC')   
    
    
  union all  

   select distinct apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                                        
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender','',--fm.FacilityName,                                                                    
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                                                   
  apt.ClientId,c.ClientName,'' as AppointmentDate,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),    
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                                                                    
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                                    
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName,ISNULL(al.CallStatus,'') as LastCallStatus,                            
  CONCAT( '',REPLACE(CONCAT(isnull(pr.HouseNumber,''),isnull(pr.HouseName,''),isnull(pr.StreetAddress1,''),',',isnull(pr.StreetAddress2,''),','+pr.CityName,','+pr.StateName),'&','and')),                            
  apt.IsPrescriptionConsent,MPD.UserPlanDetailsId,IsNull(apt.AppointmentAddress,'') as UserHomeVisitAddress,                      
  --IsNull(apt.VisitType,'') as VisitType                      
  '' as VisitType                       
  ,fm.FacilityName,null,null,'' as TAT,apt.UpdatedDate as LastUpdatedDate                            
  ,ISNULL(ut.app_version,'NA') as AppVersion                             
  ,'' as PackageName ,'' as PartialShowTests                       
  ,'' as ProviderResponse                            
  ,apt.DCConfirmationFlag                       
  ,apt.DCConfirmationStage                        
  ,'' as TestCategory                          
   ,ISNULL(apt.Remarks,'') as ViewRemarks                       
   ,'' as ProviderAvailableTimeSlots,apt.Partner_orderid,PhleboName as PhleboName,PhleboTime asPhleboTime,Phlebo_Masked_Number as PhleboContact       
   ,isnull(uts.id,'0'),   ---Feb2024
   '',case when apt.UserPlanDetailsID is null then 'N' when apt.UserPlanDetailsId =0 then 'N' else 'Y' end as IsNewPlan  
   ,isnull(apt.UserPlanDetailsId,0),isnull(apt.MemberPlanBucketID,0)  
  from Appointment apt with (nolock)                                                                   
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                   
  join UserLogin u on u.UserLoginId = apt.UserLoginId and u.Status != 'I'                                                            
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                      
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                                        
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                                     
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                          
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                                   
  inner join UserPlanDetails MPD on apt.UserPlanDetailsId =MPD.UserPlanDetailsId  
  inner join CNPlanDetails cj on cj.CNPlanDetailsId=mpd.CNPlanDetailsId                                                       
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                 
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                                         
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                                        
  left join [HAPortalUAT].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                                        
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                           
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                                        
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                                    
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                                    
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId                                       
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId  
  left join  MemberBucketBalance mbb on mbb.AppointmentId=apt.AppointmentId and mbb.MemberPLanBucketId=apt.MemberPlanBucketID 

  and mbb.TransactionId is not null  ---Feb2024
  left join  UserTransactions uts on uts.TransactionId=mbb.TransactionId    ---Feb2024                                                                    
  where  
  ( 
            ( 
			  @DateFilterType='BookingDate' 
			    and (
				      (@FromDate is null and @ToDate is null)
					  or
					  (cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))
				    )
			)
			or
			( 
			  @DateFilterType='AppointmentDate' 
			    and (
				      (@FromDate is null and @ToDate is null)
					  or
					  (cast (ad.AppointmentDateTime as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))
				    )
			)
        )

  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                                                  
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                                                  
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                                          
  and (@email is null OR mem.EmailId like '%'+@email+'%')                                                                   
  and (@buType is null OR c.BUType like '%'+@buType+'%')                                                                
  and (@Plan is null or CJ.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                                                                  
   and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                     
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                   
  and (apt.ScheduleStatus in (select Item from SplitString(@StatusID,',')))                                   
  and apt.AppointmentType in ('HC')      
  
   

                         
                                                         

                                                                                 
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
    WHEN visittype = 'HV' THEN 'Home Visit'                          
    WHEN visittype = 'CV' THEN 'Center Visit'                          
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
                          
UPDATE t set UserCurrentLocation= CONCAT(A.UserCurrentCity_State,IIF(A.UserCurrentPincode is not null,CONCAT(',',A.UserCurrentPincode),A.UserCurrentPincode))  
from #Temporary t join Appointment A on t.AppointmentId=A.AppointmentId                       
                          
 ----------------------------------------------------------------------------------                                                
                                                                        
/*******************End Main Logic****************************************************/                                                                        
--------------------------------------------------------------------------------------                                                                        
                                                                        
                                                                        
                                                                           
  /*****************Select All table*************************************************/                                                                        
                                                                           
   select   distinct * from #Temporary                           
   ORDER BY AppointmentId DESC                                                                      
   offset @myoffset rows                                                                                          
   FETCH NEXT @RecordPerPage rows only                                                                        
                                                 
                                                  
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                               
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                        
          
                                                                           
/*****************End Select All Table********************************************/                                                                        
   drop table #Temporary                                           
   drop table #TEMP                                          
  end 