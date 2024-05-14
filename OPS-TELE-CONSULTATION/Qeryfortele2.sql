--select * from Appointment where caseNo='HA21122023BABJGI'

--SELECT * FROM UserPlanDetails where UserPlanDetailsId=650

--SELECT * FROM CNPlanDetails WHERE CNPlanDetailsId=788;


 select apt.AppointmentId,apt.CaseNo,isnull(s1.ShortDesc,'') as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                            
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                                        
  st.StatusName,ISNULL(pr.ProviderId,0),pr.ProviderName as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                                       
  apt.ClientId,c.ClientName,IsNull(ad.AppointmentDateTime,'') as AppointmentDate,                
  Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),      
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,al.CreatedBy,mem.Relation,apt.CreatedBy,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                     
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName,ISNULL(ut.app_version,'NA') as AppVersion   
  ,IsNull(b.caseno,'') as ParentAppointmentCaseNo  
  ,IsNull(cp.PlanName,'') as ReportReviewPlanName       
  ,'' as TAT                                          
  ,mtca.ProviderName as AssignToProviderName
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
  left join [HAPortalUAT].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                              
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                               
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                            
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                        
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                        
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId    
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId    
  
  left join Appointment b on apt.ParentAppointmentId=b.AppointmentId   
  left Join MemberPlanDetails mpd1 on mpd1.AppointmentId=b.AppointmentId  
  left Join corporateplan cp  on cp.CorporatePlanId=mpd1.CorporatePlanId  
  left Join MapTCAppointment mtca on apt.AppointmentId=mtca.AppointmentId  
  
  
   where apt.CaseNo like 'HA21122023BABJGI'
   union all

select DISTINCT apt.AppointmentId,apt.CaseNo,isnull(s1.ShortDesc,'') as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                            
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
  ,'' as TAT        
  ,mtca.ProviderName as AssignToProviderName
  from Appointment apt with (nolock)                                                           
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                                      
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                       
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                                        
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                           
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                            
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                
 -- Left join MemberPlanDetails MPD with (nolock) on MPD.AppointmentId=apt.AppointmentId                                                        
  --Left join CorporatePlan cj on cj.CorporatePlanId=MPD.CorporatePlanId 
  
  inner join UserPlanDetails MPD on apt.UserPlanDetailsId =MPD.UserPlanDetailsId
  inner join CNPlanDetails cj on cj.CNPlanDetailsId=MPD.CNPlanDetailsId

  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='PROCESS' ----and s1.CodeType='ProcessIMG'                                                              
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                                             
  left join city ct with (nolock) on apt.CityId=ct.CityId                                                            
  left join [HAPortalUAT].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                            
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                            
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                            
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                                        
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                                        
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId         
  left join AppointmentLog al on al.AppointmentId=apt.AppointmentId    
  
  left join Appointment b on apt.ParentAppointmentId=b.AppointmentId   
  left Join UserPlanDetails mpd1 on mpd1.UserPlanDetailsId=b.UserPlanDetailsId  
  left Join CNPlanDetails cp  on cp.CNPlanDetailsId=mpd1.CNPlanDetailsId  
  left Join MapTCAppointment mtca on apt.AppointmentId=mtca.AppointmentId    
    
  where apt.CaseNo like 'HA21122023BABJGI';                                                 
 