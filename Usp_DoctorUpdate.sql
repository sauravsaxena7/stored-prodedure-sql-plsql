USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_DoctorUpdate]    Script Date: 12/1/2023 11:04:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [tele_consultaion].[Usp_DoctorUpdate]  
@DoctorId int,  
@Name varchar(100),  
@DateOfBirth DateTime,  
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
@ModifiedBy int,  
@Award varchar(100),  
@Biography varchar(1500),  
@alternatePhone varchar(100),  
@Registration varchar(100),
@ModifiedByRole int,
@DocSignImage varchar(500)=null,
@PAN varchar(50)=null,
@CertificateImage varchar(500)=null,
@ApprovForConsultation bit=null,
@College varchar(50)=null,
@University varchar(50)=null,
@DoctorImageTaggingFlag varchar(20)=null

AS  
BEGIN  
 SET NOCOUNT ON; 
 if(@Image =null or @Image ='')
 begin
Update Doctor Set  
    name=@Name,  
    email=@Email,  
    DateOfBirth=@DateOfBirth,  
    alternatePhone=@alternatePhone,  
    genderId=@GenderId,  
    experince=@Experince,  
    address=@Address,  
    cityId=@CityId,  
    stateId=@StateId,  
    pincode=@Pincode,  
    latitude=@Latitude,  
    longitude=@Longitude,  
    countryId=@CountryId,  
    companyid = @Companyid,  
    skillcategoryId=@SkillcategoryId,  
    onboardingcategory=@Onboardingcategory,  
    isf2f=@Isf2f,  
    istele=@Istele,  
    isvideo=@Isvideo,  
    ModificationDateTime=GetDate(),  
    ModifiedBy=@ModifiedBy,  
    Award=@Award,  
    Registration=@Registration,  
    Biography=@Biography,
	ModifiedByRole=@ModifiedByRole,
	SignatureImage= case when @DocSignImage=null or @DocSignImage='' then SignatureImage else @DocSignImage end,
	PAN=@PAN,
	CertificateImage=case when @CertificateImage=null or @CertificateImage='' then CertificateImage else @CertificateImage end,
	ApprovForConsultation=@ApprovForConsultation,
	College = @College,
	University = @University,
	ActivationDate=CASE @ApprovForConsultation WHEN 1 THEN GETDATE() end,
	DoctorImageTaggingFlag=@DoctorImageTaggingFlag,
	DoctorDraft='N'
    Where DoctorId=@DoctorId  
 end
 else
 begin
Update Doctor Set  
    name=@Name,  
    email=@Email,  
    DateOfBirth=@DateOfBirth,  
    alternatePhone=@alternatePhone,  
    genderId=@GenderId,  
    experince=@Experince,  
   Image = @Image,  
    address=@Address,  
    cityId=@CityId,  
    stateId=@StateId,  
    pincode=@Pincode,  
    latitude=@Latitude,  
    longitude=@Longitude,  
    countryId=@CountryId,  
    companyid = @Companyid,  
    skillcategoryId=@SkillcategoryId,  
    onboardingcategory=@Onboardingcategory,  
    isf2f=@Isf2f,  
    istele=@Istele,  
    isvideo=@Isvideo,  
    ModificationDateTime=GetDate(),  
    ModifiedBy=@ModifiedBy,  
    Award=@Award,  
    Registration=@Registration,  
    Biography=@Biography,
	ModifiedByRole=@ModifiedByRole,
	SignatureImage= case when @DocSignImage=null or @DocSignImage='' then SignatureImage else @DocSignImage end,
	PAN=@PAN,
	CertificateImage=case when @CertificateImage=null or @CertificateImage='' then CertificateImage else @CertificateImage end,
	ApprovForConsultation=@ApprovForConsultation,
	College = @College,
	University = @University,
	ActivationDate=CASE @ApprovForConsultation WHEN 1 THEN GETDATE() end,
	DoctorImageTaggingFlag=@DoctorImageTaggingFlag,
	DoctorDraft='N'
    Where DoctorId=@DoctorId 
end
END  