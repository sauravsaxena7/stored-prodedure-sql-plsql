USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor-OPD]    Script Date: 3/14/2024 10:13:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
--	  select apt.CaseNo ,ap.*from Appointment Apt
--inner join UserPlanDetails MPD on apt.UserPlanDetailsId =MPD.UserPlanDetailsId
--inner join CNPlanDetails ap on ap.CNPlanDetailsId=mpd.CNPlanDetailsId
--  where apt.caseno='HA21122023BABJGH'
                          
 -- exec [USPGETBookingAppointmentDetailsFor-OPD]   null,'2023-12-01','2023-12-31',null,null,1,20,null,null,null,null,1,null,null    
 -- exec [USPGETBookingAppointmentDetailsFor-OPD]  'HA01022024BACJFB',null,null,null,null,1,20,null,null,null,null,1,null,null                         
                            
                            
ALTER PROCEDURE [dbo].[USPGETBookingAppointmentDetailsFor-OPD]                                                              
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
 @DaysofActived INT = 2,                                                
 @MenuName varchar(100) = null,                     
 @AppointmentStatus varchar(100) = null ,
 @DateFilterType varchar(200)=null
AS                                
BEGIN                                
                                
 SET NOCOUNT ON                                
                                
/****************************Start DECLARE VARIABLES*********************************/                                
Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100)                              
Select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                        
                       
                      
/***************************Start Declare Table**************************************************************/                                
Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),EmailId varchar(100),
                         MobileNo varchar(100),Gender varchar(10),FacilityName varchar(5000),StatusName varchar(100),ProviderId bigint,ProviderName varchar(200),
						 RequestedDate VARCHAR(50),Clientid int,ClientName varchar(255),AppointmentDate datetime,ClientType VARCHAR(50),ProviderMobileNo VARCHAR(100),
						 ISHNI VARCHAR(10),UpdatedBy VARCHAR(100),Relation VARCHAR(100),Username VARCHAR(100),AgentName varchar(100),AgentMobileNo bigint,
						 DocCoachApptType varchar(100),AppDeviceType Varchar(100),PlanName varchar(100),BookedBy varchar(50),LoginUserName varchar(100),
						 PointOfContactName varchar(100),TAT VARCHAR(20),CnfDt datetime,DoctorName varchar(50),DoctorQualification varchar(100),IsNewPlan varchar(1)
						 ,MemberPaymentDetailsId varchar(100)  )                                  
                                
/****************************End DECLARE VARIABLES********************************************************/                                 
                                
---------------------------------------------------------------------------------------------------------                                
----------------------------------------------------------------------------------------------------------                                
                                
/****************************Start Main Logic************************************************/                                
                                
IF (@FromDate is null and @ToDate is null and @CaseNo is null )                              
 BEGIN                              
 print 'atul case 1'                              
                       
    INSERT INTO #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,Gender,FacilityName,StatusName,ProviderId,ProviderName,
	                        RequestedDate,Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,ISHNI,UpdatedBy,Relation,Username,AgentName,AgentMobileNo,DocCoachApptType,
							AppDeviceType,PlanName,LoginUserName,PointOfContactName,TAT,DoctorName,DoctorQualification,IsNewPlan
							,MemberPaymentDetailsId)                               
                                  
 select apt.AppointmentId,
	       apt.CaseNo,
		   s.ShortDesc as 'Appointment Type',
		   isnull(apt.UserLoginId,0),
		   mem.MemberId,
		   Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
           mem.EmailId,
		   mem.MobileNo,
		   CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',
		   fm.FacilityName,                                
           st.StatusName,
		   ISNULL(pr.ProviderId,0),
		   '' as 'Provider Name',
		   CONVERT(VARCHAR,apt.CreatedDate,126),                               
           apt.ClientId,
		   c.ClientName,
		   NULL,
		   Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',
		   CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
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
		   TAT,
		   null,
		   null,
		   'N'
		   ,isnull(MPD.MemberPaymentDetailsId,'0')
  from Appointment apt with (nolock)                               
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'               
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                        
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
  where  cast(apt.CreatedDate as date) = CAST(GETDATE() as date)           
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                              
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
  and (@email is null OR mem.EmailId like '%'+@email+'%')                               
  and (@buType is null OR c.BUType like '%'+@buType+'%')                            
  and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                              
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                              
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                               
  and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET')
  and fm.FacilityGroup !='Tele-Consultation'
  --ORDER BY apt.CreatedDate DESC                              
  --offset @RecordPerPage * (@PageNumber-1)rows                                                  
  --FETCH NEXT @RecordPerPage rows only 
           
   union all 

  select distinct
  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                               
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType'
  ,CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                              
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                
  ISNULL(ut.DeviceType,'NA') as AppDeviceType ,cj.PlanName
  ,u.UserName,apt.PointOfContactName  ,TAT,null ,null,'Y'  
  ,isnull(uts.id,'0')                    
  from Appointment apt with (nolock)                                    
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                           
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                               
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                    
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                    
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                    
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                     
  --join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                
  --join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId    
  --inner join MemberPLanBucket MPD on MPD.UserPlanDetailsId=apt.UserPlanDetailsId
  --inner join CNPLanBucket CNPL on CNPL.CNPLanBucketId=mpd.CNPLanBucketId
  --inner join CNPlanDetails CJ on cj.CNPlanDetailsId=CNPL.CNPlanDetailsId

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

  left join  MemberBucketBalance mbb on mbb.AppointmentId=apt.AppointmentId and mbb.MemberPLanBucketId=apt.MemberPlanBucketID 
  and mbb.TransactionId is not null  ---Feb2024
  left join  UserTransactions uts on uts.TransactionId=mbb.TransactionId    ---Feb2024

 
  where  cast(apt.CreatedDate as date) = CAST(GETDATE() as date)           
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                              
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
  and (@email is null OR mem.EmailId like '%'+@email+'%')                               
  and (@buType is null OR c.BUType like '%'+@buType+'%')                            
  and (@Plan is null or CJ.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                              
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                              
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                               
  and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET')
  and fm.FacilityGroup !='Tele-Consultation'

 --ORDER BY apt.CreatedDate
 -- offset @RecordPerPage * (@PageNumber-1)rows                                                  
 -- FETCH NEXT @RecordPerPage rows only                                     
                                                            
 END                              
                              
 ELSE IF(@CaseNo is not null)                              
 BEGIN                              
 print 'atul case'                              
   INSERT INTO #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,Gender,FacilityName,StatusName,ProviderId,ProviderName,
	                       RequestedDate,Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,ISHNI,UpdatedBy,Relation,Username,AgentName,AgentMobileNo,DocCoachApptType,
						   AppDeviceType,PlanName,LoginUserName,PointOfContactName,TAT,DoctorName,DoctorQualification,IsNewPlan
						   ,MemberPaymentDetailsId)                               
                              
   SELECT  apt.AppointmentId,
           apt.CaseNo,
		   s.ShortDesc as 'Appointment Type',
		   isnull(apt.UserLoginId,0),
		   mem.MemberId,
		   Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
           mem.EmailId,
		   mem.MobileNo,
		   CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',
		   fm.FacilityName,                                
           st.StatusName,
		   ISNULL(pr.ProviderId,0),'' as 'Provider Name',
		   CONVERT(VARCHAR,apt.CreatedDate,126),                              
           apt.ClientId,
		   c.ClientName,
		   NULL,
		   Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',
		   CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
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
		   TAT,
		   null ,
		   null,
		   'N'
		   ,isnull(MPD.MemberPaymentDetailsId,'0')
  from Appointment apt with (nolock)                                   
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                              
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'               
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
  

  where (@CaseNo is null or apt.CaseNo like @CaseNo)                          
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
  and (@email is null OR mem.EmailId like '%'+@email+'%')                               
  and (@buType is null OR c.BUType like '%'+@buType+'%')                            
  and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                             
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                         
  and ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                           
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                            
  and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET') 
  and fm.FacilityGroup !='Tele-Consultation'

   union all 

  select distinct
  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                               
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType'
  ,CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                              
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                
  ISNULL(ut.DeviceType,'NA') as AppDeviceType ,cj.PlanName
  ,u.UserName,apt.PointOfContactName  ,TAT,null,null,'Y'  
,isnull(uts.id,'0')                      
  from Appointment apt with (nolock)                                    
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                           
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                               
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                    
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                    
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                    
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                     
  --join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                
  --join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId    
  --inner join MemberPLanBucket MPD on MPD.UserPlanDetailsId=apt.UserPlanDetailsId
  --inner join CNPLanBucket CNPL on CNPL.CNPLanBucketId=mpd.CNPLanBucketId
  --inner join CNPlanDetails CJ on cj.CNPlanDetailsId=CNPL.CNPlanDetailsId
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
  left join  MemberBucketBalance mbb on mbb.AppointmentId=apt.AppointmentId and mbb.MemberPLanBucketId=apt.MemberPlanBucketID 
  and mbb.TransactionId is not null  ---Feb2024
  left join  UserTransactions uts on uts.TransactionId=mbb.TransactionId 
  where (@CaseNo is null or apt.CaseNo like @CaseNo)                          
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
  and (@email is null OR mem.EmailId like '%'+@email+'%')                               
  and (@buType is null OR c.BUType like '%'+@buType+'%')                            
  and (@Plan is null or CJ.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                             
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                         
  and ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                           
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                            
  and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET') 
  and fm.FacilityGroup !='Tele-Consultation'

  --ORDER BY apt.CreatedDate DESC                              
  --offset @RecordPerPage * (@PageNumber-1)rows                                                  
  --FETCH NEXT @RecordPerPage rows only                                
                                
                              
 end                              
                              
 else                              
 begin                              
 print 'case 5'                             
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                  
    Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                   
    Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,                                    
       ISHNI,UpdatedBy,Relation,Username,                                
     AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,TAT,DoctorName,DoctorQualification,IsNewPlan
	 ,MemberPaymentDetailsId)                               
                               
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                               
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                              
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName  ,TAT,null,null ,'N' 
  ,isnull(MPD.MemberPaymentDetailsId,'0')                          
  from Appointment apt with (nolock)                                    
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                           
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'           
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
  where ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                              
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                              
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
and (@email is null OR mem.EmailId like '%'+@email+'%')                               
and (@buType is null OR c.BUType like '%'+@buType+'%')                            
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                              
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                    
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                
 and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET') 
  and fm.FacilityGroup !='Tele-Consultation'
 
 union all 

  select distinct
  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,
  Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                    
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                               
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType'
  ,CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                 
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                              
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                
  ISNULL(ut.DeviceType,'NA') as AppDeviceType ,cj.PlanName
  ,u.UserName,apt.PointOfContactName  ,TAT,null,null,'Y'   
  ,isnull(uts.id,'0')                 
  from Appointment apt with (nolock)                                    
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                           
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                               
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                    
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                    
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                    
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                     
  --join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                
  --join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId    
  --inner join MemberPLanBucket MPD on MPD.UserPlanDetailsId=apt.UserPlanDetailsId
  --inner join CNPLanBucket CNPL on CNPL.CNPLanBucketId=mpd.CNPLanBucketId
  --inner join CNPlanDetails CJ on cj.CNPlanDetailsId=CNPL.CNPlanDetailsId
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
  left join  MemberBucketBalance mbb on mbb.AppointmentId=apt.AppointmentId and mbb.MemberPLanBucketId=apt.MemberPlanBucketID 
  and mbb.TransactionId is not null  ---Feb2024
  left join  UserTransactions uts on uts.TransactionId=mbb.TransactionId    ---Feb2024
                              
  where   ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                              
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                              
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                              
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                      
and (@email is null OR mem.EmailId like '%'+@email+'%')                               
and (@buType is null OR c.BUType like '%'+@buType+'%')                            
and (@Plan is null or cj.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                              
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                    
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                
 and apt.AppointmentType in ('DC','DEN','OC','PED','GYN','DIET') 
  and fm.FacilityGroup !='Tele-Consultation'
 
 --ORDER BY apt.CreatedDate DESC                              
 -- offset @RecordPerPage * (@PageNumber-1)rows                                                  
 -- FETCH NEXT @RecordPerPage rows only                             
                        
  end                              
            
                                                     
  update ww set ww.BookedBy=IIF(ISNULL(ww.Username,'') = ww.CustomerName,'Self',ww.Username) from #Temporary ww                              
     update #Temporary                                    
  set ProviderName = (select string_agg(pr.ProviderName,',') from [HAPortal].dbo.Provider pr where #Temporary.ProviderId = pr.ProviderId)                             
                            
                                
                      
------------Delete duplicate caseno in temporary----------------------------                                
----------------------------------------------------------------------------                                
  ;WITH cte AS (                                
   SELECT *, ROW_NUMBER()  OVER (                                
            PARTITION BY                                 
              CaseNo,FacilityName                                
            ORDER BY                                 
             CaseNo,FacilityName                                
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
   SET AppointmentDate = Isnull(T.AppointmentDate,'')                                   
   FROM #TEMP T                                    
   WHERE T.AppointmentId = #Temporary.AppointmentId    
   
   
-------------------TAT--------------------        
            
update #Temporary            
set CnfDt = (select max(CreatedDate) as CreatedDate from AppointmentLog al where ScheduleStatus=1 and al.AppointmentId=#Temporary.AppointmentId)            
            
update #Temporary            
set TAT = (CAST(DATEDIFF(ss,  CnfDt, GETDATE()) / 3600 AS VARCHAR(10)) + ' hr ' +            
CAST((DATEDIFF(ss,  CnfDt, GETDATE()) -  3600 * (DATEDIFF(ss,  CnfDt, GETDATE()) / 3600)) / 60 AS VARCHAR(10)) + ' Mins' )            
              
-------------------DoctorName--------------------            
     
  --UPDATE T
  --set DoctorName=D.name
  --from #Temporary T 
  --join MapTCAppointment mtc on T.AppointmentId=mtc.AppointmentId
  --join HAModuleUAt.tele_consultaion.Doctor d on mtc.doctorId=d.DoctorId
                           
  --UPDATE T
  --set DoctorName=ISNULL(t.DoctorName,d.name)
  --from #Temporary T 
  --join AppointmentDetails ad on T.AppointmentId=ad.AppointmentId
  --join HAModuleUAT.tele_consultaion.Doctor d on ad.DoctorId=d.DoctorId 
   
 -------------------DoctorName--------------------            
     
  UPDATE T
  set DoctorName=D.name,
  DoctorQualification =  STUFF(
         (SELECT ', ' + q.name
          FROM HAModule.tele_consultaion.Qualification q
          where q.QualificationId = DQ.qualificationId
          FOR XML PATH (''))
          , 1, 1, '')
  from #Temporary T 
  join MapTCAppointment mtc on T.AppointmentId=mtc.AppointmentId
  join HAModule.tele_consultaion.Doctor d on mtc.doctorId=d.DoctorId
  join HAModule.tele_consultaion.DoctorQualification DQ on DQ.doctorId = d.DoctorId
                           
  UPDATE T
  set DoctorName=ISNULL(t.DoctorName,d.name),
   DoctorQualification =  STUFF(
         (SELECT ', ' + q.name
          FROM HAModule.tele_consultaion.Qualification q
          where q.QualificationId = DQ.qualificationId
          FOR XML PATH (''))
          , 1, 1, '')
  from #Temporary T 
  join Appointment A on T.AppointmentId=A.AppointmentId
  left join HAModule.tele_consultaion.Doctor d on A.DoctorrId=d.DoctorId
  join HAModule.tele_consultaion.DoctorQualification DQ on DQ.doctorId = d.DoctorId                               
/*******************End Main Logic****************************************************/                         
                                
/*******************End Main Logic****************************************************/                                
--------------------------------------------------------------------------------------                                
                                
                                
                                   
  /*****************Select All table*************************************************/                                
                                   
   select   distinct * from #Temporary --ORDER BY RequestedDate DESC 
   ORDER BY RequestedDate DESC                              
  offset @RecordPerPage * (@PageNumber-1)rows                                                  
  FETCH NEXT @RecordPerPage rows only     
  --ORDER BY RequestedDate DESC                              
  --offset @RecordPerPage * (@PageNumber-1)rows                                                  
  --FETCH NEXT @RecordPerPage rows only   
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                  
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                
                                   
                                     
                                   
/*****************End Select All Table********************************************/                                
   drop table #Temporary   
   drop table #TEMP  
  end 