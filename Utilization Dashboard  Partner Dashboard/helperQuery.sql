SELECT * FROM LibertyEmpRegistration WHERE PolicyNo = 'OPD-HAOPDR00U43-29693'

SELECT PartnerOrderId,* FROM OPDPaymentDetails  WHERE PolicyNo = 'OPD-HAOPDR00U43-29693'

SELECT * FROM MemberPlan WHERE MemberPlanId=4691526

SELECT * FROM UserLogin where UserLoginId = 5978115

SELECT * FROM Appointment where UserLoginId = 5978115

SELECT * FROM AppointmentDetails where AppointmentId=390936

SELECT * from HaRateMaster where facilityId = 4635

SELECT * FROM Client where clientId = 258

SELECT * FROM FacilitiesMaster where FacilityGroup like '%Family%'





UNION

Select u.UserloginId,u.CreatedDate,apt.AppointmentId,apt.caseNo,apt.ClientId
--,mpd.MemberPlanDetailsId,mpd.FacilityId
,null,null

--,cp.PlanType
,null
,mbp.PlanBucketType --AppointmentPlanType

--,[dbo].[AppointmentPlanTypeForOldPlan](cp.PlanType,mpd.points,mpd.partialPoints)
,null
--,ISNULL(mpd.Points,0) as Points,ISNULL(mpd.PartialPoints,0) as PartialPoints
,null

--,mpd.IsUtilized,mpd.IsActive
,null,null


,'Y',mbb.BucketBalanceId, Up.UserPlanDetailsId, mbp.MemberPLanBucketId,ISNULL(mbb.TransactionAmount,0)
from UserLogin u

join Appointment apt on U.userLoginId = apt.UserLoginId
join MemberBucketBalance mbb on mbb.AppointmentId = apt.AppointmentId and mbb.ActiveStatus='Y'
join MemberPLanBucket mbp on mbp.MemberPLanBucketId=mbb.MemberPLanBucketId
join UserPlanDetails Up on mbp.UserPlanDetailsId = Up.UserPlanDetailsId
join CNPlanDetails Cn on Cn.CNPlanDetailsId=Up.CNPlanDetailsId

where apt.ClientId=292 
and (apt.ScheduleStatus=6  OR (apt.AppointmentType='PHM' AND apt.ScheduleStatus=19 ))
and apt.UserLoginId IN ( select UserLoginId from #TempUser)

and cast(u.CreatedDate as date)  between Convert(date, (DATEADD(year, -1, getdate()))) and CONVERT(date,  getdate());