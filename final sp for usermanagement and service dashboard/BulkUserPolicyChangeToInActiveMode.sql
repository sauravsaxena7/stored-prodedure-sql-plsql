USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[BulkUserChangeToInActiveMode]    Script Date: 12/6/2023 12:06:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [BulkUserChangeToInActiveMode]  '[{"Client Name ":"asdad","PolicyNo":123123123.0,"Emp No ":12312.0,"Status":"Active ","UserLoginId":38778.0,"Remarks":"Inactive by Raja"}]','Admin'
ALTER PROCEDURE [dbo].[BulkUserChangeToInActiveMode] 
@requestJson nvarchar(max)=null,
@Admin varchar(50)=null
AS
BEGIN
   DECLARE @SubCode INT=200,@StatusCode BIT=1,@Message VARCHAR(10)='Successfull'; 
   CREATE TABLE  #GlobalLogResultBulkUserInActive
    (
     ColumnName varchar(100),
     Status int, 
     Success varchar(100),
	 Message varchar(200),
	 Remarks varchar(300),
	 EmpNo varchar(100),
	 ClientId bigint,
	 ClientName varchar(200),
	 UserLoginId bigint,
	 PolicyNo varchar(200),
	 UserStatus varchar(100)
     )
   BEGIN TRY --TRY BLOCK BEGIN HERE

         BEGIN TRANSACTION--TRANSACTION BEGIN HERE 
	        PRINT 'LOLA'
			IF ISNULL(@requestJson,'')<>''
			   BEGIN--ALGORITHM START HERE
			      CREATE TABLE #BulkUserLoginTable(UserLoginId varchar(50) null, Remarks varchar(200) null,PolicyNo varchar(200) null);
				  INSERT INTO #BulkUserLoginTable(UserLoginId,Remarks,PolicyNo) 
				         SELECT UserLoginId,Remarks,PolicyNo 
				         FROM OPENJSON(@requestJson) WITH (UserLoginId varchar(50) '$.UserLoginId',Remarks varchar(200) '$.Remarks',PolicyNo varchar(200) '$.PolicyNo');

				  WHILE EXISTS (SELECT * FROM #BulkUserLoginTable)
				     BEGIN--SELECT * from #BulkUserLoginTable LOOP START HERE
					    --SELECT TOP 1 UserLoginId,PolicyNo FROM #BulkUserLoginTable;
					    DECLARE @userloginid varchar(50)
						DECLARE @remarks varchar(50)
						DECLARE @policyNo varchar(200)
					    SELECT TOP (1) @userloginid=UserLoginId FROM #BulkUserLoginTable;
						 SELECT TOP (1) @remarks=Remarks FROM #BulkUserLoginTable;
						 SELECT TOP (1) @policyNo=PolicyNo FROM #BulkUserLoginTable;
						 
						 PRINT'UserloginId:-'+@userloginid
						 PRINT'@Admin:-'+@Admin
						 PRINT'@remarks:-'+@remarks
						 print'@policyNo:-'+@policyNo

					    INSERT INTO #GlobalLogResultBulkUserInActive  EXEC [Change_Policy_Of_User_To_Inactive] @userloginid,@Admin,@remarks,@policyNo;

						DELETE TOP(1) FROM #BulkUserLoginTable

					 END--SELECT * from #BulkUserLoginTable LOOP END HERE
					 DROP TABLE #BulkUserLoginTable


			   END--ALGORITHM END HERE
	     COMMIT--TRANSACTION END HERE

   END TRY--TRY BLOCK END HERE
   BEGIN CATCH
      ROLLBACK
	  SET @SubCode=500;
	  SET @StatusCode=0;
	  SET @Message='Failed';
	SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
   END CATCH

   SELECT @StatusCode AS [Status],@SubCode AS SubCode,@Message AS [Message] ;
   SELECT * FROM #GlobalLogResultBulkUserInActive;
   DROP TABLE #GlobalLogResultBulkUserInActive;
END