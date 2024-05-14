USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetails]    Script Date: 2/6/2024 4:19:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                    
 -- select * from AppointmentLog where AppointmentId=222053 order by AppointmentLogId desc                                   
 -- exec [USPGETBookingAppointmentDetails]  'HA10082023CJDFDG',null,null,null,null,1,50,null,null,null,null,null,'closure',null    
 -- exec [USPGETBookingAppointmentDetails]  'HA01082023CJADCJ',null,null,null,null,1,50,null,null,null,null,null,'closure',null  
 -- exec [USPGETBookingAppointmentDetails]  null,null,null,null,null,1,50,null,null,null,null,null,'confirmation',null      
 -- exec [USPGETBookingAppointmentDetails]  'HA07082023CJCCFI',null,null,null,null,1,50,null,null,null,null,null,'confirmation',null                                

    
ALTER PROCEDURE [dbo].[USPGETBookingAppointmentDetails] 
                                                 
                                               
 @CaseNo varchar (50)=null,                                            
 @FromDate datetime = null,                                            
 @ToDate datetime =null,                                            
 @Plan varchar(100)=null,                                                                    
 @ClientId varchar(100)=null,                                              
 @pageNumber int=1,  --page Number                                                                
 @recordPerPage int=25 ,                                               
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
          Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',
		  @CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100)                                            
      if(@MenuName='Confirmation')                                          
      Begin                                      
   set @StatusID=('1,26,29,32,46')                                      
   End                                      
   if(@MenuName='Fulfilment')                                          
      Begin                                      
   set @StatusID=('27,30,31,21,46')                                      
   End                                      
   if(@MenuName='Closure')                                          
      Begin                                      
   set @StatusID=('7,19,28,42,43,44')                                    
                             
   End                             
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                                      
                                     
                                    
/***************************Start Declare Table**************************************************************/                                              
       Create table #Temporary (AppointmentId bigint,CaseNo varchar(50),AppointmentType varchar(100),UserLoginId bigint,MemberId bigint,CustomerName varchar(100),EmailId varchar(100),MobileNo varchar(100),                                                
    Gender varchar(10),FacilityId VARCHAR(50),FacilityName varchar(5000),ScheduleStatus varchar(20),StatusName varchar(100),ProviderId bigint,RequestedDate VARCHAR(50),                                                 
    Clientid int,ClientName varchar(255),AppointmentDate datetime,ClientType VARCHAR(50),TAT VARCHAR(20),FacilityType VARCHAR(25),                                             
       ISHNI VARCHAR(10),UpdatedBy VARCHAR(100),Relation VARCHAR(100),VisitType VARCHAR(50) DEFAULT 'Center Visit',                                                  
       HomeAddress VARCHAR(5000),Username VARCHAR(100),OrderValue varchar(50) ,CurrentOrder int,OrderLimit int,NewDiscountPercentage varchar(100),               
    DiscountValidityDays int,txnAmount int ,CurrentClaim int,CurrentOrder1 int,            
   DocCoachApptType varchar(100),PlanName varchar(100),BookedBy varchar(50),PharmacyProviderName varchar(200),Prescription varchar(MAX),CancelledBy varchar(200),CancelledDate datetime,CancelledReason varchar(MAX),          
   AgentName varchar(100),AgentMobileNo bigint,PartnerOrderid varchar(100),IsSplitOrder varchar(10),MemberPlanId bigint,CurrentDiplayOrder bigint,IsNewPlan char)                                                
                                              
    Create table #Temporaryone(AppointmentId bigint,UserLoginId bigint,CurrentOrdertemp int)                                              
                                              
/****************************End DECLARE VARIABLES********************************************************/                                               
                                              
---------------------------------------------------------------------------------------------------------                                              
----------------------------------------------------------------------------------------------------------                                              
                                              
/****************************Start Main Logic************************************************/                                              
                                              
                                            
                                            
                                              
   if (@FromDate is null and @ToDate is null and @CaseNo is null )                                            
 begin                                            
 print 'atul case 1'                                            
                                             
       insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                
    Gender,FacilityId,FacilityName,ScheduleStatus,StatusName,ProviderId,RequestedDate,                                                 
    Clientid,ClientName,AppointmentDate,ClientType,TAT,FacilityType ,                                                       
       ISHNI,UpdatedBy,Relation,Username,OrderValue,CurrentOrder,OrderLimit,                                              
    NewDiscountPercentage,DiscountValidityDays,txnAmount,                                              
    CurrentClaim ,CurrentOrder1,DocCoachApptType,PlanName,PharmacyProviderName,Prescription,CancelledBy,CancelledDate,CancelledReason,          
 AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,MemberPlanId,CurrentDiplayOrder,IsNewPlan)                                             
                            
                         
 select apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                  
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityId,fm.FacilityName,                                              
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                             
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                               
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,0,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                              
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                             
  0,apt.DocCoachApptType as DocCoachApptType,                                           
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo        
  ,apt.AppointmentAddress as HomeAddress
  ,apt.Partner_orderid as PartnerOrderid,MPD.MemberPlanId ,0 ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan      
  from Appointment apt with (nolock)                                                  
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                      
  join UserLogin u on u.UserLoginId = mem.UserLoginId ----and u.Status != 'I'                                      
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
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                  
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                     
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                  
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                              
  left join LibertyEmpRegistration le with (nolock) on le.UserLoginId = u.UserLoginId                                              
  left join UserTokan ut with (nolock) on ut.UserLoginId=u.UserLoginId                          
  left join MedpayPharmacyOrderStatus mps with (nolock) on mps.OrderId=apt.CaseNo                      
  left join PharmacyProviderMaster ppm with (nolock) on ppm.ProviderId=mps.ProviderId                  
  left join ReportAppointment ra with (nolock) on ra.AppointmentId=apt.AppointmentId                  
  left join AppointmentLog al with (nolock) on al.AppointmentId=apt.AppointmentId and al.ScheduleStatus=7                      
                
  where  cast(apt.CreatedDate as date) = CAST(GETDATE() as date)                                       
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                            
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                            
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                    
and (@email is null OR mem.EmailId like '%'+@email+'%')                                             
and (@buType is null OR c.BUType like '%'+@buType+'%')                                          
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                                            
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                            
and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                  
and (apt.ScheduleStatus in (select * from SplitString(@StatusID,',')))                            
and apt.AppointmentType='PHM'                                    
 --ORDER BY al.CreatedDate DESC                                           
-- offset @RecordPerPage * (@PageNumber-1)rows                                                                
--FETCH NEXT @RecordPerPage rows only                                                
                       
                                              
                                            
 end                                            
                                            
 else if(@CaseNo is not null)                                            
 begin                                            
 print 'atul case'                                            
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                
    Gender,FacilityId,FacilityName,ScheduleStatus,StatusName,ProviderId,RequestedDate,                                                 
    Clientid,ClientName,AppointmentDate,ClientType,TAT,FacilityType ,                                                       
       ISHNI,UpdatedBy,Relation,Username,OrderValue,CurrentOrder,OrderLimit,                                
    NewDiscountPercentage,DiscountValidityDays,txnAmount,                                              
    CurrentClaim ,CurrentOrder1,DocCoachApptType,                                                
       PlanName,PharmacyProviderName,Prescription,CancelledBy,CancelledDate,CancelledReason,          
    AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,MemberPlanId,CurrentDiplayOrder,IsNewPlan )             
                                            
 select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                  
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityId,fm.FacilityName,                                              
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                             
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                            
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,0,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                              
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                       
  0,apt.DocCoachApptType as DocCoachApptType,                                              
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                      
           
  ,apt.AppointmentAddress as HomeAddress   
  ,apt.Partner_orderid as PartnerOrderid ,MPD.MemberPlanId ,0,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan     
  from Appointment apt with (nolock)                                                 
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                            
  join UserLogin u on u.UserLoginId = mem.UserLoginId ---and u.Status != 'I'                             
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
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                  
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                 
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                  
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                              
  left join LibertyEmpRegistration le with (nolock) on le.UserLoginId = u.UserLoginId                                              
  left join UserTokan ut with (nolock) on ut.UserLoginId=u.UserLoginId                       
  left join MedpayPharmacyOrderStatus mps with (nolock) on mps.OrderId=apt.CaseNo                      
  left join PharmacyProviderMaster ppm with (nolock) on ppm.ProviderId=mps.ProviderId                   
  left join ReportAppointment ra with (nolock) on ra.AppointmentId=apt.AppointmentId                  
  left join AppointmentLog al with (nolock) on al.AppointmentId=apt.AppointmentId and al.ScheduleStatus=7                      
                  
  where (@CaseNo is null or apt.CaseNo like @CaseNo)                                        
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                          
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                    
and (@email is null OR mem.EmailId like '%'+@email+'%')                                             
and (@buType is null OR c.BUType like '%'+@buType+'%')                                          
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                                            
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                       
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                  
and (apt.ScheduleStatus in (select * from SplitString(@StatusID,',')))                            
and apt.AppointmentType='PHM'                                          
-- ORDER BY al.CreatedDate DESC                                            
--offset @RecordPerPage * (@PageNumber-1)rows                                                                
--FETCH NEXT @RecordPerPage rows only                                              
                                              
                                            
 end                                            
                                            
 else                                            
 begin                                            
 print 'case 5'                                           
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                                
    Gender,FacilityId,FacilityName,ScheduleStatus,StatusName,ProviderId,RequestedDate,                                                 
    Clientid,ClientName,AppointmentDate,ClientType,TAT,FacilityType ,                                                       
       ISHNI,UpdatedBy,Relation,Username,OrderValue,CurrentOrder,OrderLimit,                                              
    NewDiscountPercentage,DiscountValidityDays,txnAmount,                                        
    CurrentClaim ,CurrentOrder1,DocCoachApptType,PlanName,PharmacyProviderName,Prescription,CancelledBy,CancelledDate,CancelledReason,          
  AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,MemberPlanId,CurrentDiplayOrder,IsNewPlan )                 
                                             
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',             
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',fm.FacilityId,fm.FacilityName,                                              
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                             
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                            
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,0,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                              
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                             
  0,apt.DocCoachApptType as DocCoachApptType,                                              
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                      
                       
      
     ,apt.AppointmentAddress as HomeAddress 
	 ,apt.Partner_orderid as PartnerOrderid,MPD.MemberPlanId ,0 ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan     
  from Appointment apt with (nolock)                                                  
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                        
  join UserLogin u on u.UserLoginId = mem.UserLoginId ----and u.Status != 'I'                              
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
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                         
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                  
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                  
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                              
  left join LibertyEmpRegistration le with (nolock) on le.UserLoginId = u.UserLoginId                 
  left join UserTokan ut with (nolock) on ut.UserLoginId=u.UserLoginId                        
  left join MedpayPharmacyOrderStatus mps with (nolock) on mps.OrderId=apt.CaseNo                      
  left join PharmacyProviderMaster ppm with (nolock) on ppm.ProviderId=mps.ProviderId                   
  left join ReportAppointment ra with (nolock) on ra.AppointmentId=apt.AppointmentId                  
  left join AppointmentLog al with (nolock) on al.AppointmentId=apt.AppointmentId and al.ScheduleStatus=7                           
                
  where (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))              
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                            
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                            
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                    
and (@email is null OR mem.EmailId like '%'+@email+'%')                                             
and (@buType is null OR c.BUType like '%'+@buType+'%')                                    
and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))                             
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                  
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                  
 and (apt.ScheduleStatus in (select * from SplitString(@StatusID,',')))                            
 and apt.AppointmentType='PHM'                                      
 --ORDER BY al.CreatedDate           
--DESC offset @RecordPerPage * (@PageNumber-1)rows                                                              
--FETCH NEXT @RecordPerPage rows only                                              
                                
  end                                            
                                                           
                             
  insert into #Temporaryone                                              
  select AppointmentId, UserLoginId,OrderNumber as CurrentOrdertemp  from dbo.ViewForCurrentOrder order by CurrentOrdertemp desc                            
                              
  update ww set ww.BookedBy=IIF(ISNULL(ww.Username,'') = ww.CustomerName,'Self',ww.Username) from #Temporary ww                        
              
                                              
                                      
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
                                                
   UPDATE #Temporary                                                  
   SET AppointmentDate = T.AppointmentDate                                                  
   FROM #TEMP T                                                  
   WHERE T.AppointmentId = #Temporary.AppointmentId                                                
                                                   
                     
    --update #Temporary                                               
    --set CurrentOrder1=t1.currentordertemp                                               
    --from  #Temporary  t                                               
    --join #Temporaryone t1 on t.AppointmentId=t1.AppointmentId    
	
	                                         
                                          
                                               
    Update #Temporary                                                 
    set CurrentOrder =
	(select ISnull(count(ttA.AppointmentId),0) + 1 as CurrentOrder from  Appointment ttA  
	join memberplandetails mpd on mpd.AppointmentId=ttA.AppointmentId
	where ttA.AppointmentType='PHM' and ttA.ScheduleStatus=19  and #Temporary.UserLoginId = ttA.UserLoginId and #Temporary.MemberPlanId=mpd.MemberPlanId)                                              
                                              
     
	Update #Temporary                                                 
    set CurrentDiplayOrder =
	(select ISnull(count(ttA.AppointmentId),0) as CurrentOrder from  Appointment ttA  
	join memberplandetails mpd on mpd.AppointmentId=tta.AppointmentId and mpd.isactive='Y'
	where ttA.AppointmentType='PHM' and ttA.ScheduleStatus not in (7)  and #Temporary.UserLoginId = ttA.UserLoginId and #Temporary.MemberPlanId=mpd.MemberPlanId)                                              
       
	--update #Temporary                                            
 --   set CurrentOrder1=CurrentDiplayOrder                                             
 --   from  #Temporary  t      
	--join Appointment aa on aa.appointmentid= t.AppointmentId                                        
 --   where t.AppointmentId=aa.appointmentid  

	Update #Temporary   
    set CurrentOrder1=(select (select count(a.AppointmentId) from appointment a 
	join memberplanDetails mpdd on a.AppointmentId=mpdd.AppointmentId
	where mpdd.memberplanid=#Temporary.MemberPlanId
	 and a.AppointmentType='PHM' 
	 AND a.USERLOGINID=#Temporary.UserLoginId 
	 AND a.ScheduleStatus not in (7) 
	 and a.appointmentid < #Temporary.AppointmentId ) +  1)
	
	   
	Declare @MemberPlanId varchar(100)=(select top 1 mp.memberplanId from MemberPlanDetails mp join appointment a on mp.AppointmentId=a.AppointmentId
	                                        where CaseNo=@CaseNo); 

	  
	   
--------------------------------	                                                                                  
    --Update #Temporary                                                
    --set #Temporary.OrderLimit=ISnull(CP.PharmacyOrderLimit,0),                                              
    --#Temporary.NewDiscountPercentage=case WHEN DATEDIFF(day,MP.FromDate,@CurrentDateTime) <= ISnull(CP.PharmaDiscDuration,0) and #Temporary.CurrentOrder - 1 < ISnull(CP.PharmacyOrderLimit ,0) THEN CAST(ISnull(CP.PharmacyDiscPercentage,0) as varchar(10)) 
    
    --ELSE 'Default' END,                                 
    --#Temporary.DiscountValidityDays= case WHEN Sign(ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) ) < 0 then 0 else ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) END                            
     
    --from CorporatePlan CP                                                
    --inner join MemberPlan MP on MP.CorporatePlanId=CP.CorporatePlanId      and  MP.MemberPlanId= @MemberPlanId                                            
    --inner join Member MM on MM.MemberId=MP.MemberId                                              
    --where MM.UserLoginId=#Temporary.UserLoginId and ISnull(CP.PharmacyDiscflag,0)=1   
--------------------------------	
	 Update #Temporary                                                
    set #Temporary.OrderLimit=ISnull(CP.PharmacyOrderLimit,0),                                              
    #Temporary.NewDiscountPercentage=case WHEN DATEDIFF(day,MP.FromDate,@CurrentDateTime) <= ISnull(CP.PharmaDiscDuration,0) and #Temporary.CurrentOrder - 1 < ISnull(CP.PharmacyOrderLimit ,0) THEN CAST(ISnull(CP.PharmacyDiscPercentage,0) as varchar(10)) 

	     
    ELSE 'Default' END,                                 
    #Temporary.DiscountValidityDays= case WHEN Sign(ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) ) < 0 then 0 else ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) END                            
  
    
      
    from Appointment Amp 
	Inner Join MemberPlanDetails MPD on MPD.AppointmentId=Amp.AppointmentId
	Inner join memberplan MP on MP.MemberPlanId=MPD.MemberPlanId
	Inner Join CorporatePlan CP on CP.CorporatePlanId=MPD.CorporatePlanId
	where #Temporary.AppointmentId= Amp.AppointmentId and CP.PharmacyDiscflag=1                                                    
 -----------------------------------------------------------------     
	                                   
                         
    update T      
	set IsSplitOrder = ISNULL(A.IsSplitOrder,'N')
	from AppointmentSkuDetails A  
	join #Temporary T on T.AppointmentId=A.AppointmentId
	
	
	Update #Temporary   
    set UpdatedBy=
	(select top 1 al.CreatedBy from AppointmentLog al where al.AppointmentId=#Temporary.AppointmentId  order by al.CreatedDate desc)                                  

------------------cancel reason----------------------------------------------- 
	
 declare @countofcancelRemarksforCase varchar(100)=(select count(al.remarks)  from appointmentlog al join #Temporary t on al.AppointmentId=t.AppointmentId where  al.ScheduleStatus=7 and al.AppointmentId=t.AppointmentId and al.CallStatus is null);

 print 'count of cancelRemarks ='+@countofcancelRemarksforCase

 if @countofcancelRemarksforCase > 1
 begin

    Update #Temporary                                                
    set #Temporary.CancelledReason =
    (select top 1  al1.remarks 
    from Appointment a1
	Inner Join AppointmentLog al1 on a1.AppointmentId=al1.AppointmentId 
	where #Temporary.AppointmentId=al1.AppointmentId and al1.ScheduleStatus=7 and al1.CallStatus is null and al1.UserLoginId is not null)
     
 end
 else
 begin
    Update #Temporary                                                
    set #Temporary.CancelledReason=
    al1.remarks 
    from Appointment a1
	Inner Join AppointmentLog al1 on a1.AppointmentId=al1.AppointmentId 
	where #Temporary.AppointmentId=a1.AppointmentId  and al1.ScheduleStatus=7   and al1.UserLoginId is null
 end
                                                    
 -----------------------------------------------------------------                                             
                                              
/*******************End Main Logic****************************************************/                                              
--------------------------------------------------------------------------------------                                              
               
                                              
                                                 
  /*****************Select All table*************************************************/                                              
                                                 
  select   distinct * from #Temporary  ORDER BY #Temporary.CancelledDate DESC           
 offset @RecordPerPage * (@PageNumber-1)rows                                                                
FETCH NEXT @RecordPerPage rows only            
          
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                                
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                              
                                                 
                                                   
              
/*****************End Select All Table********************************************/                                              
   drop table #Temporary                                           
   drop table #Temporaryone                             
   drop table #TEMP                            
  end 