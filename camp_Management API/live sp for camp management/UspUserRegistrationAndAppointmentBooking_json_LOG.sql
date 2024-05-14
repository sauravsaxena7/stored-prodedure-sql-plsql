USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspUserRegistrationAndAppointmentBooking_json_LOG]    Script Date: 1/17/2024 2:01:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  


--EXEC UspUserRegistrationAndAppointmentBooking_json_LOG_29042023 '[{"ClientId":280.0,"ClientName":"Indus Tower Limited","PlanId":626.0,"PlanName":"Pre Employment Health Check Self (Female)","UserLoginName":"demoyustyur78@mailinator.com","MemberId":520154.0,"MemberName":"Demo","PackageId":819.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","AppointmentDate":"2023-09-10","AppointmentTime":"13:15"}]'

--exec UspUserRegistrationAndAppointmentBooking_json_LOG   '[{"ClientId":458.0,"clientname":"ops","PlanName":"Waiting period four","PlanId":896.0,"UserLoginName":"namanlola@gmail.com","MemberFirstName":"demo","MemberLastName":"user","MemberEmail":"namanlola@gmail.com","MobileNo":9146480293.0,"Gender":"M","Dob":"2000-09-10","Relation":"SELF","PackageId":192.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","UserAddress":"NULL","UserPincode":"NULL","AppointmentDate":"2024-09-10","AppointmentTime":"09:15","IsWithNewPlan":"Y","CNPlanBucketId":21684.0}]'

--exec  UspUserRegistrationAndAppointmentBooking_json_LOG '[{"ClientId":458.0,"clientname":"ops","PlanName":"Waiting period four","PlanId":896.0,"UserLoginName":"ramesh@gmail.com","MemberFirstName":"demo","MemberLastName":"user","MemberEmail":"ramesh@gmail.com","MobileNo":9146480293.0,"Gender":"M","Dob":"2000-09-10","Relation":"SELF","PackageId":192.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","UserAddress":"NULL","UserPincode":"NULL","AppointmentDate":"2024-09-10","AppointmentTime":"09:15","IsWithNewPlan":"Y","CNPlanBucketId":21684.0},{"ClientId":461.0,"clientname":"Testcorporateclient","PlanName":"Complex2APlan","PlanId":974.0,"UserLoginName":"ComplexSelf@gmail.com","MemberFirstName":"comself","MemberLastName":"demo","MemberEmail":"ComplexSelf@gmail.com","MobileNo":5454670098.0,"Gender":"M","Dob":"1981-03-12T00:00:00","Relation":"SELF","PackageId":824.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","AppointmentDate":"2024-01-31","AppointmentTime":"1899-12-31T08:15:00","UploadedBy":"qa","IsWithNewPlan":"Y","CNPlanBucketId":21860.0},{"ClientId":461.0,"clientname":"Testcorporateclient","PlanName":"Complex2APlan","PlanId":974.0,"UserLoginName":"ComplexSelf@gmail.com","MemberFirstName":"comdep","MemberLastName":"demo","MemberEmail":"Complexdep@gmail.com","MobileNo":5454670091.0,"Gender":"F","Dob":"1985-03-12T00:00:00","Relation":"WIFE","PackageId":824.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","AppointmentDate":"2024-01-31","AppointmentTime":"1899-12-31T08:15:00","UploadedBy":"qa","IsWithNewPlan":"Y","CNPlanBucketId":21860.0}]'


-- =============================================  
ALTER PROCEDURE [dbo].[UspUserRegistrationAndAppointmentBooking_json_LOG]  
 


  @CampManagementRegistrationAndAppointment  NVARCHAR(MAX)  
AS  
BEGIN  
  SET NOCOUNT ON;  

     
	CREATE TABLE ##GlobalLogResultCampBooking
    (
     ColumnName varchar(100),
     Status int, 
     Success varchar(100),
	 Message varchar(Max)
     )

  ---INSERT INTO ##GlobalCustomer VALUES(1,'Adam Tottropx' ,'30  Mztom Street LONDON')


    DECLARE @AppointmentDate1 datetime,@AppointmentTime1 datetime,@Dob1 datetime;

    DECLARE @ClientId bigint=NULL,
    @clientname Varchar(100)=NULL,
    @PlanName Varchar(100)=NULL,
    @PlanId bigint=NULL,
    @UserLoginName varchar(100)=NULL,
    @MemberFirstName varchar(100)=NULL,
    @MemberLastName varchar(100)=NULL,
    @MemberEmail varchar(100)=NULL,
    @MobileNo varchar(100)=NULL,
    @Gender varchar(100)=NULL,
    @Dob varchar(100) = NULL,   
    @Relation varchar(100),
    @PackageId	bigint=NULL,
    @ProviderId	bigint=NULL,
    @AppointmentVisitType varchar(100)=NULL,
    @UserAddress varchar(100)=NULL,
    @UserPincode varchar(100)=NULL,
    @AppointmentDate varchar(100) = NULL,                                                
    @AppointmentTime varchar(100)  = NULL,
	@MemberId BIGINT=NULL,
	@MemberName varchar(100)  = NULL,
	@UploadedBy varchar(100)  = NULL,
	@IsWithNewPlan varchar(10)  = NULL,
	@CNPlanBucketId BIGINT =null


    DECLARE @SubCode INT=200,@StatusCode BIT=1,@Message VARCHAR(MAX)='Successfull'; 

       IF ISNULL(@CampManagementRegistrationAndAppointment ,'')<>''
       BEGIN
	    
		   SELECT ClientId,clientname,PlanName,
		   PlanId,UserLoginName,MemberFirstName,MemberLastName,MemberEmail,MobileNo
		   ,Gender,Dob,Relation,PackageId,ProviderId,AppointmentVisitType,UserAddress,UserPincode,AppointmentDate,AppointmentTime,MemberId,MemberName,UploadedBy,IsWithNewPlan,CNPlanBucketId
		   
		   
		   INTO #RegistrationAndAppointmentBookingList FROM OPENJSON(@CampManagementRegistrationAndAppointment) WITH
		   (
		   ClientId float '$.ClientId', 
		   clientname VARCHAR(200) '$.clientname', 
		   PlanName VARCHAR(200) '$.PlanName',
		   PlanId  float '$.PlanId',
		   UserLoginName VARCHAR(200) '$.UserLoginName',
		   MemberFirstName VARCHAR(200)  '$.MemberFirstName',
		   MemberLastName VARCHAR(200) '$.MemberLastName',
		   MemberEmail VARCHAR(200)'$.MemberEmail',
		   MobileNo  VARCHAR(200) '$.MobileNo',
		   Gender VARCHAR(200) '$.Gender',
		   Dob VARCHAR(200) '$.Dob',
		   Relation  VARCHAR(200) '$.Relation',
		   PackageId float '$.PackageId',
		   ProviderId float '$.ProviderId',
		   AppointmentVisitType varchar(100) '$.AppointmentVisitType',
		   UserAddress varchar(100) '$.UserAddress',
		   UserPincode VARCHAR(200) '$.UserPincode',
		   AppointmentDate varchar(100) '$.AppointmentDate',
		   AppointmentTime varchar(100) '$.AppointmentTime',
		   MemberId float '$.MemberId', 
		   MemberName varchar(100) '$.MemberName',
		   UploadedBy varchar(100) '$.UploadedBy',
		   IsWithNewPlan varchar(100) '$.IsWithNewPlan',
		   CNPlanBucketId float '$.CNPlanBucketId'
		   

		  );

		   DECLARE cur CURSOR FOR
           SELECT ClientId,clientname,PlanName,
            PlanId,UserLoginName,MemberFirstName,MemberLastName,MemberEmail,MobileNo
		   ,Gender,Dob,Relation,PackageId,ProviderId,AppointmentVisitType,UserAddress,UserPincode,AppointmentDate,AppointmentTime,MemberId, MemberName,UploadedBy,IsWithNewPlan,CNPlanBucketId
		     from #RegistrationAndAppointmentBookingList

           OPEN cur
           FETCH NEXT FROM cur INTO @ClientId,@clientname,@PlanName,
		   @PlanId,@UserLoginName,@MemberFirstName,@MemberLastName,
		   @MemberEmail,@MobileNo,@Gender,@Dob,@Relation, @PackageId,@ProviderId,@AppointmentVisitType,@UserAddress,@UserPincode,@AppointmentDate,
		   @AppointmentTime,@MemberId,@MemberName,@UploadedBy,@IsWithNewPlan,@CNPlanBucketId 
           
		   WHILE @@FETCH_STATUS=0
           BEGIN
            --MAIN LOGIC
    
	           
				select @AppointmentDate1=cast(@AppointmentDate as datetime), @AppointmentTime1=cast(@AppointmentTime as datetime),@Dob1=cast(@Dob  as datetime);

				SET @MobileNo=isnull(@MobileNo,'MOBILENO');
				
				--SELECT @IsWithNewPlan AS IsWithNewPlan ,@CNPlanBucketId as CNPlanBucketId

				if @IsWithNewPlan='Y'
				   BEGIN
				     exec [UspUserRegistrationAndBooking_child_With_NewPlan] @ClientId,@clientname,@PlanName,@PlanId,@UserLoginName,@MemberFirstName,@MemberLastName,@MemberEmail,@MobileNo,@Gender,@Dob1,@Relation, @PackageId,@ProviderId,@AppointmentVisitType,@UserAddress,@UserPincode,@AppointmentDate1,@AppointmentTime1,@MemberId,@MemberName,@UploadedBy,@CNPlanBucketId
				   END
				ELSE
				  BEGIN
				     exec [UspUserRegistrationAndBooking_child] @ClientId,@clientname,@PlanName,@PlanId,@UserLoginName,@MemberFirstName,@MemberLastName,@MemberEmail,@MobileNo,@Gender,@Dob1,@Relation, @PackageId,@ProviderId,@AppointmentVisitType,@UserAddress,@UserPincode,@AppointmentDate1,@AppointmentTime1,@MemberId,@MemberName,@UploadedBy
				  END
               
           
		    
			   
                --FETCH NEXT ROWS 
               FETCH NEXT FROM cur INTO @ClientId,@clientname,@PlanName,@PlanId,@UserLoginName,@MemberFirstName,@MemberLastName,@MemberEmail,@MobileNo,@Gender,@Dob,@Relation, @PackageId,@ProviderId,@AppointmentVisitType,@UserAddress,@UserPincode,@AppointmentDate,@AppointmentTime,@MemberId,@MemberName,@UploadedBy,@IsWithNewPlan,@CNPlanBucketId 
           END

          
		   
	 END
	  SELECT @StatusCode AS [Status],@SubCode AS SubCode,@Message AS [Message] 
	 

	select * from ##GlobalLogResultCampBooking
	DROP TABLE ##GlobalLogResultCampBooking
	
END