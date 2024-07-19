USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetMISReportClientDashboard]    Script Date: 7/2/2024 12:55:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Narendra>
-- Create date: <05 April 2024>
-- Description:	<Description,,>

-- exec [usp_GetMISReportClientDashboard] 'ALL,ELITE0011,ELITE0012,ELITE0013,ELITE0014,ELITE0015,ELITEASIAN01,ELITEBALAJI08,ELITECLIQ19,ELITEDAPL01,ELITEDIAGNO13,ELITEDIAGNO26,ELITEDPTRADE21,ELITEFINATRIK18,ELITEINDIA10,ELITEINFINITY28,ELITEINFOCOM01,ELITEIPTM25,ELITEMANAWA04,ELITEMAXI10,ELITEMMM23,ELITEMVISION22,ELITEONE07,ELITEPowerz24,ELITERAHI01,ELITERAP20,ELITEREFER27,ELITEREVBAY17,ELITERP06,ELITESHREE09,ELITESPUR02,ELITETRONO14,ELITEVIIBGYOR16,ELITEWAY03,OMSHREE15','2024-04-01','2024-05-15'
-- =============================================
ALTER PROCEDURE [dbo].[usp_GetMISReportClientDashboard]
	@PartnerCode varchar(max)=null,
	@fromdate varchar(100) =null,
	@todate varchar(100)=null,
	@UserType varchar(100)=null
AS
BEGIN
create table #Temp(ApplicationNumber VARCHAR(300),PolicyNo varchar(300),
TotalAmountwithGST varchar(300),TotalAmountwithoutGST varchar(300),CreatedDate datetime,
UpdatedDate datetime,Status varchar(400),WelcomeCallingStatus varchar(300),
PlanName varchar(300),PartnerName varchar(300),
PartnerCode VARCHAR(200),PartnerCreationDate datetime,
PolicyStatus varchar(100), PolicyCreatedDate datetime,
PolicyLastUpdatedDate datetime,RazorPayPaymentStatus Varchar(100),
RazorPayLastPaymentStatusDate varchar(100),ProposalLastUpdatedDate datetime)


IF(@PartnerCode is null)
BEGIN
Set @PartnerCode='All'
END
IF(@PartnerCode='All')
BEGIN

INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
ISNULL((select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)),pd.CreatedDate) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName,opd.PartnerCode,opd.CreatedDate,
IIF(mp.isActive='Y','ACTIVE',IIF(pd.Status='Requested','REQUESTED','CANCELLED')),
mp.CreatedDate,
mp.UpdatedDate,
ISNULL((SELECT top 1 status from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),''),
(SELECT top 1 CreatedDate from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),
pd.UpdatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
left join Member m on m.MemberId=lb.HAMemberId 
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode;

--where  pd.PolicyNo='OPD-HAOPDR00U43-57051';
END
ELSE
BEGIN
--select pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate, 
--(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
--(case when mcl.CallStatusId=24 then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
--ISNULL(cp.PlanName,cn.PlanName) as PlanName
--from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join CallStatus cs on cs.CallStatusId=mcl.StatusId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--left join corporateplan cp on cp.PlanCode=lb.PlanCode
--left join CNPlanDetails cn on cn.PlanCode=lb.PlanCode
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )  and pd.CreatedDate>= cast(@fromdate as date) and pd.CreatedDate<= cast(@todate as date)
IF(@UserType='All')
BEGIN
INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
ISNULL((select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)),pd.CreatedDate) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName,opd.PartnerCode,opd.CreatedDate,
IIF(mp.isActive='Y','ACTIVE',IIF(pd.Status='Requested','REQUESTED','CANCELLED')),
mp.CreatedDate,
mp.UpdatedDate,
ISNULL((SELECT top 1 status from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),''),
(SELECT top 1 CreatedDate from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),
pd.UpdatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
left join Member m on m.MemberId=lb.HAMemberId 
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
   and (@fromDate is null and @toDate is null OR cast (pd.UpdatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ));

END
ELSE IF(@UserType='cancelledPolicy')
BEGIN
INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
ISNULL((select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)),pd.CreatedDate) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName,opd.PartnerCode,opd.CreatedDate,
IIF(mp.isActive='Y','ACTIVE',IIF(pd.Status='Requested','REQUESTED','CANCELLED')),
mp.CreatedDate,
mp.UpdatedDate,
ISNULL((SELECT top 1 status from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),''),
(SELECT top 1 CreatedDate from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),
pd.UpdatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
left join Member m on m.MemberId=lb.HAMemberId 
left join UserPlanDetails upd on upd.MemberId=m.MemberId
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
and (@fromDate is null and @toDate is null OR cast (pd.UpdatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ))
and (pd.status in ('Success') and ISNULL(mp.IsActive,'N')='N') and (pd.status in ('Success') and ISNULL(upd.ActiveStatus,'N')='N');

END

ELSE IF(@UserType='successPolicy')
BEGIN
INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
ISNULL((select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)),pd.CreatedDate) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName,opd.PartnerCode,opd.CreatedDate,
IIF(mp.isActive='Y','ACTIVE',IIF(pd.Status='Requested','REQUESTED','CANCELLED')),
mp.CreatedDate,
mp.UpdatedDate,
ISNULL((SELECT top 1 status from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),''),
(SELECT top 1 CreatedDate from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),
pd.UpdatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
left join Member m on m.MemberId=lb.HAMemberId 
left join UserPlanDetails upd on upd.MemberId=m.MemberId
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
and (@fromDate is null and @toDate is null OR cast (pd.UpdatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ))
and (status in ('Success') and ISNULL(mp.IsActive,'')<>'N' and mp.IsActive is not null) and (status in ('Success') and ISNULL(upd.ActiveStatus,'')<>'N' );

END

ELSE IF(@UserType='requestedPolicy')
BEGIN
INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
ISNULL((select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)),pd.CreatedDate) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName,opd.PartnerCode,opd.CreatedDate,
IIF(mp.isActive='Y','ACTIVE',IIF(pd.Status='Requested','REQUESTED','CANCELLED')),
mp.CreatedDate,
mp.UpdatedDate,
ISNULL((SELECT top 1 status from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),''),
(SELECT top 1 CreatedDate from PaymentGatewayApiLogs where TransactionId=pd.TransactionId order by CreatedDate desc),
pd.UpdatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
left join Member m on m.MemberId=lb.HAMemberId 
left join UserPlanDetails upd on upd.MemberId=m.MemberId
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
and (@fromDate is null and @toDate is null OR cast (pd.UpdatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ))
and (pd.Status='Requested');

END
END


SELECT distinct groupedtt.countOfApplication,tt.*
FROM #Temp tt
INNER JOIN
    (SELECT ApplicationNumber, count(ApplicationNumber) as countOfApplication,MAX(UpdatedDate) AS MaxDateTime,count(UpdatedDate) as countUpdatedtime
    FROM #Temp
    GROUP BY ApplicationNumber) groupedtt 
ON tt.ApplicationNumber = groupedtt.ApplicationNumber 
AND (( groupedtt.countOfApplication=1 and tt.UpdatedDate is null)
or (tt.UpdatedDate = groupedtt.MaxDateTime and tt.UpdatedDate is not null)) 
and ((groupedtt.countOfApplication>1 and tt.WelcomeCallingStatus='Welcome Calling Done') or (groupedtt.countOfApplication=1))




END
