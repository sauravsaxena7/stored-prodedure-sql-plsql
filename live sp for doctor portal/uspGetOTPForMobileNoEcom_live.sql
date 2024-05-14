USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[uspGetOTPForMobileNoEcom]    Script Date: 11/25/2023 7:11:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--[tele_consultaion].[uspGetOTPForMobileNoEcom] '941085272','Admin'  
ALTER PROCEDURE [tele_consultaion].[uspGetOTPForMobileNoEcom]   
 @MobileNumbar BIGINT,      
 @Source VARCHAR(300) = NULL,      
 @OTPType VARCHAR(200) = 'EcomLogin'      
AS      
BEGIN      
      
/****************************Start DECLARE VARIABLES*********************************/      
 DECLARE @OTPExpiryTime TIME(3) = CAST('00:10:00' AS TIME(3))      
 DECLARE @UserLoginId BIGINT,@OTP varchar(100),@OTPExpiryDateTime DATETIME = GETDATE()+ CAST(@OTPExpiryTime AS DATETIME)      
 DECLARE @TempUserSelfRegistrationId BIGINT,@UserCount INT=0,@UserLoginStatus CHAR(1),@usertypeId int      
 DECLARE @Status BIT = 0,@Message VARCHAR(500),@SMSContent NVARCHAR(MAX),@CommunicationTemplateId BIGINT,@MailSubject NVARCHAR(300), @UserCountAdmin INT=0,@UserCountDoctor INT=0     
 DECLARE @email varchar(200)
/****************************End DECLARE VARIABLES*********************************/       
   SELECT @UserCountAdmin=COUNT(*) FROM tele_consultaion.Admin WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR)   
   SELECT @UserCountDoctor=COUNT(*) FROM tele_consultaion.Doctor WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR)   
   If(@Source='Doctor')    
BEGIN    
    SELECT TOP 1 @UserLoginId=DoctorId,@usertypeId=usertypeId,@email=email FROM tele_consultaion.Doctor WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR)     
 and deleted =0    
      
/****************************Start Main Logic*********************************/      
 SET @OTP = LEFT(CAST(RAND()*1000000000+999999 AS INT),6)       
      
 IF(@OTPType='EcomLogin')      
 BEGIN      
  IF(@UserLoginId IS NOT NULL)      
  BEGIN      
   SELECT @UserCount=COUNT(*) FROM tele_consultaion.Doctor WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR) AND deleted =0 ;
   
   DECLARE @DoctorDraft varchar(1);
   if @UserCount=1
     BEGIN
	    SELECT @DoctorDraft= ISNULL(DoctorDraft,'N') FROM tele_consultaion.Doctor WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR) AND deleted =0 ;
	 END
   IF(@UserCount>1)      
   BEGIN       
    SET @Message='This MobileNo is exists for multiple users'      
   END      
   ELSE IF(@UserCount=0)      
   BEGIN      
    SET @Message='This Mobile Number does not exist in database'     
    SET @Status = 2    
   END
   ELSE IF(@DoctorDraft='Y')      
   BEGIN      
    SET @Message='This Doctor is in Draft mode.'        
   END
   ELSE      
   BEGIN      
    UPDATE tele_consultaion.LoginOTP  SET OTP=@OTP,expiry=@OTPExpiryDateTime WHERE userid=@UserLoginId and usertypeId = @usertypeId     
    SET @Status = 1      
   END      
  END      
  set @SMSContent ='Greetings from HealthAssure. OTP for your login is [OTPNUMBER]. Please do not share it with anyone. - HealthAssure'    
  IF(@Status=1)      
  BEGIN      
      
   SET @SMSContent= REPLACE(@SMSContent,'[OTPNUMBER]',@OTP)      
      
  END      
 END      
/****************************End Main Logic*********************************/       
         
/**************************SELECT ALL TABLE*******************************/      
 IF @Status = 1      
     BEGIN      
      SELECT @Status AS [Status],200 AS SubCode,ISNULL(@Message,'OTP Sent successfully') AS [Message]      
    
  SELECT @OTP AS OTP, @OTPExpiryDateTime AS OTPExpiryDateTime,@OTPExpiryTime AS OTPExpiryTime,@MobileNumbar AS MobileNumbar,@SMSContent AS SMSContent, 
  @email as Email       
    
     END      
 ELSE     
      BEGIN      
       SELECT @Status AS [Status],400 AS SubCode,ISNULL(@Message,'This Mobile Number does not exist in database')    AS  [Message]      
      END     
    
   END    
   --for Admin    
    
    
      Else     
If(@Source='Admin')    
   BEGIN    
    SELECT TOP 1 @UserLoginId=id,@usertypeId=usertypeId,@email=email FROM tele_consultaion.[Admin] WHERE phone=CAST(@MobileNumbar AS VARCHAR)     
 and deleted =0    
      
/****************************Start Main Logic*********************************/      
 SET @OTP = LEFT(CAST(RAND()*1000000000+999999 AS INT),6)       
      
 IF(@OTPType='EcomLogin')      
 BEGIN      
  IF(@UserLoginId IS NOT NULL)      
  BEGIN      
   SELECT @UserCount=COUNT(*) FROM tele_consultaion.[Admin] WITH(NOLOCK)  WHERE phone=CAST(@MobileNumbar AS VARCHAR) AND deleted =0      
   IF(@UserCount>1)      
   BEGIN       
    SET @Message='This MobileNo is exists for multiple users'      
   END      
   ELSE IF(@UserCount=0)      
   BEGIN      
    SET @Message='This Mobile Number does not exist in database'     
  SET @Status = 2    
   END      
   ELSE      
   BEGIN      
    UPDATE tele_consultaion.LoginOTP  SET OTP=@OTP,expiry=@OTPExpiryDateTime WHERE userid=@UserLoginId and usertypeId = @usertypeId     
    SET @Status = 1      
   END      
  END      
  set @SMSContent ='Greetings from HealthAssure. OTP for your login is [OTPNUMBER]. Please do not share it with anyone. - HealthAssure'    
  IF(@Status=1)      
  BEGIN      
      
   SET @SMSContent= REPLACE(@SMSContent,'[OTPNUMBER]',@OTP)      
      
  END      
 END      
/****************************End Main Logic*********************************/       
         
/**************************SELECT ALL TABLE*******************************/      
 IF @Status = 1      
     BEGIN      
      SELECT @Status AS [Status],200 AS SubCode,ISNULL(@Message,'OTP Sent successfully') AS [Message]      
    
  SELECT @OTP AS OTP, @OTPExpiryDateTime AS OTPExpiryDateTime,@OTPExpiryTime AS OTPExpiryTime,@MobileNumbar AS MobileNumbar,@SMSContent AS SMSContent, 
  @email as Email       
    
     END      
 ELSE     
      BEGIN      
       SELECT @Status AS [Status],400 AS SubCode,ISNULL(@Message,'This Mobile Number does not exist in database')    AS  [Message]      
      END     
    
   END    
    
-------------------------------------------------------------------------      
/**************************SELECT ALL TABLE*******************************/      
END 