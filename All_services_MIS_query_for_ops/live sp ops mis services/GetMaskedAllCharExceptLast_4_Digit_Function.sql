USE [HaProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 5/22/2024 11:50:59 AM ******/
--[AUTHOR]:-SAURAV SUMAN
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GetMaskedAllCharExceptLast_4_Digit](@AlphaNumericData varchar(400)) RETURNS VARCHAR(100) as
BEGIN  
 --Declare @SubStringOfAlphaNumericData VARCHAR(400) =  SUBSTRING(@AlphaNumericData,1,LEN(@AlphaNumericData) - 2)
 --STUFF(@SubStringOfAlphaNumericData,1,LEN(@SubStringOfAlphaNumericData),'x')

  RETURN 
     [dbo].[GetDynamicLentgthCharacters](LEN(@AlphaNumericData) - 4,'X')
      + 
     SUBSTRING(@AlphaNumericData,LEN(@AlphaNumericData) - 3, LEN(@AlphaNumericData));

END 
