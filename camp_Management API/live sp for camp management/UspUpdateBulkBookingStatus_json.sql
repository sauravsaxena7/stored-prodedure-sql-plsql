USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspUpdateBulkBookingStatus_json]    Script Date: 1/25/2024 3:29:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- EXEC [UspUpdateBulkBookingStatus_json]    

--exec [UspUpdateBulkBookingStatus_json] '[{"CaseNo":"HA22012024BACFED","schedulestatus":"Cancelled","Remark":"Appointment cancel","UploadedBy":"Joyline Fernandes","IsWithNewPlan":"Y"}]'

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

  DECLARE @CaseNo varchar(100), @schedulestatus VARCHAR(200), @Remark varchar(100)=NULL,@UploadedBy varchar(100)=NULL,@IsWithNewPlan VARCHAR(10) ='N'

  DECLARE @SubCode INT=200,@StatusCode BIT=1,@Message VARCHAR(MAX)='Successfull';
  print 'delete'
  print @CampMgmtUpdateBulkAppointmentStatus

  IF ISNULL(@CampMgmtUpdateBulkAppointmentStatus ,'')<>''
       BEGIN
	    
		       SELECT CaseNo,schedulestatus,Remark ,UploadedBy ,IsWithNewPlan
		       
		       INTO #UpdateAppointmentstatus FROM OPENJSON(@CampMgmtUpdateBulkAppointmentStatus ) WITH
		       (
		       
		       CaseNo VARCHAR(200) '$.CaseNo', 
		       schedulestatus VARCHAR(200) '$.schedulestatus',
		       Remark VARCHAR(200) '$.Remark',
			   UploadedBy VARCHAR(200) '$.UploadedBy',
			   IsWithNewPlan VARCHAR(100) '$.IsWithNewPlan'
		       );

		            DECLARE cur CURSOR FOR
                    SELECT CaseNo,schedulestatus,Remark,UploadedBy ,IsWithNewPlan  from  #UpdateAppointmentstatus
		            
                    OPEN cur
                    FETCH NEXT FROM cur INTO  @CaseNo ,@schedulestatus,@Remark,@UploadedBy,@IsWithNewPlan
		            
		            WHILE @@FETCH_STATUS=0
                    BEGIN
		              
			             exec [UspUpdateBulkBookingStatus] @CaseNo ,@schedulestatus,@Remark,@UploadedBy,@IsWithNewPlan
			         	 FETCH NEXT FROM cur INTO  @CaseNo ,@schedulestatus,@Remark,@UploadedBy,@IsWithNewPlan
		            
		            END

		END
		SELECT @StatusCode AS [Status],@SubCode AS SubCode,@Message AS [Message] 


		select * from ##GlobalLogResultCampBookingStatus
	    DROP TABLE  ##GlobalLogResultCampBookingStatus

  
END
 
