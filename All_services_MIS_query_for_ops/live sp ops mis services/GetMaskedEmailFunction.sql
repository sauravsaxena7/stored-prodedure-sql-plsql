USE [HaProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMaskedEmail]    Script Date: 5/25/2024 1:54:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--print [dbo].[GetMaskedEmail] ('nishikant.gupta@healthassure.in')
--print [dbo].[GetMaskedEmail] ('783hyuyj@glyuuy')
--print [dbo].[GetMaskedEmail] ('lola@yahooooo.in')
--print [dbo].[GetMaskedEmail] ('lola@ylo.in')
--print SUBSTRING('lola@yahoo.in',2, CHARINDEX('@', 'lola@yahoo.in')-2)
--print SUBSTRING('lola@yahoo.in',CHARINDEX('@', 'lola@yahoo.in')+2, CHARINDEX('.', 'lola@yahoo.in')-2)
ALTER FUNCTION [dbo].[GetMaskedEmail](@EMAIL varchar(400)) RETURNS VARCHAR(100) as
BEGIN  
  If [dbo].[ChkValidEmail](@EMAIL) = 0 return @EMAIL;

  DECLARE @LastOccurenceOFDOTIndex int = [dbo].[GetLastOccurCharIndex](@EMAIL,'.') 

  DECLARE @LeftStr varchar(255) = LEFT(@EMAIL, 1) + [dbo].[GetDynamicLentgthCharacters](LEN(SUBSTRING(@EMAIL,2,CHARINDEX('@', @EMAIL)-1))-1,'*') +'@'
  DECLARE @RightStr varchar(255) = SUBSTRING(@EMAIL,  @LastOccurenceOFDOTIndex -1, 10);
  DECLARE @MiddleStr Varchar(255) = REVERSE(LEFT(RIGHT(REVERSE(@EMAIL) , CHARINDEX('@', @EMAIL) +1), 1));
  
  
  DECLARE @RIT VARCHAR(300);
  DECLARE @Start int = CHARINDEX('@', @EMAIL)+2;
  
  DECLARE @lengthOfRequredSubstring int = @LastOccurenceOFDOTIndex-@Start-1;
 
  SET @RIT=SUBSTRING(@EMAIL,@Start,  abs(@lengthOfRequredSubstring));
  --PRINT '@RIT';
  --PRINT @RIT;
  
  RETURN @LeftStr+ @MiddleStr+ [dbo].[GetDynamicLentgthCharacters](LEN(  @RIT),'*')+ @RightStr
END 
