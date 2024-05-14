select top 10  u.UserLoginId,cp.CNPlanDetailsId as CorporatePlanId,cp.PlanName,c.ClientId,c.ClientName,u.FirstName,u.LastName,m.MobileNo,m.EmailId,u.CreatedDate as UserCreatedDate,mp.ToDate as PlanExpiryDate,                      
isnull(cp.PlanCode,'') as PlanCode,mp.UserPlanDetailsId as MemberPlanId ,m.MemberId,IsNull(mcd.UpdatedBy,mcd.CreatedBy) as CallerName,'' as Remarks,IsNull(cs.[CallStatus],'') as callStatus,-- fm.FacilityId,                      
IsNull(cs.[SubCallStatus],'') as callResponce,Isnull(mcd.UpdatedDate,mcd.CreatedDate) as [lastContacted],mcd.NextCallDate as requestedCallingDate,u.UserName        -------------Table 1                             
from UserLogin u with (nolock)                              
inner join Member m with (nolock) on u.UserLoginId=m.UserLoginId                              
inner join UserPlanDetails mp with (nolock) on m.MemberId=mp.MemberId                              
--inner join MemberBucketBalance mbb with (nolock) on  mbb.UserPlanDetailsId = mp.UserPlandetailsId    and mbb.AppointmentId IS NULL 
inner join CNPlanDetails cp with (nolock) on mp.CNPlanDetailsId=cp.CNPlanDetailsId                              
inner join client c with (nolock) on u.clientId=c.clientId 
left join MemberCallDetails mcd with (nolock) on u.UserLoginId=mcd.UserLoginId and mcd.OpsMenuName='NonUsageFully'                                
left Join callStatus cs with (nolock) on mcd.StatusId = cs.CallStatusId                       
                    
where m.Relation='SELF'  and mp.UserPlanDetailsId=53


and
(SELECT top 1 BalanceAmount FROM MemberBucketBalance where UserPlanDetailsId=mp.UserPlanDetailsId  and ActiveStatus='Y' order by 1 asc) = 
(SELECT top 1 ISNULL(BalanceAmount,-1) FROM MemberBucketBalance where UserPlanDetailsId=mp.UserPlanDetailsId  and ActiveStatus='Y' order by 1 desc)order BY 1 desc;

SELECT TOP 10 * FROM UserPlanDetails;

SELECT TOP 10 * FROM MemberPlanDetails order by 1 desc;

SELECT  count(*) FROM MemberBucketBalance where UserPlanDetailsId=2 and AppointmentId is not null and ActiveStatus='Y'

SELECT  * FROM MemberBucketBalance where UserPlanDetailsId=53 order by 1 asc