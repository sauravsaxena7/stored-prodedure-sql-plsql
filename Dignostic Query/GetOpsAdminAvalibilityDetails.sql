USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[USPGETBookingAppointmentDetailsFor_Diagnostics]    Script Date: 3/6/2024 4:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec [dbo].[GetOpsAdminAvalibilityDetails] 1
  
ALTER  PROCEDURE [dbo].[GetOpsAdminAvalibilityDetails]                        
@AdminId BIGINT=NULL
AS                                                                    
BEGIN                                                                    
 SET NOCOUNT ON  
 SELECT id,UserLastRefreshedAt,UserAvailableForBucketing,IsFreeAppointmentAdmin FROM HAModuleUAT.ops.Admin where id=@AdminId and Deleted=0
END