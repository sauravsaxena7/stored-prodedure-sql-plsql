USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[opsUspPlanListByClientList]    Script Date: 1/30/2024 10:04:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[opsUspPlanListByClientList]
@clientIds varchar(100)
As
Begin
Select corporatePlanId,planName from CorporatePlan where isActive = 'Y' and ClientId in (select * from SplitString(@clientIds,',')) 
UNION 
Select  CNPlanDetailsId as corporatePlanId,planName  from CNPlanDetails where ActiveStatus = 'Y' and ClientId in (select * from SplitString(@clientIds,',')) 
End