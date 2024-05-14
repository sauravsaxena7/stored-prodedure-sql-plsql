
DECLARE @PartnerCode varchar(100)='ELITEDAPL01',
	@fromdate varchar(100) = '2024-03-1',
	@todate varchar(100)='2024-03-31';

select pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST,
pd.Amount as TotalAmountwithoutGST,pd.PlanCode,(select max(CreatedDate) from MemberCallLog where MemCallId=mcd.MemCallId and CallStatusId in (25,26,27)) as UpdatedDate, 
pd.CreatedDate,
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
  --where pd.policyNo='OPD-HAOPDR00U43-57051' and opd.PartnerCode='ELITEDAPL01'

  where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )
   and (@fromDate is null and @toDate is null OR cast (pd.CreatedDate as date )Between  cast (@fromDate as date ) and cast (@toDate as date ))
  
  And pd.PolicyNo='OPD-HAOPDR00U43-57051';

select * from OPDPartnerDetails where OPDPartnerDetailsId=64

--'ELITEDAPL01','2024-03-1','2024-03-31'


select distinct pd.TransactionId as ApplicationNumber, pd.PolicyNo, pd.TotalAmount as TotalAmountwithGST, pd.Amount as TotalAmountwithoutGST ,
--isnull(mcd.UpdatedDate, mcd.CreatedDate) as UpdatedDate, 
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
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',') )  and pd.CreatedDate>= cast(@fromdate as date) and pd.CreatedDate<= cast(@todate as date) And pd.PolicyNo='OPD-HAOPDR00U43-57051';