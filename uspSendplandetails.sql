USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspSendplandetails]    Script Date: 11/1/2023 3:28:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC uspSendplandetails  518138,70000002
ALTER  PROCEDURE [dbo].[uspSendplandetails]       
      
@UserLoginId varchar(50),  
@CorporatePlanID varchar(50)=NULL  
AS  
Declare @Name varchar(50);  
Declare @Password varchar(50);  
Declare @Username varchar(50);  
Declare @Clientid varchar(50); 
Declare @TemplateContent Varchar(Max);
begin  
  
select @Name=CONCAT(FirstName,LastName),@Password=Password,@Username=UserName,@clientid=Clientid from userlogin where userloginid=@UserLoginId  
--select @TemplateContent=templateContent from communicationtemplate where corporateplanid =@CorporatePlanID  and type='EMAIL'  and TriggerType='USERNAME'


 set @TemplateContent=(select top 1 templateContent from communicationtemplate where corporateplanid =@CorporatePlanID  and type='EMAIL'  and TriggerType='USERNAME');

 Declare @communicationtemplateid varchar(100)=(select top 1 CommunicationTemplateid from communicationtemplate where corporateplanid =@CorporatePlanID  and type='EMAIL'  and TriggerType='USERNAME' );

  if @TemplateContent is NOT NULL ---ADDED BY SAURAV SUMAN---
      BEGIN --TEMPLATE CONTENT NOT NULL START
	      if(exists(select corporateplanid from CommunicationTemplate where CorporatePlanId=@CorporatePlanID))  
begin  
print 'test 1'
print 'sayali_1'
Select TemplateContent=Replace(Replace(Replace(TemplateContent,'[CUSTOMERNAME]',@Name),'[USERNAME]',@Username),'[PASSWORD]',@Password) from CommunicationTemplate where CorporatePlanId=@CorporatePlanID and Type='EMAIL'   and TriggerType='USERNAME'
/*************************for sending the mail***********************************/  
if(exists(select id,RefrenceId,TriggerType,Flag,Type,ClientId,PlanId from BulkSchdulerMail where PlanId=@CorporatePlanID))  
begin  
print 'test 2'
print 'sayali_2'
insert into BulkSchdulerMail
select @UserLoginId, 'USERNAME', 'N', 'EMAIL', 'A', @Clientid, @CorporatePlanID, 'Opddigital Opd', GETDATE(), NULL,'EMP', NULL
--update BulkSchdulerMail set Flag='N' where Type='EMAIL' and clientid=@Clientid and PlanId=@CorporatePlanID and RefrenceId=@UserLoginId  
end  
else  
begin 
print 'test 3'
print 'sayali_3'
insert into BulkSchdulerMail (RefrenceId,TriggerType,Flag,Type,VoucherActiveFlag,ClientId,PlanId,CreatedBy,CreatedDate,SendDate,mail_to,TotalExecutionCount)  
values  
(@UserLoginId,'USERNAME','N','EMAIL','A',@Clientid,@CorporatePlanID,'OPS',GETDATE(),NULL,'EMP',NULL)  
insert into BulkSchdulerMail
select @UserLoginId, 'USERNAME', 'N', 'EMAIL', 'A', @Clientid, @CorporatePlanID, 'Opddigital Opd', GETDATE(), NULL,'EMP', NULL
--update BulkSchdulerMail set Flag='N' where Type='EMAIL' and clientid=@Clientid and PlanId=@CorporatePlanID and RefrenceId=@UserLoginId  

end  
  
end  
/********************************end sendmail*******************************************/  
else  
begin 
print 'test 4'
print 'sayali_4'
insert into CommunicationTemplate(ClientId,TriggerType,Type,MailTo,TemplateContent,MailSubject,MailFrom,MailCc,MailBcc,IsActive,CreatedBy,  
CreatedDate,UpdatedBy,UpdatedDate,CorporatePlanId,SentTo)  
Values(@Clientid,'USERNAME','EMAIL','EMP',@TemplateContent,  
'HealthAssure - Account Plan Details','support@healthassure.in',NULL,NULL,'Y','Atul',GETDATE(),'Atul',GETDATE(),@CorporatePlanID,NULL)  
  
Select TemplateContent=Replace(Replace(Replace(TemplateContent,'[CUSTOMERNAME]',@Name),'[USERNAME]',@Username),'[PASSWORD]',@Password) from CommunicationTemplate where CorporatePlanId=@CorporatePlanID and Type='EMAIL'  
  
/***********************************for sending the mail*******************************************/  
insert into BulkSchdulerMail (RefrenceId,TriggerType,Flag,Type,VoucherActiveFlag,ClientId,PlanId,CreatedBy,CreatedDate,SendDate,mail_to,TotalExecutionCount)  
values  
(@UserLoginId,'USERNAME','N','EMAIL','A',@Clientid,@CorporatePlanID,'OPS',GETDATE(),NULL,'EMP',NULL)  
  
/****************************end mail***************************************/  
insert into BulkSchdulerMail
select @UserLoginId, 'USERNAME', 'N', 'EMAIL', 'A', @Clientid, @CorporatePlanID, 'Opddigital Opd', GETDATE(), NULL,'EMP', NULL
--update BulkSchdulerMail set Flag='N' where Type='EMAIL' and clientid=@Clientid and PlanId=@CorporatePlanID and RefrenceId=@UserLoginId  
  
  
end  
	  END--TEMPLTE CONTENT NOT NULL END
	  ELSE
	    BEGIN
		  SELECT 'TEMPLATE CONTENT IS MISSING' AS TemplateContent;
		END
		 ---ADDED BY SAURAV--- ---ADDED BY SAURAV SUMAN---


end