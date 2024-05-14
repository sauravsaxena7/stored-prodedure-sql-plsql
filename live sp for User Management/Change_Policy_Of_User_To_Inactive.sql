USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Change_Status_Of_User_To_Inactive]    Script Date: 12/6/2023 12:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[Change_Policy_Of_User_To_Inactive] '523288.0','Admin','Inactive by Raja','HA00-230206114924'
ALTER PROCEDURE [dbo].[Change_Policy_Of_User_To_Inactive] 
@userloginId varchar(50),
@AdminName Varchar(50),
@Remarks varchar(200),
@PolicyNo varchar(200)
As
begin
Declare @Success varchar(10);
Declare @col varchar(50);
Declare @code int;
Declare @Message varchar(100);
Declare @status varchar(50)=null;
DECLARE @clientId BIGINT;
Declare @MemberPlanId bigint ;
DECLARE @IsActiveMemberPlan VARCHAR(10);




IF ISNUMERIC(@userloginId)=1 AND @PolicyNo IS NOT NULL AND @PolicyNo <> ''
      BEGIN
	 
	     --using PolicyNo and userloginid we are trying to find MemberplanId [HAPPY CASE]
         select @MemberPlanId = MemberPlanId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;

		 select @clientId = ClientId from LibertyEmpRegistration where UserLoginId=FLOOR(@userloginId) and PolicyNo=@PolicyNo;
		 print @clientId;
		 print'lola'

		 IF @MemberPlanId IS NULL
		    BEGIN
			 select @MemberPlanId=mp.MemberPlanId from LibertyEmpRegistration  r 
			 join Member m on r.HAMemberId=m.MemberId join MemberPlan mp on m.MemberId=mp.MemberId
             join CorporatePlan p on p.CorporatePlanId=mp.CorporatePlanId 
			 and p.PlanCode=r.PlanCode 
			 and p.ClientId=r.ClientId   
             and cast(FORMAT(r.CreatedDate,'yyyy-MM-dd HH:mm:ss') as datetime)=cast(FORMAT(mp.createddate,'yyyy-MM-dd HH:mm:ss') as datetime) 
			 and ISNULL(r.MemberPlanId,0)=0 and r.PolicyNo=@PolicyNo and r.UserLoginId=FLOOR(@userloginId);
			    
			END	
			SELECT @IsActiveMemberPlan=IsActive from MemberPlan WHERE MemberPlanId=@MemberPlanId;
      END

IF @MemberPlanId IS NULL OR @IsActiveMemberPlan IS NULL
   BEGIN
      SET @Success='FALSE';
	  SET @code=400;
      SET @col='UserloginId,PolicyNo';
	  SET @Message='MemberPlan not found for corresponding UserLoginId and PolicyNo.'
   END
ELSE IF @IsActiveMemberPlan='N'
      BEGIN
	     SET @Success='FALSE';
	     SET @code=200;
	     SET @col='UserloginId,PolicyNo';
	     SET @Message='PolicyNo:- '+@PolicyNo+' already in in-active mode.' 
	  END
ELSE
   BEGIN
      SET @col='Using MemberPlanId';
	  UPDATE MemberPlan SET IsActive='N' WHERE MemberPlanId=@MemberPlanId;
	  UPDATE LibertyEmpRegistration SET PolicyInActiveByAdminName=@AdminName WHERE MemberPlanId=@MemberPlanId;
	  UPDATE LibertyEmpRegistration SET PolicyInActiveRemarks=@Remarks WHERE MemberPlanId=@MemberPlanId;
	  UPDATE LibertyEmpRegistration SET PolicyInActiveDatetime=GETDATE() WHERE MemberPlanId=@MemberPlanId;
	  SET @Success='TRUE';
	  SET @code=200;
	  SET @Message='PolicyNo:- '+@PolicyNo+' Successfully De-activated.'

   END

DECLARE @clientName varchar(200);
DECLARE  @EmpNo varchar(100);
DECLARE  @UserStatus varchar(100);
SELECT @EmpNo = ISNULL(EmpNo,'') from UserLogin where UserLoginId=FLOOR(@userloginId);
SELECT @clientName = ISNULL(ClientName,'') from Client where clientId=@clientId;
SELECT @UserStatus = CASE WHEN(Status = 'A') THEN 'Active'
                       WHEN(Status = 'I') THEN 'Inactive'
	                   WHEN(Status = 'L') THEN 'Locked'
	                   WHEN(Status = 'T') THEN 'Temporary'
	                   ELSE 'Inactive'
                       END  from UserLogin where UserLoginId=FLOOR(@userloginId);




SELECT @col AS columnNme, @code AS StatusCode, @Success AS Success, @Message AS Message,
ISNULL(@Remarks,'') As Remarks ,ISNULL(@EmpNo,'') AS EmpNo, ISNULL(@clientId,-1) AS ClientId,ISNULL(@clientName,'Not Found') AS ClientName,ISNULL(FLOOR(@userloginId),-1) AS UserloginId, ISNULL(@PolicyNo,'') As PolicyNo,ISNULL(@UserStatus,'') AS UserStatus;
END