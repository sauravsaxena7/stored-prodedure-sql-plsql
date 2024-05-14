USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_NewDoctorDraftCreation]    Script Date: 11/24/2023 1:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [tele_consultaion].[Usp_NewDoctorDraftCreation]  
@Name varchar(100)=null,          
@Phone varchar(100),        
@AlternatePhone varchar(100)=null,      
@DateOfBirth date=null,      
@Email varchar(100)=null,          
@GenderId int=null,          
@Experince varchar(20)=null,          
@Image varchar(500)=null,          
@Address varchar(100)=null,          
@CityId int=null,          
@StateId int=null,          
@Pincode varchar(20)=null,          
@Latitude varchar(100)=null,          
@Longitude varchar(100)=null,          
@CountryId int=null,          
@Companyid int=null,          
@SkillcategoryId int=null,          
@Onboardingcategory int=null,       
@Isf2f bit=null,          
@Istele bit=null,          
@Isvideo bit=null,          
@CreatedBy int=null,          
@Award varchar(100)=null,          
@Registration varchar(100)=null,      
@Biography varchar(1500)=null,    
@CreatedByRole int=null,    
@DocSignImage varchar(500)=null,  
@PAN varchar(50)=null,  
@CertificateImage varchar(500)=null,  
@ApprovForConsultation bit=null,  
@College varchar(50)=null,  
@University varchar(50)=null ,
@DoctorImageTaggingFlag varchar(20)=null ,
@operationFlag varchar(10) =null,
@doctorId int=-1
AS          
BEGIN
   DECLARE @Id int = 0,@count int , @Admincount int=0,@MaxId bigint;
   
   SELECT @count = count(DoctorId) from tele_consultaion.Doctor where phone = @Phone and @Phone Not like '%1111111111%' 
   IF(@count = 0 AND @Admincount=0 and @operationFlag='ADD') --IF @COUNT=0 SECTION START  
     BEGIN
	    Insert into Doctor(name,phone,alternatePhone,DateOfBirth,email,genderId,experince,image,address,cityId,stateId,          pincode,latitude,longitude,countryId,companyid,skillcategoryId,onboardingcategory,isf2f,istele,isvideo,deleted,          CreatedDate,CreatedBy,usertypeId,Award,Registration,Biography,CreatedByRole,SignatureImage,PAN,CertificateImage,  ApprovForConsultation,College,University,IsDoctorAvailable,ActivationDate,DoctorImageTaggingFlag,DoctorDraft)
		
		values(@Name,@Phone,@AlternatePhone,@DateOfBirth,@Email,@GenderId,@Experince,@Image,@Address,@CityId,@StateId,          @Pincode,@Latitude,@Longitude,@CountryId,@Companyid,@SkillcategoryId,@Onboardingcategory,@Isf2f,@Istele,@Isvideo,
		0,GetDate(),@CreatedBy,2,@Award,@Registration,@Biography,@CreatedByRole,@DocSignImage,@PAN,@CertificateImage,
		@ApprovForConsultation,@College,@University,1,CASE @ApprovForConsultation WHEN 1 THEN GETDATE() end,@DoctorImageTaggingFlag,'Y'); 

		
		Declare @companyName varchar(100) ;
		select @companyName=companyname from tele_consultaion.Company where CompanyId=@Companyid ;

		set @Id = cast((select scope_identity()) as int);

		select @Id as Id , 'The Doctor Draft ADDED successfully for the ' +@companyName+ ' agency' as [message],'Success' as flag;  



	 END --IF @COUNT=0 SECTION END  
   ELSE IF (@operationFlag='EDIT')
      BEGIN
	     Update Doctor Set name=@Name,email=@Email,DateOfBirth=@DateOfBirth,alternatePhone=@alternatePhone,  genderId=@GenderId,experince=@Experince,Image = @Image,address=@Address,cityId=@CityId,  stateId=@StateId,pincode=@Pincode,latitude=@Latitude,longitude=@Longitude,countryId=@CountryId,  companyid = @Companyid,skillcategoryId=@SkillcategoryId,onboardingcategory=@Onboardingcategory,  isf2f=@Isf2f,istele=@Istele,isvideo=@Isvideo,ModificationDateTime=GetDate(),  ModifiedBy=@CreatedBy,Award=@Award,Registration=@Registration,Biography=@Biography,
		   ModifiedByRole=@CreatedByRole,
		   SignatureImage= case when @DocSignImage=null or @DocSignImage='' then SignatureImage else @DocSignImage end,
	       PAN=@PAN,
	       CertificateImage=case when @CertificateImage=null or @CertificateImage='' then CertificateImage else @CertificateImage end,
	       ApprovForConsultation=@ApprovForConsultation,College = @College,
		   University = @University,ActivationDate=CASE @ApprovForConsultation WHEN 1 THEN GETDATE() end,
		   DoctorImageTaggingFlag=@DoctorImageTaggingFlag,
		   DoctorDraft='Y'

       Where DoctorId=@doctorId
	   
	   
		select @companyName=companyname from tele_consultaion.Company where CompanyId=@Companyid ;

		set @Id = cast((select scope_identity()) as int);

		Update Doctor SET phone=@Id where DoctorId=@Id;
		select @doctorId as Id , 'The Doctor Draft UPDATED successfully for the ' +@companyName+ ' agency' as [message],'Success' as flag;

	  END
   ELSE
     BEGIN
	    select @Id as Id, 'mobile number already registered for another user lola' as [message],'UnSuccess' as flag;
	 END
print 'lola'
END