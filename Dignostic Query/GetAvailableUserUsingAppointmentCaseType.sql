USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]    Script Date: 3/6/2024 4:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec [dbo].[GetAvailableUserUsingAppointmentCaseType]  72669
  
ALTER  PROCEDURE [dbo].[GetAvailableUserUsingAppointmentCaseType]                        
@AppointmentId INT =NULL
AS                                                                    
BEGIN                                                                    
 SET NOCOUNT ON  
 DECLARE @FacilityGroup varchar(100)=NULL;
 --SELECT * from StatusMaster

 SELECT top 1 @FacilityGroup=FacilityGroup from FacilitiesMaster where ProcessCode =(select AppointmentType from Appointment  where AppointmentId=@AppointmentId)
 print @FacilityGroup
 SELECT a.id ,a.name,a.email,a.phone,rm.RoleId,ar.FacilityGroup,
    (SELECT Count(AppointmentId) From Appointment where AdminUserId=a.id and ScheduleStatus not in (6,7,14,19) and AppointmentType=(select AppointmentType from Appointment  where AppointmentId=@AppointmentId) ) as bucketCount
	   from HAModuleUAT.ops.Admin  a
	   join [HAModuleUat].[ops].[RoleMapping] rm on rm.UserId=a.id and rm.IsActive='Y'
	   join [HAModuleUAT].[ops].AdminRole ar on ar.Id=rm.RoleId and ar.FacilityGroup= @FacilityGroup
	   WHERE a.IsFreeAppointmentAdmin=0 and a.Deleted=0 and a.UserAvailableForBucketing=1
END