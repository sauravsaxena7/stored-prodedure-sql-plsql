USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[opsUspOPDPartnerListByClientid]    Script Date: 2/9/2024 11:51:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[opsUspOPDPartnerListByClientid]
@clientIds varchar(500),
@PlanIds VARCHAR(500)
As
Begin
Select OP.OPDPartnerDetailsId,OP.PartnerName 
from OPDPartnerDetails OP 
join CorporatePlan CP ON CP.CorporatePlanId=OP.PlanId
join Client C on C.ClientId=CP.ClientId
where OP.IsActive = 'Y' 
and CP.IsActive='Y'
and C.ClientId in (select * from SplitString(@clientIds,',')) 
and CP.CorporatePlanId in (select * from SplitString(@PlanIds,',')) 
UNION
Select OP.OPDPartnerDetailsId,OP.PartnerName 
from OPDPartnerDetails OP 
join CNPlanDetails CN ON CN.CNPlanDetailsId=OP.CNPlanDetailsId
join Client C on C.ClientId=CN.ClientId
where OP.IsActive = 'Y' 
and CN.ActiveStatus='Y'
and C.ClientId in (select * from SplitString(@clientIds,',')) 
and CN.CNPlanDetailsId in (select * from SplitString(@PlanIds,',')) 
END