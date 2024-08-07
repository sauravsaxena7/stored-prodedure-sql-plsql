USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_HealthCoach]    Script Date: 3/19/2024 4:48:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- sp_helptext [USPGETBookingAppointmentDetailsFor_HealthCoach]                    
                  
 ---case1 => @FromDate is null and @ToDate is null and @CaseNo is null              
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    null,'2023-03-01','2023-03-28',null,null,1,10,null,null,null,null,1,"HealthCoach",null                                              
                               
 ---case2 => (@CaseNo is not null)               
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    null,null,null,null,null,1,10,null,null,null,null,1,"HealthCoach",null                   
                            
 ---case3 =>               
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    null,'2023-01-01','2023-03-13',null,null,1,10,null,null,null,null,1,"HealthCoach",null   
 
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    null,'2023-01-01','2023-03-13',null,null,1,10,null,null,null,null,1,"HealthCoach",null  
 
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    'HA16032023CDBCFJ',null,null,null,null,1,10,null,null,null,null,1,"HealthCoach",null  
 --exec [USPGETBookingAppointmentDetailsFor_HealthCoach]    'HA30032023CDGAGG',null,null,null,null,1,10,null,null,null,null,1,"HealthCoach",null  
                                      
                               
                                    
                               
                                                        
ALTER PROCEDURE [dbo].[USPGETBookingAppointmentDetailsFor_HealthCoach]                                                              
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
 @AppointmentStatus varchar(100) = null                                                   
AS                                                              
BEGIN                                                                                          
                                                      
 SET NOCOUNT ON                                                      
                                                      
/****************************Start DECLARE VARIABLES*********************************/                                                      
          Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100)                                                    
          
		  
		                           
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)  
	                                            
                                             
      print 'start'                                      
/***************************Start Declare Table**************************************************************/                                                      
    Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),EmailId varchar(100),MobileNo varchar(100),                                                     
  
   
    Gender varchar(10),FacilityName varchar(5000),StatusName varchar(100),ProviderId bigint,ProviderName varchar(200),RequestedDate VARCHAR(50),                                                         
    Clientid int,ClientName varchar(255),AppointmentDate datetime,ClientType VARCHAR(50),ProviderMobileNo VARCHAR(100),                                              
    ISHNI VARCHAR(10),UpdatedBy VARCHAR(100),Relation VARCHAR(100),Username VARCHAR(100),                        
    AgentName varchar(100),AgentMobileNo bigint,                                 
    DocCoachApptType varchar(100),AppDeviceType Varchar(100),PlanName varchar(100),BookedBy varchar(50),                        
    LoginUserName varchar(100),PointOfContactName varchar(100),AppVersion varchar(100)
	,ParentAppointmentCaseNo varchar(max),ReportReviewPlanName varchar(max))                 
                   
   print '#Temporary table created'                
                                                        
                                                      
/****************************End DECLARE VARIABLES********************************************************/                                                       
                                              
---------------------------------------------------------------------------------------------------------                          
----------------------------------------------------------------------------------------------------------                                                      
                                                      
/****************************Start Main Logic************************************************/                                                      
                                                      
                                                    
                                                    
                                                      
   if (@FromDate is null and @ToDate is null and @CaseNo is null )                               
 begin                                                    
 print 'atul case 1'                 
                                                  
                                             
    insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                        
    Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                         
    Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo ,                                                               
    ISHNI,UpdatedBy,Relation,Username,                                                      
    AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,                
    PlanName,LoginUserName,PointOfContactName,AppVersion
	,ParentAppointmentCaseNo,ReportReviewPlanName )                                                     
                                                        
  select apt.AppointmentId,apt.CaseNo,isnull(s1.ShortDesc,'') as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                          
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                                      
  st.StatusName,ISNULL(pr.ProviderId,0),pr.ProviderName as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                                     
  apt.ClientId,c.ClientName,IsNull(ad.AppointmentDateTime,'') as AppointmentDate,              
  Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),    
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,al.CreatedBy,mem.Relation,apt.CreatedBy,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                   
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName,ISNULL(ut.app_version,'NA') as AppVersion 
  ,IsNull(b.caseno,'') as ParentAppointmentCaseNo
  ,IsNull(cp.PlanName,'') as ReportReviewPlanName     
                                               
  from Appointment apt with (nolock)                                                     
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                   
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                              
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                 
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                          
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                       
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId            
  Left join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                     
  Left join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId              
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='PROCESS' ----and s1.CodeType='ProcessIMG'                                                           
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                           
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                          
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                            
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                             
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                          
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                      
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                      
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId  
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId  

  left join Appointment b on apt.ParentAppointmentId=b.AppointmentId 
  left Join MemberPlanDetails mpd1 on mpd1.AppointmentId=b.AppointmentId
  left Join corporateplan cp  on cp.CorporatePlanId=mpd1.CorporatePlanId
  


  where  cast(apt.CreatedDate as date) = CAST(GETDATE() as date)                                 
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                                    
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                                    
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                            
  and (@email is null OR mem.EmailId like '%'+@email+'%')                                                     
  and (@buType is null OR c.BUType like '%'+@buType+'%')                
  and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                 
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                    
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                     
  and apt.AppointmentType in ('HCH','RR')                                        
  ORDER BY apt.CreatedDate DESC                                                    
  offset @RecordPerPage * (@PageNumber-1)rows                                                                  
  FETCH NEXT @RecordPerPage rows only                                                        
         
                                                    
 print 'done @FromDate is null and @ToDate is null and @CaseNo is null '                                                        
                
         
  end              
-------------------------------------------*****------------------------------------------------------------                                                    
                                                     
                                                    
 else if(@CaseNo is not null)                                                    
 begin                                                    
 print 'atul case'                                                    
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                        
    Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                         
    Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,                                                             
    ISHNI,UpdatedBy,Relation,Username,                                                      
    AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,AppVersion
	,ParentAppointmentCaseNo,ReportReviewPlanName   )                                                     
                                                    
 select  apt.AppointmentId,apt.CaseNo,isnull(s1.ShortDesc,'') as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                          
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                                      
  st.StatusName,ISNULL(pr.ProviderId,0),pr.ProviderName as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                 
  apt.ClientId,c.ClientName,IsNull(ad.AppointmentDateTime,'') as AppointmentDate,              
  Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                                       
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,al.CreatedBy,mem.Relation,apt.CreatedBy,                                       
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                      
  ISNULL(ut.DeviceType,'NA') as AppDeviceType ,                
  cj.PlanName,                                
  u.UserName,apt.PointOfContactName,ISNULL(ut.app_version,'NA') as AppVersion 
  ,Isnull(b.caseno,'') as ParentAppointmentCaseNo   
  ,IsNull(cp.PlanName,'') as ReportReviewPlanName  
                                                        
  from Appointment apt with (nolock)                                                         
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                    
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                     
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                                      
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                         
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                          
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId              
  Left join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                      
  Left join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId             
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='PROCESS' ----and s1.CodeType='ProcessIMG'                                                            
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                           
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                          
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                          
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                          
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                          
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                      
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                      
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId       
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId  

  left join Appointment b on apt.ParentAppointmentId=b.AppointmentId 
  left Join MemberPlanDetails mpd1 on mpd1.AppointmentId=b.AppointmentId
  left Join corporateplan cp  on cp.CorporatePlanId=mpd1.CorporatePlanId
  
  
  where (@CaseNo is null or apt.CaseNo like @CaseNo)                                                
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                                    
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                            
and (@email is null OR mem.EmailId like '%'+@email+'%')                                                     
and (@buType is null OR c.BUType like '%'+@buType+'%')                                                  
                
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                  
                                                 
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                               
 and ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                                                 
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                  
and apt.AppointmentType in ('HCH','RR')                                          
  ORDER BY apt.CreatedDate DESC                                                    
offset @RecordPerPage * (@PageNumber-1)rows                                                                        
FETCH NEXT @RecordPerPage rows only                                                      
                                                      
print '@CaseNo is not null'                 
                                              
 end                                  
                         
--------------------------------------------*****-------------------------------------------                   
                                              
 else                                                    
 begin                                                    
 print 'Case  3 started'                                                   
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                        
   Gender,FacilityName,StatusName,ProviderId,ProviderName,RequestedDate,                                                         
    Clientid,ClientName,AppointmentDate,ClientType,ProviderMobileNo,    
       ISHNI,UpdatedBy,Relation,Username,                                                      
     AgentName ,AgentMobileNo,DocCoachApptType,AppDeviceType,PlanName,LoginUserName,PointOfContactName,AppVersion
	 ,ParentAppointmentCaseNo ,ReportReviewPlanName   )                                                     
                                                     
  select  apt.AppointmentId,apt.CaseNo,isnull(s1.ShortDesc,'') as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                          
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                                      
  st.StatusName,ISNULL(pr.ProviderId,0),pr.ProviderName as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                                     
  apt.ClientId,c.ClientName,IsNull(ad.AppointmentDateTime,'') as AppointmentDate,              
  Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                         
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,al.CreatedBy,mem.Relation,apt.CreatedBy,                                                    
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                                      
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName,ISNULL(ut.app_version,'NA') as AppVersion  
  ,isnull(b.caseno,'') as ParentAppointmentCaseNo  
  ,IsNull(cp.PlanName,'') as ReportReviewPlanName                                                      
                
  from Appointment apt with (nolock)                                                          
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                 
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                 
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                                     
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                          
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                          
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId             
  Left join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                      
  Left join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId             
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='PROCESS' ----and s1.CodeType='ProcessIMG'                                                            
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                           
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                          
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                          
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                          
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                          
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                      
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                            
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId  
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId  

  left join Appointment b on apt.ParentAppointmentId=b.AppointmentId 
  left Join MemberPlanDetails mpd1 on mpd1.AppointmentId=b.AppointmentId
  left Join corporateplan cp  on cp.CorporatePlanId=mpd1.CorporatePlanId
  
  where ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                                                    
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                                    
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                                    
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                            
and (@email is null OR mem.EmailId like '%'+@email+'%')                                                 and (@buType is null OR c.BUType like '%'+@buType+'%')             
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                 
                            
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                          
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                                      
 and apt.AppointmentType in ('HCH','RR')                                          
 ORDER BY apt.CreatedDate DESC offset @RecordPerPage * (@PageNumber-1)rows                                                                        
FETCH NEXT @RecordPerPage rows only                  
                
 print 'case 3 is done'                
                      
  end                                                    
                                  
                                                                           
  --update ww set ww.BookedBy=IIF(ISNULL(ww.Username,'') = ww.CustomerName,'Self',ww.Username) from #Temporary ww                                      
  --   update #Temporary                                                          
  --set ProviderName = (select string_agg(pr.ProviderName,',') from [HAPortal].dbo.Provider pr where #Temporary.ProviderId = pr.ProviderId)                                                   
                                                  
                                                      
                                            
------------Delete duplicate caseno in temporary----------------------------                                                      
----------------------------------------------------------------------------                                                      
  ;WITH cte AS (                                                      
   SELECT *, ROW_NUMBER() OVER (                                                      
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
                                                                         
                                             
-------------------------ProviderName-------------------                
                
update #Temporary                      
set ProviderName = (select string_agg(pr.ProviderName,',') from [HAPortal].dbo.Provider pr where #Temporary.ProviderId = pr.ProviderId)   



                   
/*******************End Main Logic****************************************************/                                                      
--------------------------------------------------------------------------------------                  
                              
                                                      
                                                         
  /*****************Select All table*************************************************/                                                      
                                                         
   select   distinct * from #Temporary                                                      
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                                        
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                      
                                                   
                                                           
                                                         
/*****************End Select All Table********************************************/                                                      
   drop table #Temporary                         
   drop table #TEMP                        
  end 