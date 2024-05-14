USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[opsUspPlanListByClientList]    Script Date: 1/10/2024 12:07:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[opsUspPlanListByClientList]
@clientIds varchar(100)
As
Begin
Select corporatePlanId,planName from CorporatePlan where isActive = 'Y' and ClientId in (select * from SplitString(@clientIds,',')) 
UNION ALL
Select CNPlanDetailsId as corporatePlanId,planName from CNPlanDetails where ActiveStatus = 'Y' and ClientId in (select * from SplitString(@clientIds,',')) 
End