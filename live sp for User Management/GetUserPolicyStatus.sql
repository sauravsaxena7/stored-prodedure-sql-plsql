USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Change_Status_Of_User_To_Inactive]    Script Date: 12/6/2023 12:09:45 PM ******/
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


IF ISNUMERIC(@userloginId)=1 AND @PolicyNo IS NOT NULL AND @PolicyNo <> ''
      BEGIN
	 
	     --using PolicyNo and userloginid we are trying to find MemberplanId [HAPPY CASE]
         select @MemberPlanId = MemberPlanId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;
		 IF @MemberPlanId IS NOT NULL
		    BEGIN
			   SELECT TOP 1 @IsActiveMemberPlan = ISNULL(IsActive,'N') from MemberPlan WHERE MemberPlanId=@MemberPlanId;

			   SELECT TOP 1  @PolicyInActiveByAdminName = ISNULL(PolicyInActiveByAdminName,'') from MemberPlan WHERE MemberPlanId=@MemberPlanId;

			   SELECT TOP 1  @PolicyInActiveRemarks = ISNULL(PolicyInActiveRemarks,'') from MemberPlan WHERE MemberPlanId=@MemberPlanId;

			   SELECT TOP 1  @PolicyInActiveDatetime = ISNULL(PolicyInActiveDatetime,CAST('1900-01-01 17:00:00.597' AS datetime)) from MemberPlan WHERE MemberPlanId=@MemberPlanId;
			END
		 ELSE
		    BEGIN
			    select @ClientId = ClientId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;
		        select @PlanCode = PlanCode from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;
				
                --But IF memberplan id is null we are trying to find memberid of self
		        SELECT @CorporatePlanId =  CorporatePlanId from CorporatePlan where Plancode=@PlanCode and clientId=@ClientId;
                select @MemberId= MemberId from member where userloginid=FLOOR(@userloginId) and relation='Self'
				

				--finally wee need to find exact memberplan entry for corresponding policyNo using CorporateplanId and memberid
			    SELECT TOP 1 @IsActiveMemberPlan = ISNULL(IsActive,'N') from MemberPlan WHERE MemberId=@MemberId AND CorporatePlanId=@CorporatePlanId;

				 SELECT TOP 1  @PolicyInActiveByAdminName = ISNULL(PolicyInActiveByAdminName,'') from MemberPlan WHERE MemberId=@MemberId AND CorporatePlanId=@CorporatePlanId;

			   SELECT TOP 1  @PolicyInActiveRemarks = ISNULL(PolicyInActiveRemarks,'') from MemberPlan WHERE MemberId=@MemberId AND CorporatePlanId=@CorporatePlanId;

			   SELECT TOP 1  @PolicyInActiveDatetime = ISNULL(PolicyInActiveDatetime,CAST('1900-01-01 17:00:00.597' AS datetime)) from MemberPlan WHERE MemberId=@MemberId AND CorporatePlanId=@CorporatePlanId;
				
			END
			
      END
	  SELECT  @IsActiveMemberPlan AS PolicyStatus ,@PolicyInActiveByAdminName AS PolicyInActiveByAdminName, @PolicyInActiveRemarks AS PolicyInActiveRemarks, @PolicyInActiveDatetime AS PolicyInActiveDatetime;
END