print cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date)
--(select CallStatusid from MemberCallLog where MemCallId= mcd.MemCallId) not in (25,26,27)
select * from Callstatus
select * from MemberCallLog where CallStatusid in (36,43)

CREATE table #callpendingTemp(CallPending bigint,PolicyNo varchar(200))
INSERT INTO #callpendingTemp
select  distinct  count(pd.OPDPaymentDetailsId) as CallPending,(pd.PolicyNo) -- count(distinct pd.OPDPaymentDetailsId) as CallPending,pd.
--,mcl.CallStatusid
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join Member m on m.MemberId=lb.HAMemberId 
--left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
--left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 

where pd.Status='Success' and opd.PartnerCode='ELITEDAPL01'-- and pd.policyNo='OPD-HAOPDR00U41-57620'
--and( mcl.CallStatusid is null or mcl.CallStatusid not in (27,26,25))
 AND cast (pd.CreatedDate as date ) Between  cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date) and cast(GETDATE() as DATE) 
 and (((select top 1 MemCallId from MemberCallDetails where  MemberId=m.MemberId) is null) or( (select top 1 CallStatusid from MemberCallLog where MemCallId in (select top 1 MemCallId from MemberCallDetails where  MemberId=m.MemberId order by 1 desc ) order by 1 desc) not in (25,26,27)))
 group by pd.PolicyNo;--,mcl.CallStatusid

 select *  FROM #callpendingTemp
 DROP TABLE #callpendingTemp
 

 select count(distinct pd.OPDPaymentDetailsId) as PaymentDone 
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
where pd.Status in ('success') and opd.PartnerCode='ELITEDAPL01'
AND cast (pd.CreatedDate as date ) Between  cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date) and cast(GETDATE() as DATE) 

 select PartnerOrderId,* from OPDPaymentDetails where policyNo='OPD-HAOPDR00U41-57808'
 SELECT * FROM OPDPartnerDetails where PartnerCode='ELITEDAPL01'

 select * from LibertyEmpRegistration where policyNo in ('OPD-HAOPDR00U41-57227','OPD-HAOPDR00U43-57743')
 --,3802461
 select  * from MemberCallDetails where  MemberId in (3667289 )
 select top 1 * from MemberCallLog  where  MemCallId in (54560,54599) order by 1 desc 

 SELECT * FROM UserLogin order by 1 desc