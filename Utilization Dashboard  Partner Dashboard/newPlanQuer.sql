
--SELECT * FROM MemberPlanBucket order by 1 desc
--Select * From MemberBucketBalance order by 1 desc
--SELECT * FROM MemberBucketBalance where AppointmentId = 397766

Select * from UserLogin where UserloginId=6193412 order by 1 desc
SELECT * FROM OPDPaymentDetails
SELECT * FROM LibertyEmpRegistration where PolicyNo='OPD-HAOPDR001-01-1'

CREATE TABLE #TEMP (UserLoginid BigINT, UserCreatedDate datetime ,AppointmentId bigint,CaseNo VARCHAR(300), ClientId bigint,
                    MemberPlanDetailsId BIGINT, FacilityId Bigint, corporatePlanType int, AppointmentPlanType VARCHAR(100),Points MONEY, PartialPoints MONEY, 
					IsUtilized VARCHAR(1), IsActive VARCHAR(1), SumWalletAmount MONEY, CreditSumAmount Money,
					IsWithNewPlan VARCHAR(1),MemberBucketBalanceId BIGINT,UserPlanDetailsId BIGINT, MemberPlanBucketId BIGINT, TransactionAmountNewPlan DECIMAL);

INSERT INTO #TEMP
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
 --SumWalletAmount,CreditSumAmount
,null,null

,'Y',mbb.BucketBalanceId, Up.UserPlanDetailsId, mbp.MemberPLanBucketId, ISNULL(mbb.TransactionAmount,0)
from UserLogin u

join Appointment apt on U.userLoginId = apt.UserLoginId
join MemberBucketBalance mbb on mbb.AppointmentId = apt.AppointmentId and mbb.ActiveStatus='Y'
join MemberPLanBucket mbp on mbp.MemberPLanBucketId=mbb.MemberPLanBucketId
join UserPlanDetails Up on mbp.UserPlanDetailsId = Up.UserPlanDetailsId
join CNPlanDetails Cn on Cn.CNPlanDetailsId=Up.CNPlanDetailsId

where apt.ClientId=292 and apt.ScheduleStatus=6 

and cast(u.CreatedDate as date)  between Convert(date, (DATEADD(year, -1, getdate()))) and CONVERT(date,  getdate())

SELECT * FROM #TEMP

DROP Table #TEMP;