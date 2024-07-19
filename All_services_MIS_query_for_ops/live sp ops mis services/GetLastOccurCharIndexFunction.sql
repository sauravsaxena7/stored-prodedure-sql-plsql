

USE [HaProductsUAT]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 5/22/2024 11:50:59 AM ******/
--[AUTHOR]:-SAURAV SUMAN
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
---print [dbo].[GetLastOccurCharIndex]('...','.')
GO
ALTER FUNCTION [dbo].[GetLastOccurCharIndex](@input VARCHAR(400),@charItem char) RETURNS int as
BEGIN  
  
 declare @i int

select @i = 1
DECLARE @POS INT =0;

while @i < =len(@input)
begin
    
	if substring(@input, @i, 1) = @charItem
	begin
	SET @POS=@i
	end
    
	select @i = @i + 1
end


 RETURN  @POS;
     

END 
