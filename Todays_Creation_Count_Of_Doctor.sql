USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Todays_Creation_Count_Of_Doctor]    Script Date: 11/27/2023 1:56:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [tele_consultaion].[Todays_Creation_Count_Of_Doctor] 
    
  
ALTER PROCEDURE [tele_consultaion].[Todays_Creation_Count_Of_Doctor]       
 
AS          
BEGIN          
 SET NOCOUNT ON;
 Declare @CountOfInComplete BigInt;
  Declare @CountOfActive BigInt;
  Declare @CountOfInActive BigInt;
  Declare @CountOfPriceUpdateDoctor BigInt;
  select @CountOfInComplete=count(*) from tele_consultaion.Doctor where DoctorDraft='Y' and CreatedDate between cast(getdate()-1 as Datetime) and cast(getdate() as Datetime) ;

  select @CountOfActive=count(*) from tele_consultaion.Doctor where (DoctorDraft<>'Y' or DoctorDraft is null) and deleted=0 and CreatedDate between cast(getdate()-1 as Datetime) and cast(getdate() as Datetime) ;

   select @CountOfPriceUpdateDoctor=count(*) from tele_consultaion.Doctor where (DoctorDraft<>'Y' or DoctorDraft is null) and deleted=0 and price_updateddate is not null and CreatedDate between cast(getdate()-1 as Datetime) and cast(getdate() as Datetime) ;
 
  select @CountOfInActive=count(*) from tele_consultaion.Doctor where (DoctorDraft<>'Y' or DoctorDraft is null) and deleted=1 and CreatedDate between cast(getdate()-1 as Datetime) and cast(getdate() as Datetime) ;

  SELECT @CountOfActive AS Today_Count_Of_Active_Doctor, @CountOfInActive AS Today_Count_Of_InActive_Doctor, @CountOfIncomplete AS Today_Count_Of_Incomplete_Doctor , @CountOfPriceUpdateDoctor AS Today_Count_Price_Updated_Doctor, (@CountOfActive+@CountOfIncomplete) AS Total_Count_Of_Active_And_InComplete_Doctor;
 
END