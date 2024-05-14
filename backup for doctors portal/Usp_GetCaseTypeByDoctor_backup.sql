USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetCaseTypeByDoctor]    Script Date: 11/24/2023 1:20:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [tele_consultaion].[Usp_GetCaseTypeByDoctor]        
@doctorId int        
As        
        
begin        
---- [tele_consultaion].[DoctorCasetype]        
select distinct(dc.doctorId),dc.DoctorCasetypeId,c.CaseTypeId,c.name as CaseTypeName from [tele_consultaion].DoctorSpecialty ds        
inner join [tele_consultaion].DoctorCasetype dc on dc.DoctorId=ds.doctorId        
inner join [tele_consultaion].CaseType c ON c.CaseTypeId=dc.casetypeId        
where dc.doctorId=@doctorId  and dc.Deleted = 0  and c.name not like '%_QC%'   
end   
