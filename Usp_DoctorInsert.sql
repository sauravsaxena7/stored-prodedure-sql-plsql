USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_DoctorInsert]    Script Date: 11/9/2023 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [tele_consultaion].[Usp_DoctorInsert]          
@Name varchar(100),          
@Phone varchar(100),        
@AlternatePhone varchar(100),       
@DateOfBirth date,      
@Email varchar(100),          
@GenderId int,          
@Experince varchar(20),          
@Image varchar(500),          
@Address varchar(100),          
@CityId int,          
@StateId int,          
@Pincode varchar(20),          
@Latitude varchar(100),          
@Longitude varchar(100),          
@CountryId int,          
@Companyid int,          
@SkillcategoryId int,          
@Onboardingcategory int,          
@Isf2f bit,          
@Istele bit,          
@Isvideo bit,          
@CreatedBy int,          
@Award varchar(100),          
@Registration varchar(100),      
@Biography varchar(1500),    
@CreatedByRole int,    
@DocSignImage varchar(500)=null,  
@PAN varchar(50)=null,  
@CertificateImage varchar(500)=null,  
@ApprovForConsultation bit=null,  
@College varchar(50)=null,  
@University varchar(50)=null,
@DoctorImageTaggingFlag varchar(20)=null 
  
AS          
BEGIN          
declare @Id int = 0,@count int , @Admincount int=0,@MaxId bigint
select @MaxId = MAX(DoctorId)+1 from tele_consultaion.Doctor  
select @count = count(DoctorId) from tele_consultaion.Doctor where phone = @Phone and @Phone Not like '%1111111111%'     
--select @Admincount = count(id) from tele_consultaion.[Admin] where phone = @Phone      
 SET NOCOUNT ON;         
 If(@count = 0 and @Admincount = 0)      
  Begin      
   Insert into Doctor (name,phone,alternatePhone,DateOfBirth,email,genderId,experince,image,address,cityId,stateId,          pincode,latitude,longitude,countryId,companyid,skillcategoryId,onboardingcategory,isf2f,istele,isvideo,deleted,          CreatedDate,CreatedBy,usertypeId,Award,Registration,Biography,CreatedByRole,SignatureImage,PAN,CertificateImage,  ApprovForConsultation,College,University,IsDoctorAvailable,ActivationDate,DoctorImageTaggingFlag,DoctorDraft) 
   
   values(@Name,@Phone,@AlternatePhone,@DateOfBirth,@Email,@GenderId,@Experince,@Image,@Address,@CityId,@StateId,       @Pincode,@Latitude,@Longitude,@CountryId,@Companyid,@SkillcategoryId,@Onboardingcategory,@Isf2f,@Istele,@Isvideo,0,
	  GetDate(),@CreatedBy,2,@Award,@Registration,@Biography,@CreatedByRole,@DocSignImage,@PAN,@CertificateImage,
	  @ApprovForConsultation,@College,@University,0, CASE @ApprovForConsultation WHEN 1 THEN GETDATE() end,
	  @DoctorImageTaggingFlag,'N');  
	  
 ----------------------------------------  
 Declare @companyName varchar(100)  
  select @companyName=companyname from tele_consultaion.Company where CompanyId=@Companyid  
    
   set @Id = cast((select scope_identity()) as int);      
   select @Id as Id , 'The Doctor added successfully for the ' +@companyName+ ' agency' as [message],'Success' as flag;        
  End      
  else      
  begin      
   select @Id as Id, 'mobile number already registered for another user' as [message],'UnSuccess' as flag;        
  end      
END 
