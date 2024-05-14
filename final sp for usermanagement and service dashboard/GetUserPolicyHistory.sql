USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[GetUserPolicyHistory]    Script Date: 12/18/2023 1:50:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[GetUserPolicyStatus] 
--[GetUserPolicyHistory] '524648','HAOP-23092013421148'
ALTER PROCEDURE [dbo].[GetUserPolicyHistory] 
@userloginId varchar(50),
@PolicyNo varchar(200)
As
begin
Declare @MemberPlanId bigint ;
Declare @MemberId bigint;

DECLARE @CorporatePlanId BIGINT;
DECLARE @PlanCode VARCHAR;
DECLARE @ClientId BIGINT;
DECLARE @IsActiveMemberPlan VARCHAR(200);
DECLARE @PolicyInActiveByAdminName VARCHAR(50);
DECLARE @PolicyInActiveRemarks VARCHAR(200);
DECLARE @PolicyInActiveDatetime DATETIME;

	  SELECT  ISNULL(PolicyInActiveByAdminName,'') AS PolicyInActiveByAdminName, ISNULL(PolicyInActiveRemarks,'') AS PolicyInActiveRemarks, ISNULL(PolicyInActiveDatetime,'') AS PolicyInActiveDatetime FROM LibertyEmpRegistration WHERE UserLoginId=@userloginId and PolicyNo=@PolicyNo;
END