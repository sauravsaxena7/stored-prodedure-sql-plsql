USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetQualificationByDoctor]    Script Date: 11/24/2023 1:08:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [tele_consultaion].[Usp_GetQualificationByDoctor]    
@doctorId int    
As    
    
begin    
-- qualification    
select distinct(dq.doctorId),dq.DoctorQualificationId,q.QualificationId, q.name as QlName from [tele_consultaion].DoctorSpecialty ds    
inner join [tele_consultaion].DoctorQualification dq on dq.DoctorId=ds.doctorId    
inner join [tele_consultaion].Qualification q ON q.QualificationId=dq.qualificationId    
where dq.doctorId=  @doctorId  and dq.Deleted = 0
    
end 
