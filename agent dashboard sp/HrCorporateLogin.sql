USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[HrCorporateLogin]    Script Date: 5/13/2024 1:43:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saurav Saxena> , <Anubhav Jha>  
-- Create date: <16-04-2023>  
-- Description: <Create For Login and Regiser User HR_CoportateLogin>  
-- =============================================  
---'akshay@seebagroup.com'
-- exec HrCorporateLogin 'Mobile','8349040731',NULL,NULL;
-- exec HrCorporateLogin 'Email',NULL,'narendra.tanty@healthassure.in','2oXA216B',NULL;

--Alter table HRLoginHistroy add agentLoginId BIGINT 


ALTER PROCEDURE [dbo].[HrCorporateLogin](
@LoginType VARCHAR(200),
@MobileNo VARCHAR(200)=NULL,
@EmailId VARCHAR(200)=NULL,
@Password VARCHAR(200)=NULL,
@GeneratedOtp INT =NULL
)
	

AS
BEGIN
DECLARE @OTPExpiryTime TIME(3) = CAST('00:1:00' AS TIME(3));
Declare @OTPExpiryDateTime DATETIME = GETDATE()+ CAST(@OTPExpiryTime AS DATETIME)
Declare @SMSContent Varchar(200);
Declare @MailSubject Varchar(200);
Declare @CommunicationTemplateId bigint;
   IF (@LoginType='Mobile')
    BEGIN
	    IF(@MobileNo IS NULL OR @MobileNo = '')
		 BEGIN
		   SELECT MobileNo= '', 'InValid Mobile No' as Message,200 as statuscode ,0 as status;
		 END
		ELSE
		 BEGIN
	       IF NOT EXISTS(select 1 from UserLogin  where MobileNo=@MobileNo)
		    BEGIN
			  SELECT MobileNo='', 'You Are Not Associated With Us, Please First Register Your Self' as Message,200 as statuscode ,0 as status;
		    END
		   ELSE
		    BEGIN
			  SET @GeneratedOtp  = CONVERT(numeric(12,0),RAND() * 899999) + 100000;
			  UPDATE UserLogin SET OTP=@GeneratedOtp, OTPExpiryDateTime=@OTPExpiryDateTime  WHERE MobileNo=@MobileNo;
			SELECT @CommunicationTemplateId=CommunicationTemplateId,@SMSContent=TemplateContent,@MailSubject=MailSubject FROM CommunicationTemplate WHERE  CommunicationTemplateId=775
			  SET @SMSContent= REPLACE(@SMSContent,'[OTPNUMBER]',@GeneratedOtp)  
              SELECT MobileNo=@MobileNo,@GeneratedOtp as OTP, OTPExpiryDateTime=@OTPExpiryDateTime,SMSContent = @SMSContent ;
			INSERT INTO SmsEmailScheduler(AppointmentId,UserLoginId,TemplateId,[Type],SentStatus,SentDateTime,SentTo,MailContent,MailSubject,CreatedBy,CreatedDatetime)
			VALUES(0,0,@CommunicationTemplateId,'SMS','Y',GETDATE(),@MobileNo,@SMSContent,'Login OTP','HealthAssure-Ecommerce-API',GETDATE())

			  ---'OTP Has Sent To This Number '+@MobileNo+'.' as message,200 as statuscode 
		    END
		END
    END
	ELSE
	 BEGIN
	   IF EXISTS(select 1 from UserLogin  where UserName =@EmailId and Password = @Password and UserRoleId=2) 
	    BEGIN
		Print 'Userlogin'
		   SELECT  Concat (u.firstname, u.LastName) As UserName, u.MobileNo, UserLoginId, UserRoleId, u.ClientId, c.ClientName,c.CoBrandingIcon as ClientIcon,c.IsAddUser as IsAddUser, c.ClientType as clientType, c.ViewHCKReport as ViewHCKReport, c.isViewSearchProvider as IsViewSearchProvider ,200 as statuscode, NULL as InceptionDate FROM UserLogin u
		   join Client c on c.ClientId=u.ClientId
		   WHERE UserName=@EmailId and UserRoleId=2;

		   
		   insert into HRLoginHistroy
		   SELECT UserLoginId ,ClientId, GETDATE(),NULL, NULL,NULL, NULL, NULL ,null FROM UserLogin 
		   WHERE UserName=@EmailId and UserRoleId=2
		END
		ELSE IF EXISTS(select 1 from AgentLogin  where UserName =@EmailId and Password = @Password)
		BEGIN
		Print 'Agentlogin'
		    SELECT  u.UserName As UserName, u.AgentMobile as MobileNo, 0 as UserLoginId, 0 as UserRoleId, 0 as ClientId, NULL as ClientName,
		   NULL as ClientIcon,NULL as IsAddUser, NULL as clientType, NULL as ViewHCKReport
		   , NULL as IsViewSearchProvider, u.UserRoleType as UserRoleType, u.PartnerAssignedToAdmin as PartnerAssigned ,200 as statuscode,ISNULL(pd.CreatedDate, GETDATE() ) as InceptionDate 
		   FROM AgentLogin u left join OPDPartnerDetails pd on pd.PartnerCode=u.PartnerCode
		   WHERE UserName=@EmailId ;

		    ----select top 10 * from AgentLogin order by 1 desc
		   --select top 10 * from HRLoginHistroy order by 1 desc
		    
			DECLARE @AgentId bigint,@PartnerCode varchar(100),@ClientId bigint ;
			SELECT @PartnerCode = PartnerCode from AgentLogin  
			where UserName =@EmailId and Password = @Password;
			SELECT @AgentId = Agentloginid from AgentLogin  
			where UserName =@EmailId and Password = @Password;

			
			if (select CNPlanDetailsid from OPDPartnerDetails where PartnerCode=@PartnerCode) is null
			 begin
			   select @ClientId =  ClientId from  CorporatePlan where CorporatePlanId=(select PlanId from OPDPartnerDetails where PartnerCode=@PartnerCode)
			 end
			else
			  begin
			    select @ClientId =  ClientId from  CNPlanDetails where CNPlanDetailsId=(select CNPlanDetailsId from OPDPartnerDetails where PartnerCode=@PartnerCode)
			  end

		   insert into HRLoginHistroy
		     SELECT null ,@ClientId, GETDATE(),NULL, NULL,NULL, NULL, NULL,@AgentId from AgentLogin  
			   where UserName =@EmailId and Password = @Password;
		  
		END
	   ELSE
	    BEGIN 
		  SELECT Null as UserName ,'You Are Not Associated With Us, Please First Register Your Self' as Message,200 as statuscode ,0 as status;
		END
	 END
END