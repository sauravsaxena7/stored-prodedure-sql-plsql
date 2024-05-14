USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]    Script Date: 3/6/2024 4:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  --exec [dbo].[MarkOrUnMarkIsFreeAppointmentAdmin] 1, 1
  
ALTER  PROCEDURE [dbo].[ManualAppointmentAssignToAdmin]                        
@AdminId BIGINT=NULL,
@AppointmentId bigint =NULL,
@UserId bigint =null
AS                                                                    
BEGIN                                                                    
 SET NOCOUNT ON  
 DECLARE @Status int =0, @Message VARCHAR(100)='Admin or User Not Found.',@Success VARCHAR(100)='FALSE'
 DECLARE @AdminName VARCHAR(200)=NULL;

 SELECT @AdminName=name  from HAModuleUAT.ops.Admin where id=@AdminId and Deleted=0 and IsFreeAppointmentAdmin=@AdminId;

 DECLARE @UserName VARCHAR(200)=NULL;
 SELECT @UserName=name  from HAModuleUAT.ops.Admin where id=@AdminId and Deleted=0 and IsFreeAppointmentAdmin=@UserId;
 
 IF @AdminName IS NOT NULL and @UserName is not null
    BEGIN
	   Update Appointment set AdminUserId=@UserId,
	   AppointmentAssignToAdminDateTime=GETDATE()
	   ,AppointmentAssignBy=@AdminName where AppointmentId=@AppointmentId

	   DECLARE @SchduleStatus INT= NULL
	   SELECT @SchduleStatus= ScheduleStatus FROM Appointment where AppointmentId=@AppointmentId;

	   DECLARE @AppointmentLogId BIGINT =NULL
	   SELECT top 1 @AppointmentLogId = AppointmentLogId FROM AppointmentLog 
	         WHERE  AppointmentId=@AppointmentId and ScheduleStatus=@SchduleStatus;


       Update AppointmentLog set AdminUserId=@UserId,
	   AppointmentAssignToAdminDateTime=GETDATE()
	   ,AppointmentAssignBy=@AdminName where AppointmentLogId=@AppointmentLogId

	   SET @Status=1
	   SET @Success='TRUE'
	   SET @Message='Appointment Assign To User '+@UserName; 


      



	END

 SELECT @Status AS Status, @Message AS Message, @Success AS Success;
END