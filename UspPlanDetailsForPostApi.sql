USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspPlanDetailsForPostApi]    Script Date: 9/3/2023 7:22:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------AUTHOR-----
------SAURAV SUMAN----
------27/08/2023------


--EXEC UspPlanDetailsForPostApi '{"PlanName":"Demo Plan","PlanCode":"DEMOPLAN1","PlanAmount":"2004.00","ClinetId":292,"ClientName":"ACE","FromDate":"2021-04-17T10:56:04.49","Todate":"2023-03-09T10:53:53.08","NoOfEmployees":4000,"WaitingPeriod":12,"Gender":"F","PlanValidity":"1","IsMidTermValidity":"Y","MidTermValidity":"1","LoginBy":"Email","InvoiceType":"HA","IsInsuranceBenefit":"Y","TypeCoverage":"Family","MaxMemberCount":"4","AdultCount":"2","AdultMinAge":"21","AdultMaxAge":"60","ChlidCount":"2","ChlidMinAge":"21","ChlidMaxAge":"60","WelcomeEmailer":"<!DOCTYPE html>\r\n<html>\r\n<head>\r\n<title>Page Title</title>\r\n</head>\r\n<body>\r\n\r\n<h1>This is a Heading</h1>\r\n<p>This is a paragraph.</p>\r\n\r\n</body>\r\n</html>","IsEmail":"N","WelcomeEmailerTobeSent":"N","TransactionalEmailerTobeSent":"N","IsSMS":"N","WelcomeSmsTobeSent":"N","TransactionalSmsTobeSent":"N","IsWhatsApp":"N","WelcomeWhatsAppTobeSent":"N","TransactionalWhatsAppTobeSent":"N","COITobeSent":"N","Tnc":""}', '[{"Value":7,"Label":"Wife"},{"Value":10,"Label":"Father"},{"Value":8,"Label":"Son"},{"Value":9,"Label":"Daughter"}]', '[{"CNPLanInsuranceBenefitId":2,"Benefit":"Hospicash","SumInsuredAmount":"1000","InsurerName":"PKPKPK","NomineeRequired":"N","BenefitImage":"","InsuracneBenefitId":1},{"CNPLanInsuranceBenefitId":3,"Benefit":"IPD"," SumInsuredAmount":"1000","InsurerName":"PKPKPK","NomineeRequired":"N","BenefitImage":"","InsuracneBenefitId":3},{"CNPLanInsuranceBenefitId":4,"Benefit":"EMI Protect","SumInsuredAmount":"1000","InsurerName":"PKPKPK","NomineeRequired":"N","BenefitImage":"","InsuracneBenefitId":6}]';


ALTER PROCEDURE [dbo].[UspPlanDetailsForPostApi]    
   @planDetailsjson  NVARCHAR(MAX) ,
   @planDetailsRelationIdsJson  NVARCHAR(MAX) ,
   @planDetialsInsuraceBenifitsJson  NVARCHAR(MAX) 
  
AS    
BEGIN 
  ---SIMPLE PLANDETAILS START---
     DECLARE @PlanName Varchar(350)=NULL, @PlanCode Varchar(250)=NULL, @PlanAmount DECIMAL=NULL,
	         @ClinetId INT=NULL, @ClientName Varchar(300)=NULL, @fromDate DATETIME=NULL,
			 @Todate DATETIME=NULL,  @NoOfEmployees INT=NULL,  @WaitingPeriod INT=NULL, @Gender CHAR=NULL,
			 @PlanValidity INT=NULL,  @IsMidTermValidity CHAR=NULL, @MidTermValidity INT=NULL,
			 @LoginBy VARCHAR(100), @InvoiceType VARCHAR(100), @IsInsuranceBenefit VARCHAR(1) = NULL,
			 @InsuraceBenifits VARCHAR(1)=NULL, @TypeCoverage VARCHAR(100)=NULL, @MaxMemberCount INT=NULL,
			 @AdultCount INT=NULL, @AdultMinAge INT=NULL, @AdultMaxAge INT=NULL, @ChlidCount INT=NULL,
			 @ChlidMinAge INT=NULL, @ChlidMaxAge INT=NULL, @RelationIds VARCHAR(1)=NULL, @WelcomeEmailer VARCHAR(MAX)=NULL,
			 @IsEmail CHAR=NULL, @WelcomeEmailerTobeSent CHAR=NULL, @TransactionalEmailerTobeSent CHAR=NULL, @IsSMS CHAR=NULL,
			 @WelcomeSmsTobeSent CHAR=NULL, @TransactionalSmsTobeSent CHAR=NULL, @IsWhatsApp CHAR=NULL, 
			 @WelcomeWhatsAppTobeSent CHAR=NULL, @TransactionalWhatsAppTobeSent CHAR=NULL, @CoiTobeSent CHAR =NULL,
			 @Tnc VARCHAR(300)=NULL;

     
	  SELECT PlanName, PlanCode , PlanAmount ,
	         ClinetId , ClientName , FromDate ,
			 Todate,  NoOfEmployees , WaitingPeriod, Gender,
			 PlanValidity,  IsMidTermValidity , MidTermValidity,
			 LoginBy, InvoiceType , IsInsuranceBenefit,
			 InsuraceBenifits , TypeCoverage , MaxMemberCount,
			 AdultCount, AdultMinAge, AdultMaxAge, ChlidCount,
			 ChlidMinAge , ChlidMaxAge , RelationIds, WelcomeEmailer,
			 IsEmail , WelcomeEmailerTobeSent, TransactionalEmailerTobeSent , IsSMS ,
			 WelcomeSmsTobeSent, TransactionalSmsTobeSent , IsWhatsApp , 
			 WelcomeWhatsAppTobeSent, TransactionalWhatsAppTobeSent , CoiTobeSent ,
			 Tnc
	  INTO #PlanDetialsList FROM OPENJSON(@planDetailsjson) WITH  
	  (
	     PlanName Varchar(350) '$.PlanName', 
		 PlanCode Varchar(250) '$.PlanCode', 
		 PlanAmount DECIMAL '$.PlanAmount',
	     ClinetId INT '$.ClinetId', 
	     ClientName Varchar(300) '$.ClientName', 
		 FromDate DATETIME '$.FromDate',
		 Todate DATETIME '$.Todate', 
		 NoOfEmployees INT '$.NoOfEmployees', 
		 WaitingPeriod INT '$.WaitingPeriod',
		 Gender CHAR '$.Gender',
		 PlanValidity INT '$.PlanValidity', 
		 IsMidTermValidity CHAR '$.IsMidTermValidity', 
		 MidTermValidity INT '$.MidTermValidity',
		 LoginBy VARCHAR(100) '$.LoginBy',
		 InvoiceType VARCHAR(100) '$.InvoiceType',
		 IsInsuranceBenefit VARCHAR(1) '$.IsInsuranceBenefit',
		 InsuraceBenifits VARCHAR(1) '$.InsuraceBenifits',
		 TypeCoverage VARCHAR(100) '$.TypeCoverage',
		 MaxMemberCount INT '$.MaxMemberCount',
		 AdultCount INT '$.AdultCount',
		 AdultMinAge INT '$.AdultMinAge',
		 AdultMaxAge INT '$.AdultMaxAge',
		 ChlidCount INT '$.ChlidCount',
		 ChlidMinAge INT '$.ChlidMinAge',
		 ChlidMaxAge INT '$.ChlidMaxAge',
		 RelationIds VARCHAR(1) '$.RelationIds',
		 WelcomeEmailer VARCHAR(MAX) '$.WelcomeEmailer',
		 IsEmail CHAR  '$.IsEmail',
		 WelcomeEmailerTobeSent CHAR '$.WelcomeEmailerTobeSent', 
		 TransactionalEmailerTobeSent CHAR '$.TransactionalEmailerTobeSent', 
		 IsSMS CHAR '$.IsSMS',
		 WelcomeSmsTobeSent CHAR '$.WelcomeSmsTobeSent',
		 TransactionalSmsTobeSent CHAR '$.TransactionalSmsTobeSent',
		 IsWhatsApp CHAR '$.IsWhatsApp', 
		 WelcomeWhatsAppTobeSent CHAR '$.WelcomeWhatsAppTobeSent',
		 TransactionalWhatsAppTobeSent CHAR '$.TransactionalWhatsAppTobeSent', 
		 CoiTobeSent CHAR  '$.CoiTobeSent',
		 Tnc VARCHAR(300) '$.Tnc'
	  )


	  SELECT * FROM #PlanDetialsList;

  ---SIMPLE PLANDETIALS END---


  ---Plandetials Going To Play With Relation---
  ---RELATION PART START---
     
	 DECLARE @RelationId INT=NULL, @Relation VARCHAR(100) = NULL;


	 SELECT RelationId, Relation

	 INTO #PlanDetialsRelationIdsList FROM OPENJSON(@planDetailsRelationIdsJson) WITH 
	 (
	   RelationId INT '$.Value',
	   Relation VARCHAR(100) '$.Label'
	 );

	 SELECT * FROM #PlanDetialsRelationIdsList;



  ---RELATION PART END---


  ---InsuraceBenifits PART START---
     
	 DECLARE @CNPLanInsuranceBenefitId BIGINT = NULL, @Benefit VARCHAR(500)=NULL, @SumInsuredAmount VARCHAR(300)=NULL,
	         @InsurerName VARCHAR(250)=NULL, @NomineeRequired BIT = NULL, @BenefitImage VARCHAR(250)=NULL, @InsuracneBenefitId INT =NULL;
	 
	 SELECT CNPLanInsuranceBenefitId , Benefit , SumInsuredAmount ,
	         InsurerName , NomineeRequired , BenefitImage , InsuracneBenefitId 
	 INTO #PlanDetialsInsuranceBenefitList FROM OPENJSON(@planDetialsInsuraceBenifitsJson) WITH 
	 (
	    CNPLanInsuranceBenefitId BIGINT '$.CNPLanInsuranceBenefitId',
		Benefit VARCHAR(500) '$.Benefit', 
		SumInsuredAmount VARCHAR(300) '$.SumInsuredAmount',
	    InsurerName VARCHAR(250) '$.InsurerName',
		NomineeRequired CHAR '$.NomineeRequired',
		BenefitImage VARCHAR(250) '$.BenefitImage',
		InsuracneBenefitId INT '$.InsuracneBenefitId'
	 );

	 SELECT * FROM #PlanDetialsInsuranceBenefitList;
			 

  ---InsuraceBenifits PART END-----





END