USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Change_Status_Of_User_To_Inactive]    Script Date: 12/6/2023 12:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[Change_Status_Of_User_To_Inactive] '315.0','ll','ll',null
ALTER PROCEDURE [dbo].[Change_Status_Of_User_To_Inactive] 
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

IF ISNUMERIC(@userloginId)=1
      BEGIN
	     SELECT @userloginId=FLOOR(@userloginId);
	     select @status=status from userlogin where UserLoginId=@userloginId;
      END
SELECT @AdminName=TRIM(@AdminName)
SELECT @Remarks=TRIM(@Remarks)
IF @AdminName is null OR @AdminName=''
   BEGIN
      SET @Success='FALSE';
	  SET @code=400;
	  SET @Message='Admin Name is not valid.';
	  SET @col='AdminName';
   END
ELSE IF @Remarks is null OR @Remarks=''
   BEGIN
      SET @Success='FALSE';
	  SET @code=400;
	  SET @Message='Remarks not available.';
	  SET @col='Remarks';
   END
ELSE IF @status IS  NULL
      BEGIN
	     SET @Success='FALSE';
	     SET @code=400;
	     SET @Message='Invalid User Account.';
		 SET @col='UserLoginId';
      END
ELSE IF @status IS NOT NULL AND  @status ='I'
      BEGIN
	     SET @Success='FALSE';
	     SET @code=400;
	     SET @Message='User Account is already in InActive mode.';
		 SET @col='UserLoginId,InActive';
      END
ELSE
      BEGIN
         update userlogin set Status ='I' where UserLoginId=@userloginId
         update userlogin set LoginAttempt= 0 where UserLoginId=@userloginId
		 update userlogin set LastInActiveByAdminName= @AdminName where UserLoginId=@userloginId
		 update userlogin set LastInActiveRemarksByAdmin= @Remarks where UserLoginId=@userloginId
		 update userlogin set LastInActiveDateTime = GETDATE() where UserLoginId=@userloginId
		 SET @Success='TRUE';
	     SET @code=200;
		 DECLARE @ID VARCHAR(50) = CAST(@userloginId as varchar(50));
	     SET @Message='User change to InActive mode successfully.';
		 SET @col='Valid Column';
      END

DECLARE @clientId bigint=-1;
DECLARE @clientName varchar(200);
DECLARE  @EmpNo varchar(100);
DECLARE  @UserStatus varchar(100);
SELECT @clientId = ISNULL(ClientId,-1) from UserLogin where UserLoginId=@userloginId;
SELECT @EmpNo = ISNULL(EmpNo,'') from UserLogin where UserLoginId=@userloginId;
SELECT @clientName = ISNULL(ClientName,'') from Client where clientId=@clientId;
SELECT @UserStatus = CASE WHEN(Status = 'A') THEN 'Active'
                       WHEN(Status = 'I') THEN 'Inactive'
	                   WHEN(Status = 'L') THEN 'Locked'
	                   WHEN(Status = 'T') THEN 'Temporary'
	                   ELSE 'Inactive'
                       END  from UserLogin where UserLoginId=@userloginId;


SELECT @col AS columnNme, @code AS StatusCode, @Success AS Success, @Message AS Message,
ISNULL(@Remarks,'') As Remarks ,ISNULL(@EmpNo,'') AS EmpNo, ISNULL(@clientId,-1) AS ClientId,ISNULL(@clientName,'') AS ClientName,ISNULL(@userloginId,-1) AS UserloginId, ISNULL(@PolicyNo,'') As PolicyNo,ISNULL(@UserStatus,'') AS UserStatus;
END