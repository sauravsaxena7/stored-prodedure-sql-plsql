


USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspPostApiForPlanRefactoring]    Script Date: 9/1/2023 11:27:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------AUTHOR-----
------SAURAV SUMAN----
------27/08/2023------


--EXEC UspPostApiForPlanRefactoring 'LOLA', 'POLA', 'TOLA'
ALTER PROCEDURE [dbo].[UspPostApiForPlanBuckets]    
    @planBucketJson NVARCHAR(MAX)
  
AS    
BEGIN 
  PRINT @planBucketJson;

END