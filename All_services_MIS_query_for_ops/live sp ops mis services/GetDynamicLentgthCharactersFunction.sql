USE [HaProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 5/22/2024 11:50:59 AM ******/
--[AUTHOR]:-SAURAV SUMAN
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GetDynamicLentgthCharacters](@dynamicLength bigint,@charItem char) RETURNS VARCHAR(400) as
BEGIN  
  
  DECLARE @DynamicCharacterString Varchar(400)='';
  WHILE LEN(@DynamicCharacterString) < @dynamicLength  
 BEGIN  
   
  SET @DynamicCharacterString = @DynamicCharacterString + @charItem;  
 END;  
 RETURN @DynamicCharacterString;
     

END 
