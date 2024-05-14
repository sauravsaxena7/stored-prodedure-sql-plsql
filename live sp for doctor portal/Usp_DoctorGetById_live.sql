USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_DoctorGetById]    Script Date: 11/24/2023 1:52:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --exec [tele_consultaion].[Usp_DoctorGetById] 325
--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [tele_consultaion].[Usp_DoctorGetById]    
@DoctorId int      
AS      
BEGIN      
 SET NOCOUNT ON;      
 WITH cte_company_details
 AS
 (
 select com.CompanyId,com.address as company_address,cty.CityName as company_city,st.StateName as company_state,cntry.CountryName as company_country from Company  com 
 left join City cty on com.cityId=cty.CityId
 left join State st on com.stateId=st.StateId
 left join Country cntry on com.countryId=cntry.CountryId
 )

SELECT d.[DoctorId]      
      ,ISNULL( d.[name],'') as[name]      
      ,d.[phone]      
   ,ISNULL(d.[alternatePhone],'') as [alternatePhone]      
      ,d.[email]      
      ,d.genderId     
   ,d.DateOfBirth  
   ,g.GenderName      
      ,ISNULL(d.[experince],'') as [experince]      
      ,ISNULL(d.[image],'') as [image]      
      ,ISNULL(d.[address]  ,'')   as [address] 
      ,d.[cityId]      
   ,ci.CityName      
      ,d.[stateId]      
   ,st.StateName      
      ,ISNULL(d.[pincode] ,'') as [pincode]    
      ,ISNULL(d.[latitude] ,'') as    [latitude] 
      ,ISNULL(d.[longitude],'') AS [longitude]      
      ,d.[countryId]      
   ,c.CountryName      
      ,d.[companyid]      
   ,co.companyname      
      ,d.[skillcategoryId]      
   ,s.skillName      
      ,d.[onboardingcategory]      
      ,ISNULL(d.[isf2f],0) as [isf2f]     
      ,ISNULL(d.[istele],0) as [istele]   
      ,ISNULL(d.[isvideo],  0) as [isvideo]  
   ,d.usertypeId      
   ,u.Name as usertype      
   ,ISNULL(d.Award,'') As Award      
   ,ISNULL(d.Registration,'') As Registration      
   ,ISNULL(d.Biography,'') As Biography    
   ,ISNULL(d.CreatedBy,-1) as CreatedById  
   ,ISNULL(d.CreatedByRole,1)  as CreatedByRole
   , ccd.company_address
   ,ccd.company_city
   ,ccd.company_state
   ,ccd.company_country
   ,ISNULL(CASE  
 WHEN CAST(d.CreatedByRole as varchar(10)) = 2 THEN (select [name] from tele_consultaion.Doctor where doctorId = d.CreatedBy)  
 WHEN CAST(d.CreatedByRole as varchar(10))=1 THEN (select [name] from tele_consultaion.[Admin] where id = d.CreatedBy)  
 END,'Riten Singh') as CreatedByName,  
  isnull(d.SignatureImage,'') as SignatureImage,  
  isnull(d.PAN,'') as PAN,  
 isnull(d.CertificateImage,'') as CertificateImage, 
 ISNULL(d.DoctorDraft,'N') as DoctorDraft,
 isnull(d.ApprovForConsultation,0) as ApprovForConsultation,  --0 means false  
 isnull(d.College,'') as College ,   
 isnull(d.University,'') as University, 
 isnull(d.IsDoctorAvailable,0) as IsDoctorAvailable,
 CASE  
 WHEN d.deleted =0 THEN 'Active'  
 else 'InActive'  
 END as DoctorStatus,DoctorImageTaggingFlag
  FROM [tele_consultaion].[Doctor] d       
   join Gender g on d.genderId =g.GenderId      
   join Country C on d.countryId = C.CountryId      
   join [State] st on d.stateId = st.StateId      
   join City ci on d.cityId = ci.CityId      
   join Company co on d.companyid = co.CompanyId      
   join Skillcategory s on d.skillcategoryId = s.skillcategoryId      
   join Usertype u on d.usertypeId = u.Id  
   left join cte_company_details ccd on d.companyid=ccd.CompanyId
  Where  d.DoctorId=@DoctorId      
END 

--Completion time: 2023-06-07T17:17:18.1801734+05:30
