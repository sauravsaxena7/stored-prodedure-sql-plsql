USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Change_Status_Of_User_To_Inactive]    Script Date: 12/6/2023 12:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[GetUserOperationHistory] '315','ll','ll'
ALTER PROCEDURE [dbo].[GetUserOperationHistory] 
@userloginId varchar(50)
As
BEGIN
   SELECT ISNULL(LastInActiveByAdminName,'') AS LastInActiveByAdminName,ISNULL(LastInActiveRemarksByAdmin,'') AS LastInActiveRemarksByAdmin,ISNULL(LastInActiveDateTime,CAST('1900-01-01 17:00:00.597' AS datetime)) AS LastInActiveDateTime from UserLogin where UserLoginId=@userloginId;
END