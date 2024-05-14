USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspGetRefundBooking]    Script Date: 4/16/2024 10:31:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Created By Pruthviraj Kengar	
-- Created Date 02192024           
-- exec [uspGetRefundBooking] null,null,null,null,null,1,10,null,null,null,null,null,'Fulfilment',null  

ALTER PROCEDURE [dbo].[uspGetRefundBooking]                                         
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
   if(@MenuName='Confirmation')                                        
   Begin                                    
     set @StatusID=('47,50')                                    
   End                                    
   if(@MenuName='Fulfilment')                                        
   Begin                                    
     set @StatusID=('43,23')                                    
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
   AgentName varchar(100),AgentMobileNo bigint,PartnerOrderid varchar(100),IsSplitOrder varchar(10),IsNewPlan char,RefundAmount int,Paymentid varchar(250),TransactionId varchar(500),RefundStatus varchar(500),RazorRefundId varchar(500),RefundCreatedOn varchar(500),RefundProcessedOn varchar(500),IsRefund char,MemberPaymentDetailsId bigint
   ,RefundReason varchar(500),RefundDoneBy varchar(100)  )     --added for HAP-2391 on 27-03-2024 
   
                                              
    Create table #Temporaryone(AppointmentId bigint,UserLoginId bigint,CurrentOrdertemp int)                                            
/****************************End DECLARE VARIABLES********************************************************/                                                                                        
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
 AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,IsNewPlan,RefundAmount,Paymentid,TransactionId,RefundStatus,RazorRefundId,RefundCreatedOn,RefundProcessedOn,IsRefund,MemberPaymentDetailsId
 ,RefundReason ,RefundDoneBy   )       --added for HAP-2391 on 27-03-2024                                       
                          
                       
  select apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,null,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                             
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                           
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo      
  ,apt.AppointmentAddress as HomeAddress 
  ,apt.Partner_orderid as PartnerOrderid ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan   
  ,srh.RefundAmount,pgi.PaymentId,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,mpds.MemberPaymentDetailsId
  ,null,null   --added for HAP-2391 on 27-03-2024  
  from Appointment apt with (nolock) 
  join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join MemberPaymentDetails mpds on srh.TransactionId=mpds.TransactionId and mpds.Status='Success'
  join PaymentgatewayApilogs pgi on pgi.TransactionId=mpds.TransactionId and pgi.Paymentid is not null
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
  and (srh.RefundStatusId in (select * from SplitString(@StatusID,',')))         
  and apt.schedulestatus=7
union all
select apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,null,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                             
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                           
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo      
  ,apt.AppointmentAddress as HomeAddress 
  ,apt.Partner_orderid as PartnerOrderid ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan   
  ,srh.RefundAmount,uts.PaymentId,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,uts.Id as MemberPaymentDetailsId 
  ,null,null   --added for HAP-2391 on 27-03-2024  
  from Appointment apt with (nolock)    
  join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join UserTransactions uts on uts.transactionId=srh.TransactionId and uts.Status='Success'
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                    
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                                    
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                       
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                             
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                 
  join UserPlanDetails MPD with (nolock) on MPD.UserPlanDetailsId=apt.UserPlanDetailsId                                           
  join CNPlanDetails cj on cj.CNPlanDetailsId=MPD.CNPlanDetailsId                                          
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
              
  where (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                          
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                          
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                  
  and (@email is null OR mem.EmailId like '%'+@email+'%')                                           
  and (@buType is null OR c.BUType like '%'+@buType+'%')                                        
  and (@Plan is null or cj.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                                          
  and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                          
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                
  and (srh.RefundStatusId in (select * from SplitString(@StatusID,',')))                                
  and apt.schedulestatus=7
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
    AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,IsNewPlan,RefundAmount,Paymentid,TransactionId,RefundStatus,RazorRefundId,RefundCreatedOn,RefundProcessedOn,IsRefund,
	MemberPaymentDetailsId
	,RefundReason ,RefundDoneBy  )       --added for HAP-2391 on 27-03-2024        
                                          
 select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,fm.FacilityName,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                          
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                     
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                     
        
  ,apt.AppointmentAddress as HomeAddress 
  ,apt.Partner_orderid as PartnerOrderid,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan 
  ,srh.RefundAmount,pgi.PaymentId,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,mpds.MemberPaymentDetailsId
  ,null,null   --added for HAP-2391 on 27-03-2024 
  from Appointment apt with (nolock)   
  join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join MemberPaymentDetails mpds on srh.TransactionId=mpds.TransactionId and mpds.Status='Success'
  join PaymentgatewayApilogs pgi on pgi.TransactionId=mpds.TransactionId and pgi.Paymentid is not null
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
  and (srh.RefundStatusId in(select * from SplitString(@StatusID,',')))                          
                       
union all
select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',                                                
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,fm.FacilityName,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                          
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                     
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                     
  ,apt.AppointmentAddress as HomeAddress 
  ,apt.Partner_orderid as PartnerOrderid,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan   
  ,srh.RefundAmount,uts.PaymentId,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,uts.Id as MemberPaymentDetailsId 
  ,null,null   --added for HAP-2391 on 27-03-2024 
  from Appointment apt with (nolock)          
  join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join UserTransactions uts on uts.transactionId=srh.TransactionId and uts.Status='Success'
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                          
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                           
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                                                            
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                
  join SystemCode s with (nolock) on  apt.AppointmentType=s.Code and s.CodeType='Process'                                                 
  join UserPlanDetails MPD with (nolock) on MPD.UserPlanDetailsId=apt.UserPlanDetailsId                                            
  join CNPlanDetails cj on cj.CNPlanDetailsId=MPD.CNPlanDetailsId                                          
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
and (@Plan is null or cj.CNPlanDetailsId in(select * from SplitString(@Plan,',')))                                          
 and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                     
 and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')                                
and (srh.RefundStatusId in (select * from SplitString(@StatusID,',')))                          
           
 end                                          
                                          
 else                                          
 begin                                          
 print 'case 5' 
 print @StatusID
   insert into #Temporary (AppointmentId,CaseNo,AppointmentType,UserLoginId,MemberId,CustomerName,EmailId,MobileNo,                                              
    Gender,FacilityId,FacilityName,ScheduleStatus,StatusName,ProviderId,RequestedDate,                                               
    Clientid,ClientName,AppointmentDate,ClientType,TAT,FacilityType ,                                                     
       ISHNI,UpdatedBy,Relation,Username,OrderValue,CurrentOrder,OrderLimit,                                            
    NewDiscountPercentage,DiscountValidityDays,txnAmount,                                            
    CurrentClaim ,CurrentOrder1,DocCoachApptType,PlanName,PharmacyProviderName,Prescription,CancelledBy,CancelledDate,CancelledReason,        
  AgentName,AgentMobileNo,HomeAddress,PartnerOrderid,IsNewPlan,RefundAmount,Paymentid,TransactionId,RefundStatus,RazorRefundId,RefundCreatedOn,RefundProcessedOn,IsRefund,MemberPaymentDetailsId
  ,RefundReason ,RefundDoneBy  )     --added for HAP-2391 on 27-03-2024          
                                           
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',        
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,null,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                          
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                           
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                     
    ,apt.AppointmentAddress as HomeAddress,
	 apt.Partner_orderid as PartnerOrderid ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan 
 ,srh.RefundAmount,pgi.Paymentid,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,uts.MemberPaymentDetailsId
 ,null,null   --added for HAP-2391 on 27-03-2024  
   from Appointment apt with (nolock)    
  join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
  join MemberPaymentDetails uts on uts.transactionId=srh.TransactionId and uts.Status='Success'
  join PaymentgatewayApilogs pgi on pgi.TransactionId=uts.TransactionId and pgi.Paymentid is not null
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
  left join [HAPortal].dbo.Provider pr with (nolock) on ad.ProviderId=pr.ProviderId                                                
  left join DoctorMaster dm with (nolock) on apt.TDDoctorId= CAST(dm.DoctorId as varchar(10))                                                
  left join VideoConsultationData vd with (nolock) ON apt.AppointmentId = vd.AppointmentId                                                
  left join ReimbursementMemberPlanDetails rp with (nolock) on rp.AppointmentId=apt.AppointmentId                                            
  left join LibertyEmpRegistration le with (nolock) on le.UserLoginId = u.UserLoginId               
  left join UserTokan ut with (nolock) on ut.UserLoginId=u.UserLoginId                      
  left join MedpayPharmacyOrderStatus mps with (nolock) on mps.OrderId=apt.CaseNo                    
  left join PharmacyProviderMaster ppm with (nolock) on ppm.ProviderId=mps.ProviderId                 
  left join ReportAppointment ra with (nolock) on ra.AppointmentId=apt.AppointmentId                
  left join AppointmentLog al with (nolock) on al.AppointmentId=apt.AppointmentId and apt.ScheduleStatus=7                                               
              
  where (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))            
and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                          
and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                          
and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                  
and (@email is null OR mem.EmailId like '%'+@email+'%')                                                                    
and srh.RefundStatusId in (select * from SplitString(@StatusID,',')) and apt.ScheduleStatus=7
                                   
 union all
  select  apt.AppointmentId,apt.CaseNo,s.ShortDesc as 'Appointment Type',isnull(apt.UserLoginId,0),mem.MemberId,Concat(mem.FirstName,' ',mem.LastName) as 'Customer Name',        
  mem.EmailId,mem.MobileNo,CASE mem.Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' ELSE 'Other' END as 'Gender',null,null,                                            
  st.StatusId,st.StatusName,ISNULL(pr.ProviderId,0),CONVERT(VARCHAR,apt.CreatedDate,126),                                           
  apt.ClientId,c.ClientName,NULL,Case c.ClientType  WHEN  3 THEN 'Corporate' ELSE 'SME' END 'ClientType',                                          
  0,fm.FacilityType,CASE WHEN mem.IsHNI = 'Y' THEN 'Yes' ELSE 'No' END AS IsHNI,apt.UpdatedBy,mem.Relation,apt.CreatedBy,apt.TDAmount,0,0,'Default',                                            
  0,ISNULL(apt.TotalAmount,0),isnull(rp.CurrentClaimNo,0),                                           
  0,apt.DocCoachApptType as DocCoachApptType,                                            
  cj.PlanName,ppm.ProviderName,ISNULL(ra.ReportSavePath,'') as Prescription,al.CreatedBy,IsNull(al.CreatedDate,'') as CancelledDate,IsNull(al.Remarks,'') as CancelledReason,IsNull(le.AgentName,'NA'  )as AgentName,IsNull(le.AgentMobileNo,'') as AgentMobileNo                                     
     ,apt.AppointmentAddress as HomeAddress,
	 apt.Partner_orderid as PartnerOrderid ,case when apt.UserPlanDetailsId is null then 'N' when apt.UserPlanDetailsId = 0 then 'N' else 'Y' end as IsNewPlan 
  ,srh.RefundAmount,srh.RazorpayRefundId,srh.Transactionid,srh.RefundStatusName,srh.RazorpayRefundId,srh.CreatedDatetime,srh.UpdatedDatetime,case when srh.remarks is not null and srh.RazorpayRefundId is null then 'Y' else 'N' end,uts.Id as MemberPaymentDetailsId 
  ,null,null   --added for HAP-2391 on 27-03-2024  
  from Appointment apt with (nolock)       
   join ServiceRefundHistory srh on apt.AppointmentId=srh.Appointmentid
     join UserTransactions uts on uts.transactionId=srh.TransactionId and uts.Status='Success'
  join Member mem with (nolock) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'                                      
  join UserLogin u on u.UserLoginId = mem.UserLoginId and u.Status != 'I'                            
  join Member M with(nolock) on M.UserLoginId=u.UserLoginId and M.Relation='SELF'                   
  join AppointmentDetails ad with (nolock) on apt.AppointmentId=ad.AppointmentId                                                
  join FacilitiesMaster fm with (nolock) on case when ad.PakageId = 0 then ad.TestId else ad.PakageId end=fm.FacilityId                                                
  join StatusMaster st with (nolock) on apt.ScheduleStatus=st.StatusId                                                
  join SystemCode s with (nolock) on  REPLACE( apt.AppointmentType,'HC','MC')  =s.Code and s.CodeType='Process'                                                 
  join UserPlanDetails MPD with (nolock) on MPD.UserplanDetailsId=apt.UserplandetailsId                                            
  join CNPlanDetails cj on cj.CNPlanDetailsId=MPD.CNPlanDetailsId                                          
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
  left join AppointmentLog al with (nolock) on al.AppointmentId=apt.AppointmentId and apt.ScheduleStatus=7                                               
  where (@FromDate is null and @ToDate is null OR cast (apt.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))
  and (@name is null OR (mem.FirstName +' '+mem.LastName) like '%'+@name+'%')                                          
  and (@CaseNo is null OR apt.CaseNo like '%'+@CaseNo+'%')                                          
  and (@phone is null OR mem.MobileNo like '%'+@phone+'%')                                                                  
  and (@email is null OR mem.EmailId like '%'+@email+'%')                                                                           
  and srh.RefundStatusId in (select * from SplitString(@StatusID,',')) and (apt.ScheduleStatus = 7)
                      
end                                          
                                                         
 
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
set T.RefundReason= R.Remarks,T.RefundDoneBy=R.CreatedBy
from #Temporary T left join #Refunddata R on T.AppointmentId=R.AppointmentId
where  T.AppointmentId=R.AppointmentId
---------------------Refund Logic end------------------------------
                          
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
                                                 
                   
    update #Temporary                                             
    set CurrentOrder1=t1.currentordertemp                                             
    from  #Temporary  t                                             
    join #Temporaryone t1 on t.AppointmentId=t1.AppointmentId                                           
                                              
    Update #Temporary                                               
    set CurrentOrder =(select ISnull(count(AppointmentId),0) + 1 as CurrentOrder from  Appointment ttA  where ttA.AppointmentType='PHM' and ttA.ScheduleStatus=19                                            
    and #Temporary.UserLoginId = ttA.UserLoginId)                                            
                                            
    Update #Temporary                                              
    set #Temporary.OrderLimit=ISnull(CP.PharmacyOrderLimit,0),                                            
    #Temporary.NewDiscountPercentage=case WHEN DATEDIFF(day,MP.FromDate,@CurrentDateTime) <= ISnull(CP.PharmaDiscDuration,0) and #Temporary.CurrentOrder - 1 < ISnull(CP.PharmacyOrderLimit ,0) THEN CAST(ISnull(CP.PharmacyDiscPercentage,0) as varchar(10))  
   
    ELSE 'Default' END,                               
    #Temporary.DiscountValidityDays= case WHEN Sign(ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) ) < 0 then 0 else ISnull(CP.PharmaDiscDuration,0) - DATEDIFF(day,MP.FromDate,@CurrentDateTime) END                            
   
    from CorporatePlan CP                                              
    inner join MemberPlan MP on MP.CorporatePlanId=CP.CorporatePlanId                                             
    inner join Member MM on MM.MemberId=MP.MemberId                                            
    where MM.UserLoginId=#Temporary.UserLoginId and ISnull(CP.PharmacyDiscflag,0)=1                                            
                                            
                       
    update T      
	set IsSplitOrder = ISNULL(A.IsSplitOrder,'N')
	from AppointmentSkuDetails A  
	join #Temporary T on T.AppointmentId=A.AppointmentId                    
                                            
/*******************End Main Logic****************************************************/                                            
--------------------------------------------------------------------------------------                                            
                                              
  /*****************Select All table*************************************************/                                            
                                               
  select   distinct * from #Temporary  ORDER BY #Temporary.CancelledDate Desc         
  offset @RecordPerPage * (@PageNumber-1)rows                                                              
  FETCH NEXT @RecordPerPage rows only          
        
   select count( DISTINCT CaseNo) as 'RecordsCount' from #Temporary  tmp                                              
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                            
                     
/*****************End Select All Table********************************************/                                            
   drop table #Temporary                                         
   drop table #Temporaryone                           
   drop table #TEMP                          
  end 