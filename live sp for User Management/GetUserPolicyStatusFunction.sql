USE [HaProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 12/13/2023 2:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GetUserPolicyStatusFunction] (@userloginId varchar(50),@PolicyNo varchar(200),@IsWithNewPlan VARCHAR(1)='N') 
RETURNS VARCHAR(2) as
BEGIN     
 Declare @MemberPlanId bigint ;
Declare @MemberId bigint;

DECLARE @CorporatePlanId BIGINT
DECLARE @PlanCode VARCHAR
DECLARE @ClientId BIGINT
DECLARE @IsActiveMemberPlan VARCHAR(2)


IF ISNUMERIC(@userloginId)=1 AND @PolicyNo IS NOT NULL AND @PolicyNo <> '' AND @IsWithNewPlan='N'
      BEGIN
	 
	     --using PolicyNo and userloginid we are trying to find MemberplanId [HAPPY CASE]
         select @MemberPlanId = MemberPlanId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;
		 IF @MemberPlanId IS NULL
		    BEGIN
			    select @MemberPlanId=mp.MemberPlanId from LibertyEmpRegistration  r 
			 join Member m on r.HAMemberId=m.MemberId join MemberPlan mp on m.MemberId=mp.MemberId
             join CorporatePlan p on p.CorporatePlanId=mp.CorporatePlanId 
			 and p.PlanCode=r.PlanCode 
			 and p.ClientId=r.ClientId   
             and cast(FORMAT(r.CreatedDate,'yyyy-MM-dd HH:mm:ss') as datetime)=cast(FORMAT(mp.createddate,'yyyy-MM-dd HH:mm:ss') as datetime) 
			 and ISNULL(r.MemberPlanId,0)=0 and r.PolicyNo=@PolicyNo and r.UserLoginId=FLOOR(@userloginId);;
			END
			SELECT @IsActiveMemberPlan=IsActive from MemberPlan WHERE MemberPlanId=@MemberPlanId;
      END
ELSE IF ISNUMERIC(@userloginId)=1 AND @PolicyNo IS NOT NULL AND @PolicyNo <> '' AND @IsWithNewPlan='Y'
BEGIN
   SELECT @MemberPlanId=UserPlanDetailsId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;

   SELECT @IsActiveMemberPlan=ActiveStatus from UserPlanDetails WHERE UserPlanDetailsId=@MemberPlanId;

END
  RETURN ISNULL(@IsActiveMemberPlan,'N')
END 
