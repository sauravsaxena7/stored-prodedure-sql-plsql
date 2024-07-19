USE [HAProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 5/22/2024 11:50:59 AM ******/
--[AUTHOR]:-SAURAV SUMAN
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GetMaskedSimpleAlphaNumberData](@AlphaNumericData varchar(400)) RETURNS VARCHAR(100) as
BEGIN     
  RETURN SUBSTRING(@AlphaNumericData,1,3) + 
      [dbo].[GetDynamicLentgthCharacters](LEN(@AlphaNumericData) - 6,'X') + 
     SUBSTRING(@AlphaNumericData,LEN(@AlphaNumericData) - 2, LEN(@AlphaNumericData));

END 
