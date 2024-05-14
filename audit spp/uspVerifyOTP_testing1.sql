USE [HAModule]
GO
/****** Object:  StoredProcedure [ops].[uspVerifyOTP_testing1]    Script Date: 3/18/2024 2:34:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from AuditAcessTable
--CREATE TABLE AuditAcessTable (
--   id int IDENTITY(1,1) PRIMARY KEY,
--    IsDownloadReportFlagForOps INT NOT NULL
    
--);
--INSeRT INTO AuditAcessTable (IsDownloadReportFlagForOps) values (1)
UPDATE AuditAcessTable SET IsDownloadReportFlagForOps=0 WHERE id=1

--- [ops].[uspVerifyOTP_testing1_11102023] 8146657032,429463
ALTER PROCEDURE [ops].[uspVerifyOTP_testing1]  
--------------------------------------------------------
     
 @MobileNumbar BIGINT,        
 @OTP BIGINT      
AS        
BEGIN        
        
/****************************Start DECLARE VARIABLES*********************************/        
 DECLARE @UserLoginId INT,@usertypeId int,@Expiry datetime,@massege varchar(100),@otpCheck int,@userType varchar(50),@CompanyId INT,     
 @status varchar(50) ='failed', @AdminCheck int,@isSuperAdmin bit = 0,@UserName varchar(100)
 ,@Clientid int,@IsDownloadReportFlag int;   ---clientid added by sayali for HAP-2174 on 11 oct 2023  
      
 SELECT @AdminCheck =  COUNT(id) FROM ops.Admin WHERE phone=CAST(@MobileNumbar AS VARCHAR)       
 and deleted =0    
 SELECT TOP 1 @IsDownloadReportFlag = IsDownloadReportFlagForOps FROM AuditAcessTable;
      
 if( @AdminCheck >0)      
 BEGIN      
        SELECT TOP 1 @UserName=name,@UserLoginId=id,@usertypeId=usertypeId,@CompanyId=Isnull(companyId,0),@isSuperAdmin=IsSuperAdmin 
		,@Clientid=ClientId ---clientid added by sayali for HAP-2174 on 11 oct 2023  
		FROM ops.Admin 
        WHERE phone=CAST(@MobileNumbar AS VARCHAR)  and deleted =0      
 END      
      
      
      
      
      
 --if( @AdminCheck = 0)      
 --Begin      
 --SELECT TOP 1 @UserLoginId=DoctorId,@usertypeId=usertypeId,@CompanyId=0 FROM tele_consultaion.Doctor WHERE phone=CAST(@MobileNumbar AS VARCHAR)       
 --and deleted =0      
 --End      
      
      
      
  SELECT TOP 1 @userType = [Name] FROM [ops].[Usertype] where [Id] = @usertypeId and [Deleted] = 0      
      
 SELECT TOP 1 @otpCheck=otp from ops.LoginOTP Where userid =@UserLoginId and usertypeId =@usertypeId      
      
 SELECT TOP 1 @Expiry=expiry from ops.LoginOTP Where userid =@UserLoginId and usertypeId =@usertypeId       
 --SELECT TOP 1 otp,expiry,id,userid,usertypeId from tele_consultaion.LoginOTP Where userid =@UserLoginId and usertypeId =@usertypeId and otp = @OTP      
 if (getdate() <= @Expiry)      
 begin      
         if (@otpCheck = @OTP)      
         begin      
         set @massege ='otp verified successfully' ;      
         set @status ='Success';    
         select @MobileNumbar as MobileNumber,@OTP as OTP ,@Expiry as Expiry,@massege as Massege,@userType as UserType,@status as [Status],@UserLoginId as UserLoginId ,@usertypeId as usertypeId,@CompanyId as CompanyId, 
		 @isSuperAdmin as IsSuperAdmin ,@UserName as UserName  
		 ,@Clientid as Clientid, @IsDownloadReportFlag as IsDownloadReportFlag
         end      
         else      
         begin      
          set @massege = 'You entered wrong otp'      
         select @massege as Massege,@status as [Status]      
         end      
 end      
 else      
 begin      
 set @massege = 'otp expired'      
 select @massege as Massege,@status as [Status]      
 end      
 END 