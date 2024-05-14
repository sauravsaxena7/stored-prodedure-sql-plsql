USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspDiagnosticDashboardCount]    Script Date: 12/19/2023 11:05:41 AM ******/
SET ANSI_NULLS ON
GO
--EXEC [dbo].[uspDiagnosticDashboardCount] '2023-12-08', '2023-12-08'
 --SELECT cast('2023-07-08' as Datetime) AS datetimee
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[uspDiagnosticDashboardCount]
@fromDate DATETIME,
@toDate DATETIME
As
Begin
--select top 1 * from Appointment order by 1 desc
--select * from StatusMaster
select count(*) as 'DiagnosticDataCount' from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (1) and CreatedDate between CreatedDate and DATEADD(HOUR,-1,CreatedDate) --RequestTAT
Union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (1) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))--RequestOutOfTAT

union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (1) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))--DCConfirmation

union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (3,8) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))--Follow Up

union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (4) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (CreatedDate between cast(@fromDate as Datetime) and cast(@toDate as Datetime)))--Patial Show

union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (3) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))--No Show

union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (8) and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))
--Report Pending
union all
select count(*) from Appointment where  clientid<>0 and AppointmentType='HC' and ScheduleStatus in (3) 
and ((@fromDate IS NULL OR @toDate IS NULL) OR (cast(CreatedDate as Date) between cast(@fromDate as Date) and cast(@toDate as Date)))--Repeat Customer

End