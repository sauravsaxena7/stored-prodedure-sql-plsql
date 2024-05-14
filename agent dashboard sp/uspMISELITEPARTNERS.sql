USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspMISELITEPARTNERS]    Script Date: 4/23/2024 3:03:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Narendra>
-- Create date: <02-04-2024>
-- Description:	<MIS data for ELITE Partners>
-- exec [uspMISELITEPARTNERS] 'ELITEDAPL01'
-- =============================================
ALTER PROCEDURE [dbo].[uspMISELITEPARTNERS] 
	@PartnerCode varchar(100)
AS
BEGIN
	------------Payment Done----------------------------------
--select count( distinct mcd.MemCallId) as PaymentDone
--from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode
--and mcd.CreatedDate>CAST( GETDATE() AS Date ) --order by mcd.MemCallId desc

select count(distinct pd.OPDPaymentDetailsId) as PaymentDone 
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
where pd.Status in ('success') and opd.PartnerCode=@PartnerCode
and pd.CreatedDate>=CAST( GETDATE() AS Date )
---------------------------------------------------------------

-----------Payment InCompleted---------------------------------
--select count(distinct mcd.MemCallId) as PaymentPending from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid in (27,26,25) and pd.Status in ('Requested','Pending') and opd.PartnerCode=@PartnerCode
--and mcd.CreatedDate>CAST( GETDATE() AS Date ) --order by mcd.MemCallId desc

select count(distinct pd.OPDPaymentDetailsId) as PaymentPending 
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
where pd.Status in ('Requested') and opd.PartnerCode=@PartnerCode
and pd.CreatedDate>=CAST( GETDATE() AS Date )
----------------------------------------------------------------

------------------Policies Issued But Welcome calling Pending--------------------
--select count(distinct mcd.MemCallId) as CallPending
--from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid not in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode 
--and mcd.CreatedDate>CAST( GETDATE() AS Date ) --and bm.Type='EMAIL' 
----and mcd.CreatedDate>cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date)
----and bm.RefrenceId is null order by mcd.MemCallId desc

--select count(distinct pd.OPDPaymentDetailsId) as CallPending
--from OPDPaymentDetails pd
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
--left join Member m on m.MemberId=lb.HAMemberId 
--left join MemberCallDetails mcd on mcd.MemberId=m.MemberId
--left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--where mcl.CallStatusid not in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode 
--and pd.CreatedDate>CAST( GETDATE() AS Date ) --and bm.Type='EMAIL' 
----and mcd.CreatedDate>cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date)
----and bm.RefrenceId is null order by mcd.MemCallId desc

--select count(distinct pd.OPDPaymentDetailsId) as CallPending -- count(distinct pd.OPDPaymentDetailsId) as CallPending
--from OPDPaymentDetails pd
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
--left join Member m on m.MemberId=lb.HAMemberId 
--left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
--left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
--where pd.Status='Success' and opd.PartnerCode=@PartnerCode and mcl.CallStatusid not in (27,26,25)
--and pd.CreatedDate>CAST( GETDATE() AS Date ) 

DECLARE @Logged int
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

where pd.Status='Success' and opd.PartnerCode=@PartnerCode-- and pd.policyNo='OPD-HAOPDR00U41-57620'
--and( mcl.CallStatusid is null or mcl.CallStatusid not in (27,26,25))
 AND cast (pd.CreatedDate as date ) >=CAST( GETDATE() AS Date )  --Between  cast(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AS Date) and cast(GETDATE() as DATE) 
and (((select top 1 MemCallId from MemberCallDetails where  MemberId=m.MemberId) is null) 
or( (select top 1 CallStatusid from MemberCallLog 
where MemCallId in (select top 1 MemCallId from MemberCallDetails where  MemberId=m.MemberId order by 1 desc ) 
order by 1 desc) not in (25,26,27)))
 group by pd.PolicyNo;--,mcl.CallStatusid

 select @Logged=count(*)  FROM #callpendingTemp
 SELECT @Logged as CallPending;
 DROP TABLE #callpendingTemp
-------------------------------------------------------------------------------------

------------------Policies Issued But Welcome calling Done--------------------
--select count(distinct mcd.MemCallId) as CallDone from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode
--and mcd.CreatedDate>CAST( GETDATE() AS Date )  
----order by mcd.MemCallId desc

select count(distinct pd.OPDPaymentDetailsId) as CallDone -- count(distinct pd.OPDPaymentDetailsId) as CallPending
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join Member m on m.MemberId=lb.HAMemberId 
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
where pd.Status='Success' and opd.PartnerCode=@PartnerCode and mcl.CallStatusid in (27,26,25)
and pd.CreatedDate>=CAST( GETDATE() AS Date ) 

-------------------------------------------------------------------------------------

------------------Logged Issued--------------------
--select top 1 0 as LoggedIssued from Appointment
--DECLARE @Logged int
DECLARE @Issued int

--select @Logged=count(distinct mcd.MemCallId) 
--from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid not in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode  and mcd.CreatedDate>CAST( GETDATE() AS Date )


--select @Issued=count(distinct mcd.MemCallId) from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join Member m on m.MemberId=mcd.MemberId
--join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID --and pd.clientid=@ClientId
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where mcl.CallStatusid in (27,26,25) and pd.Status='Success' and opd.PartnerCode=@PartnerCode
--and mcd.CreatedDate>CAST( GETDATE() AS Date )

--select @Logged=count(distinct pd.OPDPaymentDetailsId) 
--from OPDPaymentDetails pd
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
--left join Member m on m.MemberId=lb.HAMemberId 
--left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
--left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
--where pd.Status='Success' and opd.PartnerCode=@PartnerCode and mcl.CallStatusid not in (27,26,25)
--and pd.CreatedDate>CAST( GETDATE() AS Date ) 

select @Issued= count(distinct pd.OPDPaymentDetailsId) 
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join Member m on m.MemberId=lb.HAMemberId 
left join MemberCallDetails mcd on mcd.MemberId=m.MemberId 
left join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId 
where pd.Status='Success' and opd.PartnerCode=@PartnerCode and mcl.CallStatusid in (27,26,25)
and pd.CreatedDate>=CAST( GETDATE() AS Date ) 
select ABS(@Logged-@Issued) as LoggedIssued


-------------------------------------------------------------------------------------


END
