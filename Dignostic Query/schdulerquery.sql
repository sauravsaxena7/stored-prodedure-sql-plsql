select top 10 * from HAModuleUAT.tele_consultaion.Admin WHERE phone='8146657032'

select * from HAModuleUAT.ops.Admin where phone='8146657032'

ALTER Table HAModuleUAT.ops.Admin ADD  IsFreeAppointmentAdmin int;

ALTER Table HAModuleUAT.ops.Admin ADD UserLastRefreshedAt datetime;

ALTER Table HAModuleUAT.ops.Admin ADD  UserAvailableForBucketing int;

ALTER Table Appointment ADD AdminUserId BIGINT

ALTER Table Appointment ADD AppointmentAssignToAdminDateTime DATETIME

ALTER Table Appointment ADD AppointmentAssignBy VARCHAR(200)


ALTER Table AppointmentLog ADD AdminUserId BIGINT

ALTER Table AppointmentLog ADD AppointmentAssignToAdminDateTime DATETIME

ALTER Table AppointmentLog ADD AppointmentAssignBy VARCHAR(200)

--https://uat.healthassure.in/OpsPortalApi/api/OPD/GetCaseHistoryDetails?AppointmentId=103399

SELECT top 10 * FROM Appointment where AppointmentType='HC' and ScheduleStatus in (1,2,3,4,56,58,31)  order by 1 desc

Update Appointment Set AdminUserId=1 ,AppointmentAssignBy='saurav',AppointmentAssignToAdminDateTime='2024-03-12 17:08:19.643' where AppointmentId=103552

SELECT * FROM Appointment WHERe AppointmentId=103552

SELECT * FROM Appointment 

SELECT top 10 * FROM AppointmentDetails order by 1 desc

SELECT TOP 10 * FROM [HAPortalUAT].dbo.Provider ORDER BY 1 DESC

SELECT  top 10 * FROM [HAModuleUat].[ops].[RoleMapping] order by 1 desc;

SELECT * FROM Appointment where AppointmentId=103552
select * from [HAModuleUAT].[ops].AdminRole
ALTER TABLE [HAModuleUAT].[ops].AdminRole DROP COLUMN ProcessCaseType;
--EXEC sp_RENAME '[HAModuleUAT].[ops].AdminRole.ProcessAppointmentType', 'ProcessCaseTpe', 'COLUMN'
ALTER Table [HAModuleUAT].[ops].AdminRole ADD FacilityGroup VARCHAR(150)

UPDATE [HAModuleUAT].[ops].AdminRole SET FacilityGroup = 'Doctor Consultation' WHERE id=12

SELECT Count(AppointmentId) From Appointment where AdminUserId=a.id and ScheduleStatus not in (6,7,14)

select * from  [HAModuleUAT].[ops].AdminRole
--enum
select top 100 * from FacilitiesMaster where ProcessCode='DC'

SELECT * from StatusMaster
SELECT *From Appointment where AdminUserId=1 and ScheduleStatus not in (6,7,14)

SELECT * FROM AppointmentLog where AppointmentId=103571

select * from Appointment where caseNo='HA12032024BADFHA'

SELECT * FROM AppointmentLog 
	         WHERE  AppointmentId=@AppointmentId and ScheduleStatus=@SchduleStatus order by 1 desc;
