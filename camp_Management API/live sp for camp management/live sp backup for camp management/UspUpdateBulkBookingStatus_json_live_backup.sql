USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspUpdateBulkBookingStatus_json]    Script Date: 1/25/2024 3:34:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- EXEC [UspUpdateBulkBookingStatus_json]    ''

-- =============================================  
ALTER PROCEDURE [dbo].[UspUpdateBulkBookingStatus_json]  

 @CampMgmtUpdateBulkAppointmentStatus  NVARCHAR(MAX)  

AS  
BEGIN  
  SET NOCOUNT ON;  

   CREATE TABLE  ##GlobalLogResultCampBookingStatus
    (
     ColumnName varchar(100),
     Status int, 
     Success varchar(100),
	 Message varchar(Max)
     )

  DECLARE @CaseNo varchar(100), @schedulestatus VARCHAR(200), @Remark varchar(100)=NULL,@UploadedBy varchar(100)=NULL

  DECLARE @SubCode INT=200,@StatusCode BIT=1,@Message VARCHAR(MAX)='Successfull'; 

  IF ISNULL(@CampMgmtUpdateBulkAppointmentStatus ,'')<>''
       BEGIN
	    
		       SELECT CaseNo,schedulestatus,Remark ,UploadedBy
		       
		       INTO #UpdateAppointmentstatus FROM OPENJSON(@CampMgmtUpdateBulkAppointmentStatus ) WITH
		       (
		       
		       CaseNo VARCHAR(200) '$.CaseNo', 
		       schedulestatus VARCHAR(200) '$.schedulestatus',
		       Remark VARCHAR(200) '$.Remark',
			   UploadedBy VARCHAR(200) '$.UploadedBy'
		       );

		            DECLARE cur CURSOR FOR
                    SELECT CaseNo,schedulestatus,Remark,UploadedBy   from  #UpdateAppointmentstatus
		            
                    OPEN cur
                    FETCH NEXT FROM cur INTO  @CaseNo ,@schedulestatus,@Remark,@UploadedBy
		            
		            WHILE @@FETCH_STATUS=0
                    BEGIN
		              
			             exec [UspUpdateBulkBookingStatus_child] @CaseNo ,@schedulestatus,@Remark,@UploadedBy
			         	 FETCH NEXT FROM cur INTO  @CaseNo ,@schedulestatus,@Remark,@UploadedBy
		            
		            END

		END
		SELECT @StatusCode AS [Status],@SubCode AS SubCode,@Message AS [Message] 


		select * from ##GlobalLogResultCampBookingStatus
	    DROP TABLE  ##GlobalLogResultCampBookingStatus

  
END
 
