USE [HaProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspClientList_Test]    Script Date: 3/19/2024 2:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[UspClientList_Test] 'Corporate' ,'1'
ALTER Procedure [dbo].[UspClientList_Test]
@BUType varchar(100)=null,
@UserId BIGINT=NULL
AS
Begin
--51,60
if @UserId in (-1)
  begin
    Select ClientId,ClientName from client where IsActive = 'Y' and (@BUType is null OR BUType =@BUType)
	and ClientId=284
  end
ELSE 
  BEGIN
     Select ClientId,ClientName from client where IsActive = 'Y' and (@BUType is null OR BUType =@BUType)
  END
End