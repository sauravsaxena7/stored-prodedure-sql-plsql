USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetLanguageByDoctor]    Script Date: 11/24/2023 1:10:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [tele_consultaion].[Usp_GetLanguageByDoctor]      
@doctorId int      
As      
      
begin      
---- language      
select distinct(dl.doctorId),dl.DoctorLanguageId,l.LanguageId,l.LanguageName from [tele_consultaion].DoctorSpecialty ds      
inner join [tele_consultaion].DoctorLanguage dl on dl.DoctorId=ds.doctorId      
inner join [tele_consultaion].[Language] l ON l.LanguageId=dl.languageId      
where dl.doctorId=@doctorId  and dl.Deleted = 0   
end 
