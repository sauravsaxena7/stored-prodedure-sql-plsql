USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_DoctorGetAll_test]    Script Date: 11/24/2023 1:43:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [tele_consultaion].[Usp_DoctorGetAll_test] null,null,null,null,null,null,null,null,'2022-08-14','2022-08-20',null,null,null,1,20,null,null    
ALTER PROCEDURE [tele_consultaion].[Usp_DoctorGetAll_test]    

 @name varchar(50)      
,@phone varchar(50)      
,@status int      
,@languageIds varchar(50)      
,@specilyIds varchar(50)      
,@QualificationIds varchar(50)      
,@companyIds varchar(100)       
,@caseTypeId int     
,@fromDate DateTime=null    
,@toDate DateTime=null    
,@fromActivationDate DateTime=null    
,@toActivationDate DateTime=null    
,@companyId int = null    
,@PageNumber int = 1  --page Number    
,@RecordPerPage int = 10    
,@flag varchar(10)=null --csv    
,@IsDoctorAvailable bit=null    
AS        
BEGIN        
 SET NOCOUNT ON;     
 Declare @ActiveDCount int , @inActiveDCount int, @TotalDCount int    
     
set @PageNumber = isnull(@PageNumber, 1)--page Number    
set @RecordPerPage = isnull(@RecordPerPage, 50)--page Number    
    
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
      ,[isf2f]        
      ,[istele]        
      ,[isvideo]        
   ,d.usertypeId        
   ,u.Name as usertypeName        
   ,ISNULL(d.deleted,0) As deleted        
   ,ISNULL(Award,'') As Award        
   ,ISNULL(Registration,'') As Registration 
   ,d.CreatedBy as CreatedById      
   ,d.CreatedByRole       
   ,ISNULL(CASE      
 WHEN CAST(d.CreatedByRole as varchar(10)) = 2 THEN (select [name] from tele_consultaion.Doctor where doctorId = d.CreatedBy)      
 WHEN CAST(d.CreatedByRole as varchar(10))= 1 THEN (select [name] from tele_consultaion.[Admin] where id = d.CreatedBy)    
 END,'Riten Singh') as CreatedByName,    
 isnull(d.SignatureImage,'') as SignatureImage,    
 isnull(d.PAN,'') as PAN,    
 isnull(d.CertificateImage,'') as CertificateImage,    
 isnull(d.ApprovForConsultation,0) as ApprovForConsultation  --0 means false    
 ,dl.languageId ,dc.casetypeId,ds.specialtyId,dq.qualificationId,d.CreatedDate,d.ActivationDate,   isnull(d.IsDoctorAvailable,0) as IsDoctorAvailable    
 ,p.ProviderId,IIF(p.ProviderId is null,'',Concat(p.HouseNumber,',',p.HouseName,',',p.Landmark1,',',p.LandMark2,',',p.CityName,',',p.StateName,',',p.CountryName)) as ProviderAddress,p.Pincode as ProviderPincode,
 IIF(DSM.DoctorId is null,'N','Y') as Slots,d.MRP,
 d.DCPrice
 ,d.AppPriceGraded
 ,d.AppPriceMargin
 
 
 
 ,d.DoctorImageTaggingFlag

  Into [tele_consultaion].#tempDoctor  
  FROM [tele_consultaion].[Doctor] d        
  left Join Gender g on  d.genderId =g.GenderId        
  left Join [tele_consultaion].[Country] c on d.countryId = c.CountryId         
  left join [tele_consultaion].[Company] cm on d.companyid = cm.CompanyId  
  left join [Haportal].[dbo].[Provider] p on p.ProviderId = cm.ProviderId   
  left join HAProduct.dbo.DoctorSlotsMaster DSM on DSM.DoctorId = d.DoctorId   
  left join [tele_consultaion].[State] s on d.stateId = s.stateId   
  left join [tele_consultaion].[City] ci on d.cityId = ci.CityId        
  left join [tele_consultaion].onboardingcategory o on d.onboardingcategory = o.onboardingcategoryId        
  left join [tele_consultaion].Skillcategory sk on d.skillcategoryId = sk.SkillcategoryId        
  left join [tele_consultaion].Usertype u on d.usertypeId = u.Id 
  left join [tele_consultaion].DoctorLanguage dl on d.DoctorId = dl.doctorId        
  left join [tele_consultaion].DoctorCasetype dc on d.DoctorId = dc.doctorId        
  left join [tele_consultaion].DoctorQualification dq on d.DoctorId = dq.doctorId        
  left join [tele_consultaion].DoctorSpecialty ds on d.DoctorId = ds.doctorId    
  Where ds.Deleted =0 and dq.Deleted = 0 and dl.Deleted =0 and dc.Deleted = 0
	    
SELECT distinct d.DoctorId, STRING_AGG(CONVERT(NVARCHAR(max),s.name),',' )  as specilities    
into #tempSpecilities    
FROM tele_consultaion.Doctor d    
JOIN tele_consultaion.DoctorSpecialty ds ON d.doctorId =ds.DoctorId    
JOIN tele_consultaion.Specialty s ON ds.specialtyId =s.SpecialtyId    
where  ds.Deleted = 0 and s.deleted = 0     
GROUP BY d.doctorId     
    
SELECT distinct d.DoctorId, STRING_AGG(CONVERT(NVARCHAR(max),q.name),',' )  as qualifications    
into #tempQualifications    
FROM tele_consultaion.Doctor d    
JOIN tele_consultaion.DoctorQualification dq ON d.doctorId =dq.DoctorId    
JOIN tele_consultaion.Qualification q ON dq.qualificationId =q.QualificationId    
where   dq.Deleted = 0 and q.deleted = 0    
GROUP BY d.doctorId     
    
SELECT distinct d.DoctorId, STRING_AGG(CONVERT(NVARCHAR(max),ct.name),',' )  as caseTypes    
into #tempCaseType    
FROM tele_consultaion.Doctor d    
JOIN tele_consultaion.DoctorCasetype dct ON d.doctorId =dct.DoctorId    
JOIN tele_consultaion.CaseType ct ON dct.casetypeId =ct.CaseTypeId    
where   dct.Deleted = 0 and ct.deleted = 0    
GROUP BY d.doctorId     
    
SELECT distinct d.DoctorId, STRING_AGG(CONVERT(NVARCHAR(max),l.LanguageName),',' )  as languages    
into #tempLanguage    
FROM tele_consultaion.Doctor d    
JOIN tele_consultaion.DoctorLanguage dl ON d.doctorId =dl.DoctorId    
JOIN tele_consultaion.[Language] l ON dl.languageId =l.LanguageId    
where   dl.Deleted = 0 and l.deleted = 0    
GROUP BY d.doctorId     
------------------------------------------------------------------------End Declare or Tempdata    
    
IF(@fromActivationDate is null OR @toActivationDate is null)    
Begin    
 IF(@flag ='csv')    
 BEGIN    
SELECT distinct([DoctorId])        
      ,[name]        
      ,[phone]        
      ,[alternatePhone]        
      ,[DateOfBirth]        
      ,[email]        
      ,genderId        
      ,GenderName        
      ,[experince]        
      ,[image]        
      ,[address]        
      ,[cityId]        
      ,CityName        
      ,stateId        
      ,StateName      
      ,pincode        
      ,latitude       
      ,longitude        
      ,[countryId]        
      ,CountryName        
      ,companyid    
      ,companyname        
      ,skillcategoryId     
      ,skillcategoryName       
      ,onboardingcategory      
      ,onboardingcategoryName        
      ,[isf2f]        
      ,[istele]        
      ,[isvideo]        
   ,usertypeId        
   ,usertypeName        
   ,deleted        
   ,Award        
   ,Registration      
   ,CreatedById      
   ,CreatedByRole       
,SignatureImage    
,PAN    
,CertificateImage    
,ApprovForConsultation  --0 means false    
,isnull((select top 1 languages from #tempLanguage tl where DoctorId = d.[DoctorId]),'') as languages    
,isnull((select top 1 caseTypes from #tempCaseType tc where DoctorId = d.[DoctorId]),'') as casetypes    
,isnull((select top 1 qualifications from #tempQualifications tq where DoctorId =d.[DoctorId]),'') as Qualifications    
,isnull((select top 1 specilities from #tempSpecilities ts where DoctorId =d.[DoctorId]),'') as specialities    
,IsDoctorAvailable    
,CreatedByName 
,CreatedDate,ActivationDate,ProviderId,ProviderAddress,ProviderPincode,Slots,MRP
,DCPrice
 ,d.AppPriceGraded
 ,d.AppPriceMargin

,DoctorImageTaggingFlag
 from [tele_consultaion].#tempDoctor d where    
(@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or d.companyid = @companyId)    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))      
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
  and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,','))) 
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
  order by DoctorId    
 END    
   ELSE     
BEGIN     
   SELECT distinct([DoctorId])        
      ,[name]        
      ,[phone]        
      ,[alternatePhone]        
      ,[DateOfBirth]        
      ,[email]        
      ,genderId        
      ,GenderName        
      ,[experince]        
      ,[image]        
      ,[address]        
      ,[cityId]        
      ,CityName        
      ,stateId        
      ,StateName      
      ,pincode        
      ,latitude       
      ,longitude        
      ,[countryId]        
      ,CountryName        
      ,companyid    
      ,companyname        
      ,skillcategoryId     
      ,skillcategoryName       
      ,onboardingcategory      
      ,onboardingcategoryName        
      ,[isf2f]        
      ,[istele]        
      ,[isvideo]        
   ,usertypeId        
   ,usertypeName        
   ,deleted        
   ,Award        
   ,Registration      
   ,CreatedById      
   ,CreatedByRole       
,SignatureImage    
,PAN    
,CertificateImage    
,ApprovForConsultation  --0 means false    
,isnull((select top 1 languages from #tempLanguage tl where DoctorId = d.[DoctorId]),'') as languages    
,isnull((select top 1 caseTypes from #tempCaseType tc where DoctorId = d.[DoctorId]),'') as casetypes    
,isnull((select top 1 qualifications from #tempQualifications tq where DoctorId =d.[DoctorId]),'') as Qualifications    
,isnull((select top 1 specilities from #tempSpecilities ts where DoctorId =d.[DoctorId]),'') as specialities    
,IsDoctorAvailable    
,CreatedByName  
,CreatedDate,ActivationDate,ProviderId,ProviderAddress,ProviderPincode,Slots,MRP
,DCPrice
 ,d.AppPriceGraded
 ,d.AppPriceMargin

,DoctorImageTaggingFlag 
from [tele_consultaion].#tempDoctor d    
  Where     
  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or d.companyid = @companyId)     
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))      
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
    
  and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
  order by [DoctorId]     
   offset @RecordPerPage * (@PageNumber-1)rows    
  FETCH NEXT @RecordPerPage rows only    
 END    
 SELECT @TotalDCount = count(distinct(DoctorId))      
 from      
[tele_consultaion].#tempDoctor where  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
 SELECT @ActiveDCount = count(distinct(DoctorId))      
 from      
[tele_consultaion].#tempDoctor where  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
  and deleted = 0    
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
 SELECT @inActiveDCount = count(distinct(DoctorId))      
 from      
[tele_consultaion].#tempDoctor where  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
  and deleted = 1    
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
 Select @ActiveDCount as activeDCount,@inActiveDCount as inActiveDCount,@TotalDCount as totalCount    
End    
ELSE    
Begin    
 IF(@flag ='csv')    
 BEGIN    
SELECT distinct([DoctorId])        
      ,[name]        
      ,[phone]        
      ,[alternatePhone]        
      ,[DateOfBirth]        
      ,[email]        
      ,genderId        
      ,GenderName        
      ,[experince]        
      ,[image]        
      ,[address]        
      ,[cityId]        
      ,CityName        
      ,stateId        
      ,StateName      
      ,pincode        
      ,latitude       
      ,longitude        
      ,[countryId]        
      ,CountryName        
      ,companyid    
      ,companyname        
      ,skillcategoryId     
      ,skillcategoryName       
      ,onboardingcategory      
      ,onboardingcategoryName        
      ,[isf2f]        
      ,[istele]        
      ,[isvideo]        
   ,usertypeId        
   ,usertypeName        
   ,deleted        
   ,Award        
   ,Registration      
   ,CreatedById      
   ,CreatedByRole       
   ,CreatedByName    
,SignatureImage,    
PAN,    
CertificateImage,    
ApprovForConsultation  --0 means false    
,isnull((select top 1 languages from #tempLanguage tl where DoctorId = d.[DoctorId]),'') as languages    
,isnull((select top 1 caseTypes from #tempCaseType tc where DoctorId = d.[DoctorId]),'') as casetypes    
,isnull((select top 1 qualifications from #tempQualifications tq where DoctorId =d.[DoctorId]),'') as Qualifications    
,isnull((select top 1 specilities from #tempSpecilities ts where DoctorId =d.[DoctorId]),'') as specialities    
,IsDoctorAvailable,CreatedDate,ActivationDate,ProviderId,ProviderAddress,ProviderPincode,Slots,MRP
,DCPrice
 ,d.AppPriceGraded
 ,d.AppPriceMargin

,DoctorImageTaggingFlag 
from  [tele_consultaion].#tempDoctor d where    
 (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or d.companyid = @companyId)
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))      
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
  and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
  and (@FromActivationDate is null and @ToActivationDate is null OR convert(varchar,ActivationDate,106)  Between  convert(varchar,@FromActivationDate,106) and convert(varchar,@ToActivationDate,106))    
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
  order by [DoctorId]     
 END    
   ELSE     
 BEGIN     
    SELECT distinct([DoctorId])        
      ,[name]        
      ,[phone]        
      ,[alternatePhone]        
      ,[DateOfBirth]        
      ,[email]        
      ,genderId        
      ,GenderName        
      ,[experince]        
      ,[image]        
      ,[address]        
      ,[cityId]        
      ,CityName        
      ,stateId        
      ,StateName      
      ,pincode        
      ,latitude       
      ,longitude        
      ,[countryId]        
      ,CountryName        
      ,companyid    
      ,companyname        
      ,skillcategoryId     
      ,skillcategoryName       
      ,onboardingcategory      
      ,onboardingcategoryName        
      ,[isf2f]        
      ,[istele]        
      ,[isvideo]        
   ,usertypeId        
   ,usertypeName        
   ,deleted        
   ,Award        
   ,Registration      
   ,CreatedById      
   ,CreatedByRole       
   ,CreatedByName    
,SignatureImage,    
PAN,    
CertificateImage,    
ApprovForConsultation  --0 means false    
,isnull((select top 1 languages from #tempLanguage tl where DoctorId = d.[DoctorId]),'') as languages    
,isnull((select top 1 caseTypes from #tempCaseType tc where DoctorId = d.[DoctorId]),'') as casetypes    
,isnull((select top 1 qualifications from #tempQualifications tq where DoctorId =d.[DoctorId]),'') as Qualifications    
,isnull((select top 1 specilities from #tempSpecilities ts where DoctorId =d.[DoctorId]),'') as specialities    
,IsDoctorAvailable 
,CreatedDate,ActivationDate,ProviderId,ProviderAddress,ProviderPincode,Slots,MRP
,DCPrice
 ,d.AppPriceGraded
 ,d.AppPriceMargin

,DoctorImageTaggingFlag   
 from  [tele_consultaion].#tempDoctor d where    
  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or d.companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))      
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
  --and (@FromDate is null and @ToDate is null OR CreatedDate  Between  @FromDate and @ToDate)    
  --and (@FromActivationDate is null and @ToActivationDate is null OR ActivationDate  Between  @FromActivationDate and @ToActivationDate)    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
    and (@FromActivationDate is null and @ToActivationDate is null OR convert(varchar,ActivationDate,106)  Between  convert(varchar,@FromActivationDate,106) and convert(varchar,@ToActivationDate,106))    
and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
  order by [DoctorId]     
   offset @RecordPerPage * (@PageNumber-1)rows    
  FETCH NEXT @RecordPerPage rows only    
 END    
    
 SELECT @TotalDCount = count(distinct(DoctorId)) from      
[tele_consultaion].#tempDoctor where (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
    and (@FromActivationDate is null and @ToActivationDate is null OR convert(varchar,ActivationDate,106)  Between  convert(varchar,@FromActivationDate,106) and convert(varchar,@ToActivationDate,106))    
   and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
SELECT @ActiveDCount = count(distinct(DoctorId))       
 from      
[tele_consultaion].#tempDoctor where  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))      
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
    and (@FromActivationDate is null and @ToActivationDate is null OR convert(varchar,ActivationDate,106)  Between  convert(varchar,@FromActivationDate,106) and convert(varchar,@ToActivationDate,106))    
 and deleted =0    
   and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
 SELECT @inActiveDCount = count(distinct(DoctorId))       
 from      
[tele_consultaion].#tempDoctor where  (@name is null or name like '%'+@name+'%')      
  and (@phone is null or phone like '%'+@phone+'%')      
  and (@status is null or deleted = @status)    
  and (@companyId is null or companyid = @companyId)      
    
  and (@languageIds is null or languageId in (select * from fnSplit(@languageIds,',')))    
  and (@companyIds is null or CompanyId in (select * from fnSplit(@companyIds,',')))      
    
  and (@caseTypeId is null or casetypeId = @caseTypeId)      
  --and (@companyName is null or cm.companyname like '%'+@companyName+'%')     
    and (@specilyIds is null or specialtyId in (select * from fnSplit(@specilyIds,',')))   
  and (@QualificationIds is null or qualificationId in (select * from fnSplit(@QualificationIds,',')))      
    
  and (@FromDate is null and @ToDate is null OR convert(varchar,CreatedDate,106)  Between  convert(varchar,@FromDate,106) and convert(varchar,@ToDate,106))     
    and (@FromActivationDate is null and @ToActivationDate is null OR convert(varchar,ActivationDate,106)  Between  convert(varchar,@FromActivationDate,106) and convert(varchar,@ToActivationDate,106))    
 and deleted =1    
  and (@IsDoctorAvailable is null or IsDoctorAvailable=@IsDoctorAvailable)    
    
 Select @ActiveDCount as activeDCount,@inActiveDCount as inActiveDCount,@TotalDCount as totalCount    
    
End    
drop table [tele_consultaion].#tempDoctor    
drop table [tele_consultaion].#tempCaseType    
drop table [tele_consultaion].#tempLanguage    
drop table [tele_consultaion].#tempQualifications    
drop table [tele_consultaion].#tempSpecilities    
END 