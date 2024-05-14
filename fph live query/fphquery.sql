SELECT * FROM Userlogin WHERE  UserName='fp@gmail.com'
SELECT * FROM Member where UserLoginId=535124

select top 10 * from Appointment order by 1 desc
select * from Appointment where CaseNo='HA13022024BADBJC'
SELECT * FROM Member where Memberid=531859
SELECT* FROM UserLogin where userloginid=535124
select * from AppointmentDetails where Appointmentid=103192
SELECT * FROM StatusMaster where statusid=2

SELECT * FROM Member where MemberId=531859

 select apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                          
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityName,                                      
  st.StatusName,ISNULL(pr.ProviderId,0),'' as 'Provider Name',CONVERT(VARCHAR,apt.CreatedDate,126),                                     
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',CONCAT(pr.MobileNo1, CASE WHEN pr.STD1 IS NULL THEN '' ELSE ',('+pr.STD1 +')-' + pr.LandlineNo1 end),                                       
  CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,                                      
  IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo,apt.DocCoachApptType as DocCoachApptType,                                      
  ISNULL(ut.DeviceType,'NA') as AppDeviceType,cj.PlanName,u.UserName,apt.PointOfContactName ,TAT  ,cj.CNPlanDetailsId,up.UserPlanDetailsId ,
ISNULL(apt.DoctorrId,-1),ISNULL(dm.name,''),ISNULL(con.ConsultationId,-1),ISNULL(HMAD.MyRxAppointmentId,''),'Y'
  from Appointment apt with (nolock)                                     
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                     
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                              
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                 
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                          
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                       
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                          
  join SystemCode s with (nolock) on  apt.AppointmentType =s.Code and s.CodeType='VISITTYPE'                                           
  join UserPlanDetails up with (nolock) on up.UserPlanDetailsId=apt.UserPlanDetailsId                                     
  join CNPlanDetails cj on cj.CNPlanDetailsId=up.CNPlanDetailsId                                  
  left join SystemCode s1 with (nolock) on  fm.FacilityName  = s1.ShortDesc and s1.CodeType='ProcessIMG'                                           
  JOIN Client c with (nolock) on c.ClientId = apt.ClientId AND c.DemoFlag = 'N'                                           
  left join city ct with (nolock) on apt.CityId=ct.CityId                                          
  left join [HAPortalUAT].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                 
  --left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))
  left join HAModuleUAT.tele_consultaion.Doctor dm with (nolock) on apt.DoctorrId= dm.DoctorId    
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                          
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                      
  left join LibertyEmpRegistration le on le.UserLoginId = u.UserLoginId                                      
  left join UserTokan ut on ut.UserLoginId=u.UserLoginId
  left join HAModuleUAT.tele_consultaion.Consultation con on con.CaseNo = apt.CaseNo
  left join HaMyRxAppointmentDetails HMAD on HMAD.AppointmentId = apt.AppointmentId
  where  cast(apt.CreatedDate as date) = CAST(GETDATE() as date)                 
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                    
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                    
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                            
and (@email is null OR mem.EmailId like '%'+@email+'%')                                     
and (@buType is null OR c.BUType like '%'+@buType+'%')                                  
and (@Plan is null or up.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                                    
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                    
and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                     
 and apt.AppointmentType in ('FMP')

SELECT * FROM UserPlanDetails where MemberId = 531859

--UserPlanDetailsId=960

SELECT * FROM MemberPlanBucket Where UserPlanDetailsId=960
SELECT * FROM MemberPLanBucketsDetails where MemberPlanBucketId IN (1118,
1119,
1120)