USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [ops].[Usp_AdminGetAll]    Script Date: 3/9/2024 3:55:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [ops].[Usp_AdminGetAll]    
 @name varchar(50)      
,@phone varchar(50)      
,@status int   
,@fromDate DateTime=null  
,@toDate DateTime=null  
,@ComapnyId int  
,@PageNumber int = 1  --page Number  
,@RecordPerPage int = 10  
,@flag varchar(10)=null --csv  
  
AS      
BEGIN      
 SET NOCOUNT ON;    
set @PageNumber = isnull(@PageNumber, 1)--page Number  
set @RecordPerPage = isnull(@RecordPerPage, 10)--page Number  
 If(@flag = 'csv')  
  BEGIN  
   SELECT Id      
      , A.name      
      ,A.Phone      
      ,ISNULL(A.[email],'') as Email      
      ,ISNULL(A.[alternateMobile],'') as alternateMobile      
      ,ISNULL(A.[pincode],'') as pincode      
      ,ISNULL(A.[address],'') as [address]      
     ,ISNULL(A.genderId,0) as genderId      
      ,G.GenderName      
      ,ISNULL(A.countryId,0) as countryId      
      ,C.CountryName      
      ,ISNULL(A.stateId,0) as stateId      
      ,S.StateName      
      ,ISNULL(A.cityId,0) as cityId      
      ,CC.CityName      
      ,ISNULL(A.languageId,0) as languageId      
      ,L.LanguageName 
	  ,A.CreatedDate
      ,isnull(  CASE            
    --WHEN A.CreatedByRole= 2 THEN (select [name] from tele_consultaion.Doctor where doctorId = c.CreatedBy)            
    WHEN A.CreatedByRole =1 THEN (select [name] from tele_consultaion.[Admin] where id = c.CreatedBy)               
          
   END     
      
   ,'') as CreatedByName    
      , --added      
     A.CreatedBy as CreatedById          
     ,isnull(A.CreatedByRole,'' )as CreatedByRole        
      ,A.Deleted    
      ,A.IsSuperAdmin  
      ,isnull(A.companyId,0) as companyId  
      ,isnull(CO.companyname,'') as companyname ,
	  ISNULL(A.IsFreeAppointmentAdmin,0) AS IsFreeAppointmentAdmin,
	  A.UserLastRefreshedAt,
	  ISNULL(A.UserAvailableForBucketing,0) AS UserAvailableForBucketing
	 
     FROM [ops].[Admin] A      
     left join [ops].Gender G on G.GenderId=A.genderId      
     left join [ops].Country C on C.CountryId=A.CountryId      
     left join [ops].State S on S.stateId=A.stateid      
     left join [ops].City CC on CC.CityId=A.cityId      
     left join [ops].Language L on L.LanguageId=A.languageId    
     left join [ops].Company CO on A.companyId =CO.CompanyId    
     Where (@ComapnyId is  null or A.companyId =@ComapnyId)  
     and (@name is null or A.[name] like '%'+@name+'%')      
     and (@phone is null or A.[phone] like '%'+@phone+'%')      
     and (@status is null or A.deleted =@status)     
      and (@FromDate is null and @ToDate is null OR A.CreatedDate  Between  @FromDate and @ToDate)    
  
  END  
 ELSE  
  BEGIN  
   SELECT Id      
   , A.name      
   ,A.Phone      
   ,ISNULL(A.[email],'') as Email      
   ,ISNULL(A.[alternateMobile],'') as alternateMobile      
   ,ISNULL(A.[pincode],'') as pincode      
   ,ISNULL(A.[address],'') as [address]      
   ,ISNULL(A.genderId,0) as genderId      
   ,G.GenderName      
   ,ISNULL(A.countryId,0) as countryId      
   ,C.CountryName      
   ,ISNULL(A.stateId,0) as stateId      
   ,S.StateName      
   ,ISNULL(A.cityId,0) as cityId      
   ,CC.CityName      
   ,ISNULL(A.languageId,0) as languageId      
   ,L.LanguageName 
   ,A.CreatedDate
   ,isnull(  CASE            
   --WHEN A.CreatedByRole= 2 THEN (select [name] from tele_consultaion.Doctor where doctorId = c.CreatedBy)            
   WHEN A.CreatedByRole =1 THEN (select [name] from tele_consultaion.[Admin] where id = c.CreatedBy)                
   --        
   END     
      
   ,'') as CreatedByName    
   , --added      
   A.CreatedBy as CreatedById          
   ,isnull(A.CreatedByRole,'' )as CreatedByRole        
   ,A.Deleted    
   ,A.IsSuperAdmin  
   ,isnull(A.companyId,0) as companyId  
   ,isnull(CO.companyname,'') as companyname,
   ISNULL(A.IsFreeAppointmentAdmin,0) AS IsFreeAppointmentAdmin,
	  ISNULL(A.UserLastRefreshedAt,'1900-09-19 17:08:19.643') AS UserLastRefreshedAt,
	  ISNULL(A.UserAvailableForBucketing,0) AS UserAvailableForBucketing
   FROM [ops].[Admin] A      
   left join [ops].Gender G on G.GenderId=A.genderId      
   left join [ops].Country C on C.CountryId=A.CountryId      
   left join [ops].State S on S.stateId=A.stateid      
   left join [ops].City CC on CC.CityId=A.cityId      
   left join [ops].Language L on L.LanguageId=A.languageId    
   left join [ops].Company CO on A.companyId =CO.CompanyId    
   Where (@ComapnyId is null or A.companyId =@ComapnyId)  
   and (@name is null or A.[name] like '%'+@name+'%')      
   and (@phone is null or A.[phone] like '%'+@phone+'%')      
   and (@status is null or A.deleted =@status)     
   and (@FromDate is null and @ToDate is null OR A.CreatedDate  Between  @FromDate and @ToDate)    
   order by A.id  
   offset @RecordPerPage * (@PageNumber-1)rows  
   FETCH NEXT @RecordPerPage rows only  
  
  END  
  
   SELECT count(distinct(a.id)) as TotalCount    
     FROM [ops].[Admin] A      
     left join [ops].Gender G on G.GenderId=A.genderId      
     left join [ops].Country C on C.CountryId=A.CountryId      
     left join [ops].State S on S.stateId=A.stateid      
     left join [ops].City CC on CC.CityId=A.cityId      
     left join [ops].Language L on L.LanguageId=A.languageId    
     left join [ops].Company CO on A.companyId =CO.CompanyId    
     Where (@ComapnyId is null or A.companyId =@ComapnyId)  
     and (@name is null or A.[name] like '%'+@name+'%')      
     and (@phone is null or A.[phone] like '%'+@phone+'%')      
     and (@status is null or A.deleted =@status)     
      and (@FromDate is null and @ToDate is null OR A.CreatedDate  Between  @FromDate and @ToDate)    
  
  END