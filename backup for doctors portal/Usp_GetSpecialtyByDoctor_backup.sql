USE [HAModule]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_GetSpecialtyByDoctor]    Script Date: 11/24/2023 1:17:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [tele_consultaion].[Usp_GetSpecialtyByDoctor]    
@doctorId int    
As    
    
begin    
    
--Specialty    
select distinct(ds.doctorId),s.SpecialtyId,DoctorSpecialtyId, s.name as drSpName from [tele_consultaion].DoctorSpecialty ds    
inner join [tele_consultaion].Specialty s on s.SpecialtyId = ds.specialtyId    
where ds.doctorId = @doctorId and ds.Deleted = 0  
    
end 
