USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[GetUtilizationDashboard]    Script Date: 7/11/2024 3:07:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<SAURAV SAXENA>
-- Create date: <05 July 2024>
-- Description:	<Description,,>

-- exec [GetUtilizationDashboard] 'ALL,ELITE0011,ELITE0012,ELITE0013,ELITE0014,ELITE0015,ELITEASIAN01,ELITEBALAJI08,ELITECLIQ19,ELITEDAPL01,ELITEDIAGNO13,ELITEDIAGNO26,ELITEDPTRADE21,ELITEFINATRIK18,ELITEINDIA10,ELITEINFINITY28,ELITEINFOCOM01,ELITEIPTM25,ELITEMANAWA04,ELITEMAXI10,ELITEMMM23,ELITEMVISION22,ELITEONE07,ELITEPowerz24,ELITERAHI01,ELITERAP20,ELITEREFER27,ELITEREVBAY17,ELITERP06,ELITESHREE09,ELITESPUR02,ELITETRONO14,ELITEVIIBGYOR16,ELITEWAY03,OMSHREE15','292','2024-04-01','2024-05-15',null,null,'YTD',null,null
--exec [GetUtilizationDashboard] 'ELITEDAPL01','292','2024-04-01','2024-05-15',null,null,'MTD',null,null
-- =============================================
ALTER PROCEDURE [dbo].[GetUtilizationDashboard]
	@PartnerCode varchar(max)=null,
	@ClientIds varchar(max)=null,
	@Fromdate varchar(100) =null,
	@Todate varchar(100)=null,
	@PolicyNo varchar(100)=null,
	@UserLoginId BIGINT=null,
	@DateType VARCHAR(199) =NULL,
	@PlanId BIGINT=NULL,
	@IsWithNewPlan VARCHAR(10)=NULL

AS
BEGIN
DECLARE @FitnessProcessCode VARCHAR(MAX) = (SELECT STRING_AGG( ProcessCode ,',')from FacilitiesMaster where FacilityGroup='Fitness');

PRINT '@FitnessProcessCode'
PRINT @FitnessProcessCode

SET @Todate =  CONVERT(date,  getdate());
IF @DateType = 'ITD'
BEGIN
  SET @Fromdate=Convert(date, (DATEADD(year, -1, getdate())));
END
ELSE IF @DateType = 'YTD'
BEGIN
  DECLARE @Month BIGINT = MONTH(GETDATE());
  IF @Month>=4
  BEGIN
    SET @FromDate=DATENAME (YEAR, GETDATE())+'-04-01';
  END
  ELSE
   BEGIN
     DECLARE @year bigint = DATENAME (YEAR, GETDATE());
     SET @FromDate=CAST(@year-1 as varchar(20))+'-04-01';
   END
END
ELSE IF @DateType = 'FTD'
BEGIN
  SET @FromDate=CONVERT(date,  getdate());
END
ELSE
BEGIN
  SET @Fromdate=Convert(date, (DATEADD(MONTH, -1, getdate())));
END
print '@FromDate'
print @FromDate

print '@Todate'
print @ToDate

CREATE Table #TempUser(UserloginId BIGINT, OPDPaymentDetailsId BIGINT , 
PolicyNo VARCHAR(100), PartnerName VARCHAR(100),PartnerCode VARCHAR(100),
OPDPaymentAmount DECIMAL,CorporatePlanId BIGINT,MemberPlanId BIGINT, CNPlanDetailsId BIGINT,UserPlanDetailsId BIGINT, 
PolicyFromDate DATETIME, PolicyEndDate DATETIME,TotalTennure BIGINT ,
RelizedDays BIGINT,IsWithNewPlan VARCHAR(1),DivideRelizedDays DECIMAL(18,2)
,PolicyRelizedPreimium DECIMAL(18,2)) 

Insert INTO #TempUser
SELECT u.UserLoginId,opd.OPDPaymentDetailsId,l.PolicyNo
,opdp.PartnerName,opdp.PartnerCode,opd.Amount
,cp.CorporatePlanId,mp.MemberPlanId,null,null
,mp.FromDate,mp.ToDate, DATEDIFF(day, mp.FromDate, mp.ToDate), DATEDIFF(day,mp.FromDate, GETDATE())+1,'N',0,0
FROM UserLogin u
join LibertyEmpRegistration l on l.UserLoginId=u.UserLoginId
join OPDPaymentDetails opd on opd.PolicyNo = l.PolicyNo
join OPDPartnerDetails opdp on cast(opdp.OPDPartnerDetailsId as varchar(100))=cast(opd.PartnerOrderId as varchar(100))
join MemberPlan mp on mp.MemberPlanId = l.MemberPlanId AND mp.IsActive='Y'
join CorporatePlan cp on cp.CorporatePlanId = mp.CorporatePlanId
where cast(mp.FromDate as date)  between @Fromdate and @Todate
and opdp.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') ) 
--and l.ClientId=292
and( (@ClientIds is null or TRIM(@ClientIds)='') OR (l.ClientId in (select * from STRING_SPLIT(@ClientIds, ',') ) ) )
and ( @PolicyNo is null or opd.PolicyNo = @PolicyNo)
and (@UserLoginId is null or u.UserLoginId=@UserLoginId)
and (@IsWithNewPlan IS NULL or (@IsWithNewPlan='N' AND cp.CorporatePlanId=@PlanId))

UNION all

SELECT u.UserLoginId,opd.OPDPaymentDetailsId,l.PolicyNo
,opdp.PartnerName,opdp.PartnerCode,opd.Amount
,null,null,cn.CNPlanDetailsId,up.UserPlanDetailsId
,up.FromDate,up.ToDate, DATEDIFF(day, up.FromDate, up.ToDate), DATEDIFF(day,up.FromDate, GETDATE())+1,'Y',0,0
FROM UserLogin u
join LibertyEmpRegistration l on l.UserLoginId=u.UserLoginId
join OPDPaymentDetails opd on opd.PolicyNo = l.PolicyNo
join OPDPartnerDetails opdp on cast(opdp.OPDPartnerDetailsId as varchar(100))=cast(opd.PartnerOrderId as varchar(100))
join UserPlanDetails up on up.UserPlanDetailsId = l.UserPlanDetailsId and up.ActiveStatus='Y'
join CNPlanDetails cn on cn.CNPlanDetailsId=up.CNPlanDetailsId
where cast(Up.FromDate as date) between @Fromdate and @Todate
and opdp.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') ) 
--and l.ClientId=292
and( (@ClientIds is null or TRIM(@ClientIds)='') OR (l.ClientId in (select * from STRING_SPLIT(@ClientIds, ',') ) ) )
and ( @PolicyNo is null or opd.PolicyNo = @PolicyNo)
and (@UserLoginId is null or u.UserLoginId=@UserLoginId)
and (@IsWithNewPlan IS NULL or (@IsWithNewPlan='Y' AND cn.CNPlanDetailsId=@PlanId));



CREATE TABLE #TEMP (UserLoginid BigINT, UserCreatedDate datetime ,AppointmentId bigint,CaseNo VARCHAR(300), ClientId bigint,
                    MemberPlanDetailsId BIGINT, FacilityId Bigint, FacilityGroup VARCHAR(100), corporatePlanType int, 
					AppointmentPlanType VARCHAR(100)
					,Points DECIMAL(18,2), PartialPoints DECIMAL(18,2), 
					IsUtilized VARCHAR(1), IsActive VARCHAR(1), 
					IsWithNewPlan VARCHAR(1),MemberBucketBalanceId BIGINT,UserPlanDetailsId BIGINT
					, MemberPlanBucketId BIGINT,TransactionAmountNewPlan DECIMAL(18,2));

INSERT INTO #TEMP
Select u.UserloginId,u.CreatedDate,apt.AppointmentId,apt.caseNo,apt.ClientId
,mpd.MemberPlanDetailsId,mpd.FacilityId,fm.FacilityGroup
,cp.PlanType
, [dbo].[AppointmentPlanTypeForOldPlan](cp.PlanType,mpd.points,mpd.partialPoints)  --AppointmentPlanType

,ISNULL(mpd.Points,0) as Points
,ISNULL(mpd.PartialPoints,0) as PartialPoints,mpd.IsUtilized,mpd.IsActive
,'N'
--,mbb.BucketBalanceId, Up.UserPlanDetailsId, mbp.MemberPLanBucketId,ISNULL(mbb.TransactionAmount,0)
,null,null,null,0
from UserLogin u

join Appointment apt on U.userLoginId = apt.UserLoginId
join MemberPlanDetails mpd on mpd.AppointmentId = apt.AppointmentId and mpd.IsActive='Y'
join MemberPlan mp on mpd.MemberPlanId = mp.MemberPlanId
join CorporatePlan cp on cp.corporatePlanId = mpd.CorporatePlanId
join #TempUser userPolicy on userPolicy.MemberPlanId = mp.MemberPlanId
join FacilitiesMaster fm on fm.FacilityId = mpd.FacilityId
where --apt.ClientId=292 and 
(
apt.ScheduleStatus=6  
--for pharmacy closed=delivered=19
OR (apt.AppointmentType='PHM' AND apt.ScheduleStatus=19 )
--this is for fitness only
OR (apt.AppointmentType IN (select * from STRING_SPLIT(@FitnessProcessCode, ',')) and apt.ScheduleStatus=2)
OR ((apt.AppointmentType='RI' or apt.AppointmentType='UIR') AND apt.ScheduleStatus=24 )
)

and cast(apt.CreatedDate as date)  between @Fromdate and @Todate
--and  apt.AppointmentId = 358681
--401523

UNION

Select u.UserloginId,u.CreatedDate,apt.AppointmentId,apt.caseNo,apt.ClientId
--,mpd.MemberPlanDetailsId,mpd.FacilityId
,null,(SELECT top 1 * FROM STRING_SPLIT(mbb.Facilityids, ',')),fm.FacilityGroup
--booking for multiple facilityIds Of a facilityGroup against one appointment booking

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
join #TempUser userPolicy on userPolicy.UserPlanDetailsId = Up.UserPlanDetailsId
join FacilitiesMaster fm on fm.FacilityId =(SELECT top 1 * FROM STRING_SPLIT(mbb.Facilityids, ',')) 
where apt.ClientId=292 
and (apt.ScheduleStatus=6  OR (apt.AppointmentType='PHM' AND apt.ScheduleStatus=19 ))
and cast(apt.CreatedDate as date) between @Fromdate and @Todate


CREATE TABLE #FinalTEMP (countOfAppointmentId bigint,minMemberPlanDetailsId bigint,UserLoginid BigINT, 
                    UserCreatedDate datetime ,AppointmentId bigint,CaseNo VARCHAR(300), ClientId bigint,
                    MemberPlanDetailsId BIGINT, FacilityId Bigint,FacilityGroup VARCHAR(100), 
					corporatePlanType int, AppointmentPlanType VARCHAR(100),Points DECIMAL(18,2), PartialPoints DECIMAL(18,2), 
					IsUtilized VARCHAR(1), IsActive VARCHAR(1),
					IsWithNewPlan VARCHAR(1),MemberBucketBalanceId BIGINT,UserPlanDetailsId BIGINT, 
					MemberPlanBucketId BIGINT,TransactionAmountNewPlan DECIMAL(18,2));


INSERT INTO #FinalTEMP
SELECT distinct groupedtt.countOfAppointmentId, groupedtt.minMemberPlanDetailsId,tt.*
FROM #TEMP tt
INNER JOIN
    (SELECT AppointmentId, count(AppointmentId) as countOfAppointmentId	
	--here we are taking minimum because in case of wallet there is multiple entry against single appointmentId with different facilityid
	--and first created row which contains  
	,MIN(MemberPlanDetailsId) as minMemberPlanDetailsId

    FROM #Temp
    GROUP BY AppointmentId ) groupedtt 
ON tt.AppointmentId = groupedtt.AppointmentId and (tt.MemberPlanDetailsId=groupedtt.minMemberPlanDetailsId or tt.IsWithNewPlan='Y')



SELECT 
AppointmentId 
,'CREDIT' as AppointmentPlanType
,IIF((PakageId<>0 and PakageId IS NOT NULL),PakageId,TestId ) as FacilityId
,ProviderId
INTO #CreditFacilityAppointment
FROM AppointmentDetails 
where AppointmentId IN (SELECT AppointmentId FROM #TEMP WHERE(AppointmentPlanType='CREDIT'));

CREATE TABLE #FinalCreditFacilityAppointment (rowCounOf BIGINT,AppointmentId BIGINT,AppointmentPlanType VARCHAR(100) , FacilityId BIGINT,ProviderId BIGINT, FacilityName VARCHAR(200), FacilityType VARCHAR(200),FacilityGroup VARCHAR(200),AppPrice1Graded DECIMAL(18,2),AgreedRate DECIMAL(18,2))


--I am doing this because i want to remove duplicate data on the basis of count 
INSERT INTO #FinalCreditFacilityAppointment
SELECT COUNT(*) AS rowCounOf,  * ,null,null,null,0,0
FROM  #CreditFacilityAppointment 
GROUP BY AppointmentId,FacilityId,ProviderId ,AppointmentPlanType
--,TestId,PakageId
having COUNT(*)>1


INSERT INTO #FinalCreditFacilityAppointment
SELECT COUNT(*) AS rowCounOf,  * ,null,null,null,0,0
FROM  #CreditFacilityAppointment 
GROUP BY AppointmentId,FacilityId,ProviderId,AppointmentPlanType
--,TestId ,PakageId
having COUNT(*)=1
--and AppointmentId=69272



--HERE WE are joining with facilityMaster for extracting details like FacilityName, FacilityGroup
UPDATE 
#FinalCreditFacilityAppointment
SET #FinalCreditFacilityAppointment.FacilityName = fm.FacilityName,
#FinalCreditFacilityAppointment.FacilityType=fm.FacilityType,
#FinalCreditFacilityAppointment.FacilityGroup = fm.FacilityGroup
FROM FacilitiesMaster fm 
where fm.FacilityId =#FinalCreditFacilityAppointment.FacilityId

--We are seeing price as per facilityId and ProviderId from FacilityRateMaster only for Dignostic
UPDATE 
#FinalCreditFacilityAppointment
SET #FinalCreditFacilityAppointment.AppPrice1Graded = frm.AppPrice1Graded
FROM FacilitiesRateMster frm 
where frm.FacilityId =#FinalCreditFacilityAppointment.FacilityId 
and frm.ProviderId = #FinalCreditFacilityAppointment.ProviderId
and #FinalCreditFacilityAppointment.FacilityGroup='Diagnostics'


--We are seeing price as per facilityId and clintId from HARateMaster for rest of services excuding dignostic
UPDATE 
#FinalCreditFacilityAppointment
SET #FinalCreditFacilityAppointment.AgreedRate = hrm.AgreedRate
FROM HARateMaster hrm 
join #FinalCreditFacilityAppointment fca on fca.FacilityId=hrm.FacilityId
join #FinalTEMP fapt on fapt.AppointmentId=fca.AppointmentId
where  ((hrm.ClientId=fapt.ClientId or hrm.ClientId=0 )) and fca.FacilityGroup <> 'Diagnostics'


--Here we are calculating relized Preimium for every PolicyNo
Update #TempUser set DivideRelizedDays= CAST(RelizedDays as DECIMAL(18,2))/CAST(TotalTennure AS DECIMAL(18,2)) ,PolicyRelizedPreimium =  CAST(RelizedDays as DECIMAL(18,2))/CAST(TotalTennure AS DECIMAL(18,2)) * OPDPaymentAmount  where PolicyRelizedPreimium=0;



--calculating claim for credit against facilitygroup
CREATE TABLE #FacilityGroupClaimForCredit (countOfFacilityGroup bigint,FacilityGroup VARCHAR(200),AppPrice1Graded DECIMAL(18,2),AgreedRate DECIMAL(18,2))
INSERT INTO #FacilityGroupClaimForCredit
SELECT distinct groupedtt.countOfFacilityGroup,tt.FacilityGroup, groupedtt.AppPrice1Graded,groupedtt.AgreedRate
FROM FacilitiesMaster tt
INNER JOIN
    (SELECT  FacilityGroup,count(FacilityGroup) as countOfFacilityGroup	
	,sum(AppPrice1Graded) as AppPrice1Graded, sum(AgreedRate) as AgreedRate
    FROM #FinalCreditFacilityAppointment
    GROUP BY FacilityGroup ) groupedtt 
ON tt.FacilityGroup = groupedtt.FacilityGroup ;


--calculating claim for wallet against facilitygroup
CREATE TABLE #FacilityGroupClaimForWallet (countOfFacilityGroup bigint,FacilityGroup VARCHAR(200),Points DECIMAL(18,2),PartialPoints DECIMAL(18,2),TransactionAmountNewPlan DECIMAL(18,2))
INSERT INTO #FacilityGroupClaimForWallet
SELECT distinct groupedtt.countOfFacilityGroup,tt.FacilityGroup, groupedtt.Points,groupedtt.PartialPoints,groupedtt.TransactionAmountNewPlan
FROM FacilitiesMaster tt
INNER JOIN
    (SELECT  FacilityGroup,count(FacilityGroup) as countOfFacilityGroup	
	,AppointmentPlanType 
	,sum(Points) as Points
	,sum(PartialPoints) as PartialPoints
	,sum(TransactionAmountNewPlan) as TransactionAmountNewPlan

    FROM #FinalTEMP
    GROUP BY FacilityGroup,AppointmentPlanType ) groupedtt 
ON groupedtt.AppointmentPlanType='WALLET' and   tt.FacilityGroup = groupedtt.FacilityGroup;
 



DECLARE @TotalPremimumAmount DECIMAL(18,2)= (SELECT ISNULL(SUM(OPDPaymentAmount),0) FROM #TempUser 
--where PolicyNo in('OPD-HAOPDR00U43-30390','OPD-HAOPDR00U43-30391')
);

DECLARE @TotalSumOfCreditOfAggredRate DECIMAL(18,2) = (SELECT ISNULL(SUM(AgreedRate),0) from #FinalCreditFacilityAppointment );

DECLARE @TotalSumOfCreditOfAppPriceGraded1 DECIMAL(18,2) = (SELECT ISNULL(SUM(AppPrice1Graded),0) from #FinalCreditFacilityAppointment );

DECLARE @TotalSumOfCredit DECIMAL(18,2)  =  @TotalSumOfCreditOfAggredRate + @TotalSumOfCreditOfAppPriceGraded1;

DECLARE @TotalSumOfPartialPointsOLD_PLAN DECIMAL(18,2) = (SELECT ISNULL(SUM(PartialPoints),0) from #FinalTEMP WHERE AppointmentPlanType='WALLET' );

DECLARE @TotalSumOfPointsOLD_PLAN DECIMAL(18,2) = (SELECT ISNULL(SUM(Points),0) from #FinalTEMP WHERE AppointmentPlanType='WALLET' );

DECLARE @TotalWalletAmountForNewPlan DECIMAL(18,2) =(SELECT ISNULL(SUM(TransactionAmountNewPlan),0) from #FinalTEMP WHERE AppointmentPlanType='WALLET' );

DECLARE @TotalRelizedPreimium DECIMAL(18,2)  = (SELECT ISNULL(SUM(PolicyRelizedPreimium),0) FROM #TempUser);

DECLARE @TotalWallet DECIMAL(18,2) = @TotalWalletAmountForNewPlan+@TotalSumOfPointsOLD_PLAN

DECLARE @TotalClaim DECIMAL(18,2) = ISNULL( @TotalWallet,0) + @TotalSumOfCredit;

DECLARE @LossRatioOnRelizedPremimum DECIMAL(18,4) ;

DECLARE @LossRatioOnTotalPremimum DECIMAL(18,4);

Begin Transaction TRA
  Begin Try
    SET @LossRatioOnRelizedPremimum = CAST(@TotalClaim AS DECIMAL(18,2))/CAST(@TotalRelizedPreimium AS DECIMAL(18,2)) ;
	SET @LossRatioOnTotalPremimum = CAST(@TotalClaim AS DECIMAL(18,2))/CAST(@TotalPremimumAmount AS DECIMAL(18,2)) 
  End Try
  Begin catch
    SET @LossRatioOnRelizedPremimum =0 ;
	SET @LossRatioOnTotalPremimum  = 0;
    If @@trancount>0
    Select ERROR_NUMBER() Error, ERROR_MESSAGE() Message,'FALSE' AS Status;
  End Catch
Commit

SELECT @TotalPremimumAmount AS TotalPremimumAmount
,@TotalClaim as TotalClaim
,@TotalRelizedPreimium as TotalRelizedPreimium
,@LossRatioOnRelizedPremimum as LossRatioOnRelizedPremimum 
,@LossRatioOnTotalPremimum as LossRatioOnNetPremimum
,CAST(@LossRatioOnRelizedPremimum*100 AS DECIMAL(18,2)) as LossRatioPercentageOnRelizedPremimum
,CAST(@LossRatioOnTotalPremimum*100 AS DECIMAL(18,2)) as LossRatioPercentageOnTotalPremimum
,@TotalSumOfCredit as TotalSumOfCredit 

,@TotalWallet as TotalWallet
,@TotalSumOfPartialPointsOLD_PLAN as TotalSumOfPartialPointsOLD_PLAN
,@TotalSumOfPointsOLD_PLAN as TotalSumOfPointsOLD_PLAN
,@TotalWalletAmountForNewPlan as TotalWalletAmountForNewPlan
,'Successfull !' Message,'TRUE' AS Status;

 
SELECT ISNULL(fgc.FacilityGroup,fgw.FacilityGroup) as FacilityGroup
,fgc.AppPrice1Graded
,fgc.AgreedRate
,fgw.Points
,fgw.PartialPoints
,fgw.TransactionAmountNewPlan

,(ISNULL(fgc.AppPrice1Graded,0)
+ ISNULL(fgc.AgreedRate,0)
+ ISNULL(fgw.Points,0)
+ISNULL(fgw.TransactionAmountNewPlan,0)) as NetClaimOnFacilityGroup

FROM #FacilityGroupClaimForCredit fgc
full join #FacilityGroupClaimForWallet fgw on fgw.FacilityGroup = fgc.FacilityGroup
order by NetClaimOnFacilityGroup desc


--SELECT * FROM #FacilityGroupClaimForCredit
--SELECT * FROM #FinalCreditFacilityAppointment 
SELECT * FROM #TempUser;

--SELECT * FROM #FinalTEMP
--SELECT * FROM #FacilityGroupClaimForWallet


--SELECT * FROM #FinalCreditFacilityAppointment

--SELECT * FROM #TEMP



DROP TABLE #FacilityGroupClaimForWallet
DROP TABLE #FacilityGroupClaimForCredit
DROP TABLE #FinalCreditFacilityAppointment
DROP TABLE #CreditFacilityAppointment
DROP TABLE #FinalTEMP
DROP TABLE #TEMP
DROP TABLE #TempUser




END
