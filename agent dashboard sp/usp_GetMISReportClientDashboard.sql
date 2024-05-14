USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetMISReportClientDashboard]    Script Date: 4/22/2024 3:37:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Narendra>
-- Create date: <05 April 2024>
-- Description:	<Description,,>

-- exec [usp_GetMISReportClientDashboard] 'ELITEDAPL01','2024-03-1','2024-03-31'
-- =============================================
ALTER PROCEDURE [dbo].[usp_GetMISReportClientDashboard]
	@PartnerCode varchar(100),
	@fromdate varchar(100) =null,
	@todate varchar(100)=null,
	@UserType varchar(100)=null
AS
BEGIN
create table #Temp(ApplicationNumber VARCHAR(300),PolicyNo varchar(300),TotalAmountwithGST varchar(300),TotalAmountwithoutGST varchar(300),CreatedDate datetime,UpdatedDate datetime,Status varchar(400),WelcomeCallingStatus varchar(300),
PlanName varchar(300),PartnerName varchar(300))


IF(@PartnerCode='All')
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


INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
(select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
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

INSERT INTO #Temp
select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate,
pd.createdDate,
(select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)) as UpdatedDate, 
(case when pd.Status='Success' then 'Issued' when (pd.Status='Failure' or pd.Status='Failed') then 'Cancelled' when pd.Status='Requested' then 'Requested' end ) as Status, 
(case when mcl.CallStatusId in (25,26,27) then 'Welcome Calling Done' else 'Welcome Calling Pending'  end ) as WelcomeCallingStatus,
ISNULL(cp.PlanName,cn.PlanName) as PlanName,opd.PartnerName as PartnerName
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar(100))=cast(pd.PartnerOrderId as varchar(100))
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join Member m on m.MemberId=lb.HAMemberId 
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
left join corporateplan cp on cp.PlanCode=pd.PlanCode
left join CNPlanDetails cn on cn.PlanCode=pd.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
   and (@fromDate is null and @toDate is null OR cast (pd.CreatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ));

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
