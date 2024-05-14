USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[ManualAppointmentAssignToAdmin]    Script Date: 3/14/2024 8:51:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  --exec [dbo].[ManualAppointmentAssignToAdmin] 30, 72669,1
  
ALTER  PROCEDURE [dbo].[ManualAppointmentAssignToAdmin]                        
@AdminId BIGINT=NULL,
@AppointmentId bigint =NULL,
@UserId bigint =null
AS                                                                    
BEGIN                                                                    
 SET NOCOUNT ON  
 DECLARE @Status int =0, @Message VARCHAR(100)='Admin or User Not Found.',@Success VARCHAR(100)='FALSE'
 DECLARE @AdminName VARCHAR(200)=NULL;

 SELECT @AdminName=name  from HAModuleUAT.ops.Admin where id=@AdminId and Deleted=0 and IsFreeAppointmentAdmin=1;

 DECLARE @UserName VARCHAR(200)=NULL;
 SELECT @UserName=name  from HAModuleUAT.ops.Admin where id=@UserId and Deleted=0 and IsFreeAppointmentAdmin=0;
 
 IF @AdminName IS NOT NULL and @UserName is not null
    BEGIN
	   Update Appointment set AdminUserId=@UserId,
	   AppointmentAssignToAdminDateTime=GETDATE()
	   ,AppointmentAssignBy=@AdminName where AppointmentId=@AppointmentId

	   DECLARE @SchduleStatus INT= NULL
	   SELECT @SchduleStatus= ScheduleStatus FROM Appointment where AppointmentId=@AppointmentId;
	   
	   IF @SchduleStatus=56
	    BEGIN
		   SET @SchduleStatus = 1;
		END

	   DECLARE @AppointmentLogId BIGINT =NULL
	   SELECT top 1 @AppointmentLogId = AppointmentLogId FROM AppointmentLog 
	         WHERE  AppointmentId=@AppointmentId and ScheduleStatus=@SchduleStatus order by 1 desc;

 print'@SchduleStatus'
	   print @SchduleStatus
       print'AppointmentLogId'
	   print @AppointmentLogId
       Update AppointmentLog set AdminUserId=@UserId,
	   AppointmentAssignToAdminDateTime=GETDATE()
	   ,AppointmentAssignBy=@AdminName where AppointmentLogId=@AppointmentLogId

	   SET @Status=1
	   SET @Success='TRUE'
	   SET @Message='Appointment Assign To User '+@UserName; 


      



	END

 SELECT @Status AS Status, @Message AS Message, @Success AS Success;
END