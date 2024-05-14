USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetQCCaseTypeByDoctor]    Script Date: 11/24/2023 1:26:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [tele_consultaion].[Usp_GetQCCaseTypeByDoctor]        
@doctorId int        
As        
        
begin        
       
select distinct(dc.doctorId),dc.DoctorCasetypeId,c.CaseTypeId,c.name as CaseTypeName,dc.CaseTypePriority from [tele_consultaion].DoctorSpecialty ds        
inner join [tele_consultaion].DoctorCasetype dc on dc.DoctorId=ds.doctorId        
inner join [tele_consultaion].CaseType c ON c.CaseTypeId=dc.casetypeId        
where dc.doctorId=@doctorId  and dc.Deleted = 0  and c.name like '%_QC%'   
order by dc.CaseTypePriority
end   

