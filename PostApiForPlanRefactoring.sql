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
ALTER PROCEDURE [dbo].[UspPostApiForPlanRefactoring]    
   @planDetailsjson  NVARCHAR(MAX) ,
   @planDetialsInsuraceBenifitsJson  NVARCHAR(MAX) ,
   @planDetailsRelationIdsJson  NVARCHAR(MAX),
   @planBucketJson NVARCHAR(MAX)
  
AS    
BEGIN 
   -----SAVING CHILD PLAN DETAILS FOR POST API PLAN REFACTORING-----
   -----START OF PLANDETIALS-----
        EXEC UspPlanDetailsForPostApi @planDetailsjson, @planDetialsInsuraceBenifitsJson, @planDetailsRelationIdsJson
   -----END OF PLANDETAILS-------


   ----START OF BUCKETING IN NEW ERA----
       EXEC UspPostApiForPlanBuckets  @planBucketJson;
   ----END OF BUCKETING-----------------

END