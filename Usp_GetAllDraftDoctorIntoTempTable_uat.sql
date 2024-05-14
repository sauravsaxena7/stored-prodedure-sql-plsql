USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetAllDraftDoctorIntoTempTable]    Script Date: 11/24/2023 1:35:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [tele_consultaion].[Usp_GetAllDraftDoctorIntoTempTable] 
    
  
ALTER PROCEDURE [tele_consultaion].[Usp_GetAllDraftDoctorIntoTempTable]       
 
AS          
BEGIN          
 SET NOCOUNT ON;

  SELECT distinct(d.[DoctorId])          
      ,ISNULL( d.[name],'') as[name]          
      ,ISNULL( d.[phone],'') as [phone]          
      ,IsNull(d.[alternatePhone],'') as [alternatePhone]          
      ,IsNull(d.[DateOfBirth], '') AS [DateOfBirth]          
      ,d.[email]          
      ,d.genderId          
      ,g.GenderName          
      ,ISNULL(d.[experince],'') as [experince]          
      ,ISNULL(d.[image],'') as [image]          
      ,ISNULL(d.[address],'') as [address]          
      ,d.[cityId]          
      ,ISNULL(ci.CityName,'') as CityName          
      ,d.[stateId]          
      ,ISNULL(s.StateName,'') as StateName        
      ,ISNULL(d.[pincode],'') as pincode          
      ,ISNULL(d.[latitude],'') as latitude         
      ,ISNULL(d.[longitude],'') as longitude          
      ,d.[countryId]          
      ,ISNULL(c.CountryName,'') as CountryName          
      ,isnull(d.[companyid],0 ) as  companyid      
      ,ISNULL(cm.companyname ,'') as companyname          
      ,ISNULL(d.[skillcategoryId],0) As  skillcategoryId       
      ,ISNULL(sk.skillName ,'') as skillcategoryName         
      ,ISNULL(d.[onboardingcategory],'') as onboardingcategory        
      ,ISNULL(o.onboardingcategoryName ,'') as onboardingcategoryName          
      ,ISNULL([isf2f] ,0)  as isf2f       
      ,ISNULL([istele],0) as istele         
      ,ISNULL([isvideo] ,0) as isvideo        
   ,d.usertypeId 
   ,ISNULL(d.DoctorDraft,'N') AS DoctorDraft
   ,u.Name as usertypeName          
   ,ISNULL(d.deleted,0) As deleted          
   ,ISNULL(Award,'') As Award          
   ,ISNULL(Registration,'') As Registration        
         
   ,ISNULL(d.CreatedBy,-1) as CreatedById        
   ,ISNULL(d.CreatedByRole,1)  as CreatedByRole
   ,IIF(p.ProviderId is null,'',Concat(p.HouseNumber,',',p.HouseName,',',p.Landmark1,',',p.LandMark2,',',p.CityName,',',p.StateName,',',p.CountryName)) as ProviderAddress
   ,p.Pincode as ProviderPincode
 ,IIF(DSM.DoctorId is null,'N','Y') as Slots
 ,ISNULL(d.MRP,-1) AS MRP

   ,d.DCPrice         ------sayali
   ,d.AppPriceGraded  ------sayali
   ,d.AppPriceMargin   ------sayali  
   ,ISNULL(d.DoctorImageTaggingFlag,'') AS DoctorImageTaggingFlag
   ,ISNULL(CASE        
 WHEN CAST(d.CreatedByRole as varchar(10)) = 2 THEN (select [name] from tele_consultaion.Doctor where doctorId = d.CreatedBy)        
 WHEN CAST(d.CreatedByRole as varchar(10))= 1 THEN (select [name] from tele_consultaion.[Admin] where id = d.CreatedBy)      
 END,'Riten Singh') as CreatedByName,      
 isnull(d.SignatureImage,'') as SignatureImage,      
 isnull(d.PAN,'') as PAN,      
 isnull(d.CertificateImage,'') as CertificateImage,      
 isnull(d.ApprovForConsultation,0) as ApprovForConsultation  --0 means false      
 ,-1 as languageId ,-1 as casetypeId,-1 as specialtyId,-1 as qualificationId
 ,d.CreatedDate,d.ActivationDate,   isnull(d.IsDoctorAvailable,0) as IsDoctorAvailable,isnull(cm.ProviderId,'') as ProviderId 
 
    
 Into [tele_consultaion].#tempDoctor  
 
  FROM [tele_consultaion].[Doctor] d          
  left Join Gender g           
  on  d.genderId =g.GenderId          
  left Join [tele_consultaion].[Country] c           
  on d.countryId = c.CountryId           
  left join [tele_consultaion].[Company] cm          
  on d.companyid = cm.CompanyId  
  left join [HaportalUAT].[dbo].[Provider] p 
  on p.ProviderId = cm.ProviderId

  left join HAProductsUAT.dbo.DoctorSlotsMaster DSM 
  on DSM.DoctorId = d.DoctorId   

  left join [tele_consultaion].[State] s          
  on d.stateId = s.stateId          
          
  left join [tele_consultaion].[City] ci          
  on d.cityId = ci.CityId          
  left join [tele_consultaion].onboardingcategory o          
  on d.onboardingcategory = o.onboardingcategoryId          
  left join [tele_consultaion].Skillcategory sk          
  on d.skillcategoryId = sk.SkillcategoryId          
  left join [tele_consultaion].Usertype u          
  on d.usertypeId = u.Id 
                             
  Where d.DoctorDraft='Y'; 
       
	   SELECT * from [tele_consultaion].#tempDoctor
 
END