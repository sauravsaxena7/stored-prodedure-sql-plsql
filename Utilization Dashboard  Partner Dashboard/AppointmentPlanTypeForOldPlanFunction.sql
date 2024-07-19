USE [HAProduct]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMaskedEmail]    Script Date: 6/27/2024 3:12:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--1 CREDIT
--2 WALLET
--3 WALLET+CREDIT
--4 CREDIT+WALLET
--5 WALLET WITH CAPPING+CREDIT

CREATE FUNCTION [dbo].[AppointmentPlanTypeForOldPlan](@planType int,@ponits money, @partialpoints money) RETURNS VARCHAR(100) as
BEGIN  
  DECLARE @AppointmentPlanType VARCHAR(100) = '5'
  IF @planType=1
    BEGIN
	  SET @AppointmentPlanType = 'CREDIT';
	END
  ELSE IF @planType=2
    BEGIN
	   SET @AppointmentPlanType='WALLET';
	END
  ELSE IF @planType=3  or @planType=4
    BEGIN
	   IF (@ponits<>0 and @ponits is not null)
	      BEGIN
		    SET @AppointmentPlanType = 'WALLET';
		  END
      ELSE 
	    BEGIN
		   SET @AppointmentPlanType = 'CREDIT';
		END
	END
  
  RETURN ''
END 
