USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UnblockUser]    Script Date: 11/28/2023 7:28:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[UnblockUser] '520817',1
ALTER PROCEDURE [dbo].[UnblockUser] 
@userloginId varchar(50),
@UnblockByAdminId BigInt

As
begin
Declare @Success varchar(10);
Declare @code int;
Declare @Message varchar(100);
Declare @status varchar(50);
select @status=status from userlogin where UserLoginId=@userloginId;

IF (SELECT top 1 name FROM [HAModuleUAT].[ops].[Admin] where id=@UnblockByAdminId) is null
   BEGIN
      SET @Success='FALSE';
	  SET @code=400;
	  SET @Message='Admin is not valid.';
   END
ELSE IF @status IS  NULL
      BEGIN
	     SET @Success='FALSE';
	     SET @code=400;
	     SET @Message='Invalid User Account.';
      END
ELSE IF @status IS NOT NULL AND  @status NOT IN('L','I')
      BEGIN
	     SET @Success='FALSE';
	     SET @code=400;
	     SET @Message='User Account is already in unblocked mode.';
      END
ELSE IF @status='L'
      BEGIN
         update userlogin set Status ='A' where UserLoginId=@userloginId
         update userlogin set LoginAttempt= 0 where UserLoginId=@userloginId

         --ADDED BY SAURAV SUMAN
         update userlogin set UnblockByAdminId= @UnblockByAdminId where UserLoginId=@userloginId
         ---END 
		 update userlogin set LoginAttempt= 0 where UserLoginId=@userloginId
		 SET @Success='TRUE';
	     SET @code=200;
	     SET @Message='User Unblocked Successfully.';
      END
ELSE IF @status='I'
      BEGIN
         update userlogin set Status='A' where UserLoginId=@userloginId
         --ADDED BY SAURAV SUMAN
         update userlogin set UnblockByAdminId= @UnblockByAdminId where UserLoginId=@userloginId
         ---END
		 SET @Success='TRUE';
	     SET @code=200;
	     SET @Message='User Unblocked Successfully.';

      END
SELECT @code AS StatusCode, @Success AS Success, @Message AS Message;
END