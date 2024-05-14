USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]    Script Date: 3/6/2024 4:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  --exec [dbo].[MarkOrUnMarkIsFreeAppointmentAdmin] 1, 1
  
ALTER  PROCEDURE [dbo].[MarkOrUnMarkIsFreeAppointmentAdmin]                        
@AdminId BIGINT=NULL,
@Flag INT =NULL
AS                                                                    
BEGIN                                                                    
 SET NOCOUNT ON  
 DECLARE @Status int =0, @Message VARCHAR(100)='Admin Not Found.',@Success VARCHAR(100)='FALSE'
 DECLARE @UserId BIGINT=NULL;
 SELECT @UserId=id  from HAModuleUAT.ops.Admin where id=@AdminId and Deleted=0;
 IF @UserId IS NOT NULL
    BEGIN
	   Update  HAModuleUAT.ops.Admin SET IsFreeAppointmentAdmin=@Flag where id=@UserId;
	   SELECT @Message = CASE WHEN @Flag=1 then 'Hey! , This User is free to find all Appointments.' ELSE 'Hey! , This User is only authorize to find their own Appointments.' END
	   SET @Status=1
	   SET @Success='TRUE';
	END

 SELECT @Status AS Status, @Message AS Message, @Success AS Success;
END