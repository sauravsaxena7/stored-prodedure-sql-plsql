USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[NspAppointmentBooking_CN]    Script Date: 1/11/2024 3:47:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- exec [dbo].[NspAppointmentBooking_CN]  534751, 531375, 78, 192, 7686, '3'
-- exec [dbo].[NspAppointmentBooking_CN] 523808, 519869, @PaymentStatus='Success', @TransactionId='HAR920230630150646'
-- exec [dbo].[NspAppointmentBooking_CN]  523259, 519197, 1, 29, 0, '794',  @DoctorId=123    --credit
-- exec [dbo].[NspAppointmentBooking_CN]  534751, 531375, 78, 192, @TransactionId='HAR5720231130161121', @PaymentStatus='Success'

ALTER PROCEDURE [dbo].[NspAppointmentBooking_CN]                               
	@UserLoginId BIGINT,                               
	@MemberId BIGINT,			
	@UserPlanDetailsId BIGINT = NULL,  
	@MemberPlanBucketId BIGINT=NULL,
 	@ProviderId BIGINT=0,                                
	@FacilityIds VARCHAR(200)='',  
	@AppointmentId BIGINT = 0,--Only pass parameter for Appointment Reschedule
	@AppointmentDate DATE = NULL,                                
	@AppointmentTime TIME(3) = NULL,                                
	@PremiumFlag CHAR(1) = 'N',                               
	@VisitType CHAR(10) = 'CV',                                
	@SlotId BIGINT = 0,                                                                
	@Address VARCHAR(5000) = '',                          
	@DoctorId BIGINT = NULL,                             
	@FemaleAttendantReqd CHAR(1) = NULL,                                
	@MobileNo VARCHAR(50) = NULL,                                
	@DocCoachApptType VARCHAR(50) = NULL,   
	@DOB DATE = NULL,  
	@ModeOfConsultation VARCHAR(10) = NULL,
	@SubSpecialityId BIGINT = NULL,
	@EncryptedUserLoginId VARCHAR(50) = NULL,
	@NeedToBuy CHAR(1)='N',  
	@CouponCode varchar(50) = NULL, 
	@ModeOfPayment VARCHAR(50) = 'ONLINE', 
	@PaymentStatus VARCHAR(10) = '',--Only pass parameter for after Payment Success y
	@TransactionId VARCHAR(500) = NULL,--Only pass parameter for after Payment Success y
	@PaymentMessage VARCHAR(500) = NULL,--Only pass parameter for after Payment Success y
	@RefId VARCHAR(500) = NULL,--Only pass parameter for after Payment Success y
	@NeedToDirectBook CHAR(1)='N',--Need To Direct Book without payment y
	@FilePrescription NVARCHAR(MAX)=NULL,
	@UserLatitude DECIMAL(18,15)=NULL, 
	@UserLongitude DECIMAL(18,15)=NULL, 
	@ServiceName VARCHAR(200)=NULL, 
	@ParentAppointmentId bigint = NULL, 
	@IsSendBookingEmail BIT=0,
	@CityId INT = 0,   
	@StateId INT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
/****************************Start DECLARE VARIABLES*********************************/
	DECLARE @SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX),@CurrentDate DATETIME=GETDATE(),@AcountType CHAR(1),@ProviderFacilityCode VARCHAR(200),@PartnerOrderId VARCHAR(200),@IsNotSendBookingEmail BIT=0, @RuleEngineMsg VARCHAR(200), @FacilityCredit BIGINT, @ActualFacilityCount BIGINT, @FacilityCountInBucket BIGINT, @FacilityType VARCHAR(200), @BucketType VARCHAR(100)
	DECLARE @MasterPlanType VARCHAR(50) = 'SERVICE',@SubSpecialityName VARCHAR(100),@AlternateDateTime DATETIME,@AppointmentDateTime DATETIME,@SelectedMemberId BIGINT,@MemberName VARCHAR(100)
	DECLARE @EmailId VARCHAR(100),@UserName VARCHAR(200),@ClientId BIGINT,@UserRoleId INT,@ScheduleStatus INT=1,@CNPlanDetailsId BIGINT,@PlanFromDate DATETIME,@PlanToDate DATETIME
	DECLARE @Area VARCHAR(200),@IsUnlimited CHAR(1)='N',@FacilityGroup VARCHAR(100),@AvailableAmount BIGINT=0,@BookFrom VARCHAR(100),@FacilityGroupId INT,@IsCreditAvailable VARCHAR(5)='N', @AvailableCredit INT=0
	DECLARE @NeedToAppointmentBook CHAR(1)='N',@MemberPlanDetailsId BIGINT,@FacilityAmount DECIMAL(18, 12),@AppointmentType VARCHAR(50),@LastApptLogId BIGINT,@SlotDetailId BIGINT,@AlternateSlotDetailId BIGINT, @NeedPartialPayment CHAR(1)='N'
	DECLARE @MemberPaymentDetailsId BIGINT,@MessageCode VARCHAR(100),@ActualFacilityAmount BIGINT=0,@ClientType INT,@ProviderVisitType VARCHAR(5),@FacilityVisitType VARCHAR(5) 
	DECLARE @ServiceTax DECIMAL(8,2),@GSTAmount BIGINT,@TotalAmount BIGINT,@HAFullMarginRate DECIMAL(18,2),@HAPartialMarginRate DECIMAL(18,2),@HealthCoachId BIGINT, @TotalAmountIncludeGST BIGINT, @PartialAmount BIGINT, @Amount BIGINT
	DECLARE @FirstName VARCHAR(100),@LastName VARCHAR(100),@Gender VARCHAR(10),@Relation VARCHAR(100),@ServiceId BIGINT,@PartialPoints INT,@RSlotId BIGINT
	DECLARE @ConvenienceFee DECIMAL(18,2),@MarginRate DECIMAL(18,2),@HARate DECIMAL(18,2),@ProviderRate DECIMAL(18,2),@CouponId BIGINT,@DiscountAmount DECIMAL(10, 3)
	DECLARE @ProviderType VARCHAR(50),@CaseNo VARCHAR(100)='',@Credit VARCHAR(200),@CityName VARCHAR (50),@Pincode VARCHAR(20),@ProviderName VARCHAR(100),@PartialPnt int, @IdU BIGINT, @BucketBalanceId BIGINT=NULL, @BalanceAmount BIGINT=0, @CanBucketUtilized BIT=1
	------------DECLARE TABLE-----------------------------------------
	DECLARE @TmpFacility TABLE(Id BIGINT IDENTITY (1, 1),FacilityId BIGINT,FacilityType VARCHAR(50),FacilityGroup VARCHAR(50),HARate DECIMAL(18, 2),ProviderRate DECIMAL(18, 2),ConvenienceFee DECIMAL(18,2),CappingLimit DECIMAL(18,2),MemberPlanBucketId BIGINT,ServiceType VARCHAR(50),ProcessCode VARCHAR(50),PackageId BIGINT,IsFasting VARCHAR(50),TestId BIGINT)    
	DECLARE @ApplyCoupon TABLE([Status] BIT,SubCode INT,[Message] VARCHAR(200),FinalAmount DECIMAL(10, 3),DiscountAmount DECIMAL(10, 3),CouponId BIGINT,CouponCode VARCHAR(100)) 
	CREATE TABLE #TmpHomeVisitCharge(ProviderHomeVisitCharge VARCHAR(200)) 
	DECLARE @TmpResheduled TABLE(PartnerOrderId VARCHAR(200),ProviderId BIGINT,ProviderType VARCHAR(50),AppointmentDateTime DATETIME,MemberId BIGINT,MobileNo VARCHAR(20),ActualRate DECIMAL(18,3)) 
	create table #BucketUtilized(BucketId bigint, CanBucketUtilized bit)
/****************************End DECLARE VARIABLES*********************************/ 
	----------------------------------CHECK USER------------------------------------------------------
	IF NOT EXISTS(SELECT 1 FROM Member WHERE UserLoginId=@UserLoginId AND MemberId=@MemberId)
	BEGIN
		SELECT 0 AS [Status],500 AS SubCode,'Bad Request, InValid User' AS [Message]--TABLE 1
		RETURN
	END

	---------------------------------------check if bucket can be used or not-------------------
	--INSERT INTO #BucketUtilized(BucketId, CanBucketUtilized)
	--EXEC [dbo].[NspTermsOfUse_CN] @UserPlanDetailsId, @MemberPlanBucketId

	--select top 1 @CanBucketUtilized= CanBucketUtilized from #BucketUtilized 
	--IF(@CanBucketUtilized=0)
	--BEGIN
	--	SELECT 0 AS [Status],400 AS SubCode,'The given Bucket can''t be utilized' AS [Message]--TABLE 1
	--	RETURN
	--END

	--INSERT INTO #BucketUtilized(BucketId, CanBucketUtilized)
	--EXEC [dbo].[NspPreConditionedFormula_CN] @UserPlanDetailsId, @MemberPlanBucketId

	--select top 1 @CanBucketUtilized= CanBucketUtilized from #BucketUtilized 
	--IF(@CanBucketUtilized=0)
	--BEGIN
	--	SELECT 0 AS [Status],400 AS SubCode,'The given Bucket can''t be utilized' AS [Message]--TABLE 1
	--	RETURN
	--END

	-------------------------------------------end----------------------------------------------
	IF(@PaymentStatus = 'Success' AND @TransactionId IS NOT NULL)
	BEGIN
		SELECT top 1 @UserPlanDetailsId=c.UserPlanDetailsId,@MemberPlanBucketId=MemberPlanBucketId,@ClientId= c.ClientId,@MemberId=c.MemberId,@VisitType=c.VisitType,@ProviderId=c.Providerid, @AppointmentDate=c.AppointmentDate,@AppointmentTime=c.Appointmenttime,@UserName=CONCAT(c.FirstName,' ',c.LastName),@Relation=c.Relation,  
		@EmailID=c.Email,@MobileNo=c.MobileNo,@SlotId=c.SlotId, @FacilityIds=c.FacilityIds ,@SubSpecialityId=c.SubSpecialityId, @DOB = DOB, @Address = [Address],@DocCoachApptType=DocCoachApptType,@ModeOfConsultation=c.ModeOfConsultation,
		@UserLatitude=c.UserLatitude,@UserLongitude=c.UserLongitude,@DoctorId=c.DoctorId, @ActualFacilityAmount=c.TotalAmount, @CityId=c.cityid, @StateId=c.StateId
		FROM UserBookingRequest c WHERE c.TransactionId=@TransactionId

		UPDATE UserTransactions SET Status='Success' where TransactionId=@TransactionId and ActiveStatus='Y'
	END
	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	SET @RSlotId=@SlotId
	UPDATE Member SET DOB = IIF(@DOB IS NOT NULL,@DOB,DOB), MobileNo = IIF(ISNULL(@MobileNo, '') <> '', @MobileNo,MobileNo) WHERE MemberId = @MemberId                              
	-----------------------------------------------------------------------------------------
/*********************************************[START] Facility AND Memeber Related Logic******************************************/
	INSERT INTO @TmpFacility(FacilityId,FacilityType,ServiceType,FacilityGroup,ProcessCode,IsFasting,PackageId,TestId,ConvenienceFee) 
	SELECT f.FacilityId,f.FacilityType,f.ServiceType,F.FacilityGroup,f.ProcessCode,F.isFasting,IIF(F.FacilityType ='TEST',0,f.FacilityId),IIF(F.FacilityType='TEST',f.FacilityId,0),F.ConvenienceFee FROM dbo.SplitString(@FacilityIds,',') T JOIN FacilitiesMaster F ON T.Item=F.FacilityId
	SELECT TOP 1 @FacilityGroup=IIF(ISNULL(@ServiceName,'')='',FacilityGroup,@ServiceName),@AppointmentType=ProcessCode, @FacilityType=FacilityType FROM @TmpFacility
	SELECT @ServiceId=FacilityId FROM FacilitiesMaster WHERE FacilityGroup=@FacilityGroup AND ServiceType='SERVICE' AND IsActive='Y'
	UPDATE T SET T.PackageId=P.PackageId FROM PackageTestMaster p JOIN @TmpFacility T ON p.PackageId = t.FacilityId  AND t.FacilityType = 'PACKAGE';           
	UPDATE T SET T.MemberPlanBucketId=@MemberPlanBucketId from @TmpFacility T

	------------------------------------------------check if the facility ids are present in given bucket or not-------------------------
	SELECT @ActualFacilityCount=COUNT(FacilityId) FROM @TmpFacility
	SELECT @FacilityCountInBucket=COUNT(t.FacilityId) FROM @TmpFacility T JOIN MemberPLanBucketsDetails MD ON md.MemberPLanBucketId=t.MemberPlanBucketId and md.FacilityId = t.FacilityId and md.ActiveStatus='Y' 

	--IF NOT EXISTS(SELECT 1 FROM MemberPLanBucketsDetails WHERE MemberPLanBucketId=@MemberPlanBucketId AND FacilityType=@FacilityType AND FacilityGroup=@FacilityGroup and ActiveStatus='Y')		--[ALL] case
	--BEGIN
	--	IF(@FacilityCountInBucket < @ActualFacilityCount)
	--	BEGIN
	--			SELECT @Status=0, @SubCode=400, @Message='One of the given facilities is not present in given bucket', @MessageCode='APPOINTMENTBOOKINGFAILED'
	--			SELECT @Status AS [Status],@SubCode AS SubCode,@MessageCode AS MessageCode,@Message AS [Message]--TABLE 1
	--			RETURN
	--	END
	--END

	-----------------------------------------------------------end-------------------------------------------------

	--add capping limit of each facility bucket wise
	UPDATE T set t.CappingLimit=md.CappingLimit FROM @TmpFacility T JOIN MemberPLanBucketsDetails MD ON md.MemberPLanBucketId=t.MemberPlanBucketId and md.FacilityId = t.FacilityId and md.ActiveStatus='Y'

	-------------------------------------------------------------------------------------------------
	SELECT @ProviderFacilityCode=(SELECT STRING_AGG(ProviderFacilityCode, ',') FROM ProviderFacilities p JOIN @TmpFacility t ON p.FacilityId=t.FacilityId WHERE ProviderId=@ProviderId AND IsActive='Y' AND ISNULL(ProviderFacilityCode,'')<>'')

	SELECT @ProviderType= P.ProviderTypeCode,@CityName=P.CityName,@Pincode=Pincode,@ProviderName=P.ProviderName from [HAPortalUAT].dbo.Provider P  WHERE P.IsActive='Y' AND P.ProviderId=@ProviderId
	IF(@ProviderType='HEALTHIANS')
      BEGIN
                       IF ((select count(FacilityId) from @TmpFacility) <> (SELECT Count(P.ProviderFacilityCode) FROM ProviderFacilities p JOIN @TmpFacility t ON p.FacilityId=t.FacilityId WHERE ProviderId=@ProviderId AND IsActive='Y') )
                       BEGIN
                                --SELECT 0 AS [Status],500 AS SubCode,'Invalid Test & Package' AS [Message]--TABLE 1@TmpFacility
                                set @SubCode=500 set @MessageCode='APPOINTMENTBOOKINGFAILED' set @Message='Invalid Test & Package'
                                SELECT @Status AS [Status],@SubCode AS SubCode,@MessageCode AS MessageCode,@Message AS [Message]--TABLE 1
                                SELECT ISNULL(@Message,'Invalid Test & Package') AS [Message] --
                               --SELECT @MessageCode = 'InvalidTest&Package'--TABLE 1
                        RETURN
                       END
    END

	----------------------------------------GET PARTNER ORDER ID----------------------------------------
	SELECT  @PartnerOrderId = Partner_orderid FROM Appointment WHERE AppointmentId = @AppointmentId
	SELECT @MobileNo = MobileNo ,@Address = IIF(ISNULL(@Address,'')='',Address1,@Address),@Gender=Gender,@Relation=Relation,@DOB=DOB,@FirstName=FirstName,@LastName=LastName FROM Member WHERE MemberId=@MemberId;  

	SELECT  @UserName = CONCAT(FirstName, ' ', LastName),@EmailId = UserName,@UserRoleId = UserRoleId,@ClientId = ClientId,@ClientType=UserTypeId FROM UserLogin WHERE UserLoginId = @UserLoginId; 


	IF(ISNULL(@UserPlanDetailsId,0)=0)
	BEGIN
		SELECT @UserPlanDetailsId = UserPlanDetailsId, @CNPlanDetailsId = CNPlanDetailsId, @PlanFromDate = FromDate,@PlanToDate = CASE WHEN Todate > @CurrentDate THEN TODate ELSE DATEADD(Y, 1, @CurrentDate) END FROM Member M JOIN UserPlanDetails UP on up.MemberId=m.MemberId and m.IsActive='Y' and m.Relation='SELF' and up.ActiveStatus='Y'  WHERE m.UserLoginId = @UserLoginId and m.MemberId=@MemberId                                 
	END
	ELSE
	BEGIN
		SELECT @CNPlanDetailsId = CNPlanDetailsId,@PlanFromDate = FromDate,@PlanToDate = CASE WHEN Todate > @CurrentDate THEN TODate ELSE DATEADD(Y, 1, @CurrentDate) END FROM UserPlanDetails  WHERE MemberId = @MemberId AND UserPlanDetailsId=@UserPlanDetailsId                                 
	END
  
	SELECT @BucketType = PLanBucketType from MemberPLanBucket where MemberPLanBucketId=@MemberPlanBucketId AND ActiveStatus='Y'

	IF (ISNULL(@DoctorId,0)<> 0 and @FacilityGroup not in ('Family-Physician','Doctor Consultation'))    
	BEGIN    
		UPDATE @TmpFacility SET HARate = d.AppPriceGraded FROM HAModule.tele_consultaion.Doctor d WHERE d.DoctorId = @DoctorId 
	END
	ELSE
	BEGIN   
	    UPDATE T SET T.HARate = h.AgreedRate  FROM @TmpFacility T JOIN HARateMaster h ON T.FacilityId = h.FacilityId                               
		WHERE ClientId=@ClientId AND h.FromDate <= @CurrentDate AND @CurrentDate <= ISNULL(h.ToDate, @CurrentDate) AND h.IsActive = 'Y'; 

		UPDATE T SET T.HARate = FM.AppPrice1Graded FROM @TmpFacility T JOIN FacilitiesRateMster AS fm ON T.FacilityId = fm.FacilityId 
		and fm.IsActive='Y' AND fm.FromDate <= @CurrentDate  and @CurrentDate <= ISNULL(fm.ToDate,@CurrentDate) 
		AND FM.ProviderId = @ProviderId
		WHERE ISNULL(T.HARate,0)=0;

		UPDATE T SET T.HARate = h.AgreedRate  FROM @TmpFacility T JOIN HARateMaster h ON T.FacilityId = h.FacilityId                               
		WHERE ClientId=0 AND h.FromDate <= @CurrentDate AND @CurrentDate <= ISNULL(h.ToDate, @CurrentDate) AND h.IsActive = 'Y' and ISNULL(T.HARate,0)=0;
	END
	SELECT  @FacilityAmount = SUM(ISNULL(HARAte, 0)),@HARate=SUM(ISNULL(HARate,0)), @ProviderRate=SUM(ISNULL(ProviderRate,0)),@ConvenienceFee=SUM(ISNULL(ConvenienceFee,0)), @FacilityCredit = COUNT(ISNULL(FacilityId,0)) FROM @TmpFacility

		-------------------------------------------check validation for capping limit------------------------------------------------
	--IF EXISTS (SELECT 1 FROM @TmpFacility WHERE HARate > CappingLimit AND @BucketType='WALLET')
	--BEGIN
	--	SELECT @Status=0, @SubCode=400, @Message='Facility amount exceeded the capping limit', @MessageCode='APPOINTMENTBOOKINGFAILED'
	--	SELECT @Status AS [Status],@SubCode AS SubCode,@MessageCode AS MessageCode,@Message AS [Message]--TABLE 1
	--	RETURN
	--END

	-------------------------------------------end validation----------------------------------------------------

/***********************************************[END] Facility AND Memeber Related Logic*****************************************************/

		/*********************************************COUPON UTILISATION CHECK Start*****************************************************************/

		--Set @CouponCode=ISNULL(@CouponCode,null)
		--PRINT @CouponCode
 --    IF(LTRIM(RTRIM(@CouponCode)) = '')
	-- BEGIN
	--  SET @CouponCode=null
	-- END

	--IF @CouponCode is not null
	--begin
	--		CREATE TABLE #DiscountCouponDetails (Subcode int, Status varchar(MAX), Message varchar(MAX), DiscountAmount_Percent Int,Maxlimit decimal, DiscountType Varchar(100))
	--		   DECLARE @DiscountCouponPercentAmount int; 

	--INSERT INTO #DiscountCouponDetails(Subcode,Status,Message,DiscountAmount_Percent,Maxlimit,DiscountType)
	--EXEC [UspUserCouponValidation] @UserLoginId,@MemberPlanId,@MemberId,@FacilityIds,@ProviderId,@CouponCode
	--DECLARE @DiscountAmount_Percent int; DECLARE @Maxlimit int; DECLARE @CSubcode int; DECLARE @CStatus varchar(100); DECLARE @CMessage VARCHAR(MAX); DECLARE @DiscountType Varchar(100);
	--SELECT @CSubcode=Subcode,@Status=Status,@CMessage=Message,@DiscountAmount_Percent=ISNULL(DiscountAmount_Percent,0),@Maxlimit=ISNULL( Maxlimit,0),@DiscountType=DiscountType FROM #DiscountCouponDetails
	--IF (@DiscountAmount_Percent is not null)
	--begin
	--PRINT @FacilityAmount
	--  IF (@DiscountType='FIXED')
 --     BEGIN
 --         IF @DiscountAmount_Percent<=@Maxlimit
	--	   BEGIN
	--         SET @FacilityAmount =@FacilityAmount-@DiscountAmount_Percent
 --         END
	--	  ELSE
	--	  BEGIN
	--	     SET @FacilityAmount=@FacilityAmount-@Maxlimit
	--	  END
 --     END
 --     ELSE
 --     BEGIN
	--  PRINT @FacilityAmount
	--       SET @DiscountCouponPercentAmount=((cast(@FacilityAmount as float) * @DiscountAmount_Percent)/100);
	--	      IF @DiscountCouponPercentAmount<=@Maxlimit
	--		  BEGIN
	--	         SET @FacilityAmount=@FacilityAmount - @DiscountCouponPercentAmount
 --             END
	--		  ELSE
	--		  BEGIN
	--		     SET @FacilityAmount=@FacilityAmount-@Maxlimit
	--		  END
	--  END
	--end
	--end
	
	/*********************************************COUPON UTILISATION CHECK END*****************************************************************/


	/*********************************************GET HOME VISIT Charge Start*****************************************************************/
	
	if @VisitType = 'HV'
	begin
	INSERT INTO #TmpHomeVisitCharge (ProviderHomeVisitCharge)
	EXEC [uspGetProviderHomeVisitChargesProvider] @FacilityIds,@ProviderId
	DECLARE @HOMEVISITCHARGE varchar (250);
	SELECT @HOMEVISITCHARGE = ISNULL(cast( ProviderHomeVisitCharge as BIGINT),0) FROM #TmpHomeVisitCharge
	if @HOMEVISITCHARGE != ''
	begin
	  IF @FacilityAmount >=450
	   Begin
	    SET @HOMEVISITCHARGE=0;
	   End

	Set @FacilityAmount = @FacilityAmount + @HOMEVISITCHARGE;
	 PRINT @FacilityAmount
	 PRINT @ClientId
	end
	end
	
	/*********************************************GET HOME VISIT Charge END*****************************************************************/

/*********************************************[START] CHECK WALLET,Credit AND Unlimited Facility FOR BOOKING Related Logic******************************************/	
	
	IF(@NeedToBuy='N' AND ISNULL(@AppointmentId,0)=0 AND ISNULL(@TransactionId,'')='')
	BEGIN
		--EXEC @RuleEngineMsg = CheckRuleEngine_CN @UserPlanDetailsId, @MemberPlanBucketId, @FacilityAmount
		--IF(@RuleEngineMsg <> 'Validated successfully')
		--BEGIN
		--	SELECT @Status=0, @SubCode=400, @Message=@RuleEngineMsg, @MessageCode='APPOINTMENTBOOKINGFAILED'
		--	SELECT @Status as [Status], @SubCode as SubCode, ISNULL(@Message,'Appointment Booking Failed') AS [Message], @MessageCode as MessageCode
		--	RETURN
		--END
		EXEC [dbo].[NspGetAvailableAmount_CN] @UserPlanDetailsId,@MemberPlanBucketId,@UserLoginId,@FacilityGroup,@AvailableAmount OUT,@BookFrom OUT,@FacilityGroupId OUT, @AvailableCredit OUT --GET Available AMOUNT/CREDIT
	END
	ELSE
	BEGIN
		SELECT @FacilityGroupId=FacilityId FROM FacilityGroupCombinaton WHERE FacilityGroupName=@FacilityGroup AND IsActive='Y'
	END

/********************************************************[END]******************************************************************************************/

/*************************************************[START] Appointment VARIABLES*******************************************************************/
		SET @ScheduleStatus = IIF(ISNULL(@UserRoleId, 0) = 1,1,CASE WHEN @UserRoleId = 12 THEN 1 WHEN EXISTS(SELECT 1 FROM @TmpFacility WHERE ProcessCode = 'TDR') THEN 1 ELSE 2 END)-----SET Schedule Status--
		IF EXISTS(SELECT 1 FROM @TmpFacility WHERE FacilityGroup = 'Emergency Assistance') 
		BEGIN
			SELECT @ScheduleStatus=StatusId from StatuSmaster where StatusCode='FORWARDED'
		END
		SET @IsNotSendBookingEmail=IIF(ISNULL(@ProviderFacilityCode,'')<>'' AND @ScheduleStatus=1,1,0)
		IF(@AppointmentId>0)  
		BEGIN  
			SELECT @SubSpecialityId=SubSpecialityId FROM Appointment WHERE AppointmentId=@AppointmentId AND AppointmentType IN('TDR','TELESPEC','FITCOACH')  
		END
		SET @SlotId = CASE WHEN @FacilityGroup IN('Tele-Consultation','Doctor Consultation','Specialist Consultation') THEN @SlotId ELSE 0 END
		IF ISNULL(@SubSpecialityId, 0) <> 0                                
		BEGIN                                
			SELECT @SubSpecialityName=FacilityName FROM FacilitiesMaster WHERE FacilityId = @SubSpecialityId                           
		END     
		SET @AppointmentDateTime = CAST(@AppointmentDate AS DATETIME) + CAST(@AppointmentTime AS DATETIME)                                

		SELECT @ProviderVisitType = IsHomeVisit FROM [dbo].[ProviderFacilities] WHERE ProviderId = @ProviderId AND FacilityID IN(SELECT facilityid FROM @TmpFacility)
		SELECT @FacilityVisitType = VisitType FROM [dbo].ClientPackageMaster WHERE FacilityID IN(SELECT facilityid FROM @TmpFacility)

		IF(@ProviderVisitType = 'Y'  OR @FacilityVisitType = 'HV')
		BEGIN
			SET @VisitType = 'HV'
		END	
/*************************************************[END] Appointment VARIABLES*******************************************************************/
	
	IF(ISNULL(@AppointmentId,0)=0)
	BEGIN

		/********************************************[START] Appointment BOOKING Related Logic********************************************************/			   
		IF(@NeedToBuy='N')
		BEGIN
			IF(ISNULL(@NeedToDirectBook,'N')='N')
			BEGIN
				-----------------------------------------------------------------AFTER PAYMENT BOOKING START----------------------------------------------------
				IF(@PaymentStatus = 'Success' AND @TransactionId IS NOT NULL)
				BEGIN
					SELECT @PartialAmount = PartialAmount, @Amount=Amount FROM UserTransactions where TransactionId=@TransactionId and Status='Success' and ActiveStatus='Y'
					IF(@PartialAmount + @Amount = @ActualFacilityAmount)
					BEGIN
						print('online Payment Paid already')
						SELECT @NeedToAppointmentBook='Y', @FacilityAmount=@PartialAmount;
					END
					ELSE
					BEGIN
						SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Appointment Booking Failed',@MessageCode = 'APPOINTMENTBOOKINGFAILED'
					END
				END

				ELSE IF(ISNULL(@PaymentStatus,'')<>'' AND @PaymentStatus <> 'Success' AND @TransactionId IS NOT NULL)
				BEGIN
					SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Appointment Booking Failed',@MessageCode = 'APPOINTMENTBOOKINGFAILED'
				END

				ELSE IF (@BookFrom='PAYPERUSE')
				BEGIN
					SELECT @NeedToAppointmentBook = 'N',@NeedToBuy='Y' 
				END
				-----------------------------------------------------------------AFTER PAYMENT BOOKING END----------------------------------------------

				------------------------------------------------------------CREDIT/UNLIMITED BOOKING START--------------------------------------
				ELSE IF(@BookFrom='UNLIMITED')
				BEGIN
					INSERT INTO MemberBucketBalance(UserPlanDetailsId, MemberPLanBucketId,UserLoginId,MemberId,BalanceAmount,TransactionAmount,BalanceCredit ,TransactionCredit,AmountSource, WalletTransactionType, ActiveStatus, CreatedDate, UpdatedDate, CreatedBy, UpdatedBy, FacilityGroupId)
					VALUES(@UserPlanDetailsId, @MemberPlanBucketId,@UserLoginId,@MemberId,@FacilityAmount,@FacilityAmount, @AvailableCredit,@FacilityCredit,'Convert Credit to Wallet Amount', 'CREDIT', 'Y', @CurrentDate, @CurrentDate, @UserName, @UserName, @FacilityGroupId)
				
					SET @NeedToAppointmentBook = 'Y'
				END
				ELSE IF(@BookFrom='CREDIT' AND @FacilityCredit > @AvailableCredit)
				BEGIN
					SELECT @BookFrom ='CREDIT',@Message = 'Appointment Booking Failed, Not enough Credits', @MessageCode = 'APPOINTMENTBOOKINGFAILED'
				END
				ELSE IF(@BookFrom='CREDIT' AND @FacilityCredit <= @AvailableCredit)
				BEGIN
					SET @AvailableCredit = @AvailableCredit - @FacilityCredit

					INSERT INTO MemberBucketBalance(UserPlanDetailsId, MemberPLanBucketId,UserLoginId,MemberId,BalanceAmount ,TransactionAmount,BalanceCredit, TransactionCredit, AmountSource, WalletTransactionType, ActiveStatus, CreatedDate, UpdatedDate, CreatedBy, UpdatedBy, FacilityGroupId)
					VALUES(@UserPlanDetailsId, @MemberPlanBucketId,@UserLoginId,@MemberId,@FacilityAmount,@FacilityAmount, @AvailableCredit, @FacilityCredit ,'Convert Credit to Wallet Amount', 'CREDIT', 'Y', @CurrentDate, @CurrentDate, @UserName, @UserName, @FacilityGroupId)
				
					SET @NeedToAppointmentBook = 'Y'
				END
				---------------------------------------------------------------CREDIT/UNLIMITED BOOKING END-------------------------------------------------------------

				-------------------------------------------------------------WALLET BOOKING START------------------------------------------------
				ELSE IF((@BookFrom ='WALLET' AND @AvailableAmount >= @FacilityAmount))
				BEGIN
					--NO PAYMENT, DIRECT BOOKING (WALLET)
					SET @NeedToAppointmentBook='Y' 
				END
				ELSE IF(@BookFrom ='WALLET' AND @AvailableAmount < @FacilityAmount)
				BEGIN
					--SELECT @BookFrom ='WALLET',@Message = 'Appointment Booking Failed, Not enough Wallet Amount', @MessageCode = 'APPOINTMENTBOOKINGFAILED'
					-- FULL PAYMENT (ONLINE) or PARTIAL PAYMENT (ONLINE+WALLET)
					SELECT @NeedToAppointmentBook = 'N',@NeedToBuy='Y' 
					PRINT 'Starting Payment'		
				END
				--------------------------------------------------------------WALLET BOOKING END------------------------------------------------------------
			END
			ELSE
			BEGIN
				SET @NeedToAppointmentBook='Y' 
			END
			IF(ISNULL(@ProviderFacilityCode,'')<>'' AND EXISTS(SELECT TOP 1 1 FROM Appointment a JOIN AppointmentDetails d ON a.AppointmentId=d.AppointmentId JOIN ProviderFacilities f ON f.FacilityId=d.PakageId AND d.ProviderId=f.ProviderId AND f.IsActive='Y' JOIN HAPortal.dbo.provider P ON F.providerId=P.providerId  WHERE UserLoginId=@UserLoginId AND MobileNo=@MobileNo AND ScheduleStatus NOT IN(6,7) AND P.ProviderTypeCode='HEALTHIANS'))
			BEGIN
				SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Dear '+CONCAT(@FirstName,' ',@LastName)+', you have an on going appointment request with the us for this user. For additional queries please connect with us at +91-22-6167-6600.',@MessageCode = 'APPOINTMENTBOOKINGFAILED',@NeedToAppointmentBook='N'
			END

			IF(@NeedToAppointmentBook='Y')  --main booking logic
			BEGIN		
				INSERT INTO [dbo].[Appointment] ([MemberId],[UserTypeMappingId],[UserLoginId],[FemaleAttendantReqd],[ScheduleStatus],[VisitType],[DoctorrId],[AppointmentType],[PremiumFlag],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate]                               
				,[ClientId],[MobileNo],[Area],[AppointmentAddress],[DocCoachApptType],[ModeOfConsultation],[SubSpecialityId],[SubFacilityName],BookedVia,UserLatitude,UserLongitude,ParentAppointmentId,CouponCode, UserPlanDetailsId, MemberPlanBucketId)                      
				VALUES (@MemberId, 1, @UserLoginId, @FemaleAttendantReqd, @ScheduleStatus, @VisitType, @DoctorId, @AppointmentType, ISNULL(@PremiumFlag, 'N'), 'Y', @UserName, @CurrentDate, @UserName, @CurrentDate, @ClientId, @MobileNo, @Area, @Address, 
				 @DocCoachApptType, @ModeOfConsultation, @SubSpecialityId,@SubSpecialityName,CASE WHEN @BookFrom='OnlinePayment' THEN IIF(ISNULL(@PartialPoints,0)<>0,'Wallet and Payment','Payment') ELSE @BookFrom END,@UserLatitude,@UserLongitude,@ParentAppointmentId,@CouponCode, @UserPlanDetailsId, @MemberPlanBucketId);                            
				SET @AppointmentId = SCOPE_IDENTITY()

				INSERT INTO [dbo].[AppointmentDetails] ([AppointmentId],[TestId],[PakageId],[ProviderId],[AppointmentDateTime],[AlternateAppointmentDateTime],[AppointmentScheduleDateTime],[HomeVisit],[Fasting],[TestCompletionStatus],[TestCompletionRemark],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate], FacilityAmount)                                 
				SELECT @AppointmentId,P.TestId,P.PackageId,@ProviderId,@AppointmentDateTime,@AlternateDateTime,@CurrentDate,@VisitType,T.IsFasting,1,'','Y',@UserName,@CurrentDate,@UserName,@CurrentDate, t.HARate FROM PackageTestMaster p JOIN @TmpFacility t                                
				ON p.PackageId = t.FacilityId  AND t.FacilityType = 'PACKAGE'                                
				UNION
				SELECT @AppointmentId,t.TestId,t.PackageId,@ProviderId,@AppointmentDateTime,@AlternateDateTime,@CurrentDate,@VisitType,t.isFasting,1,'','Y',@UserName,@CurrentDate,@UserName,@CurrentDate, t.HARate FROM @TmpFacility t WHERE t.FacilityType<>'PACKAGE' 
			
				INSERT INTO [dbo].[AppointmentLog] ([AppointmentId],[ScheduleStatus],[UserLoginId],[CreatedBy],[CreatedDate])                                
				VALUES (@AppointmentId, @ScheduleStatus, @UserLoginId, @UserName, @CurrentDate)                                
				SET @LastApptLogId = SCOPE_IDENTITY();
			
				INSERT INTO [dbo].[AppointmentLogDetails] ([AppointmentLogId],[AppointmentDetailId],[AppointmentDateTime],[TestCompletionStatus],[ProviderId],[HomeVisit],[CreatedBy],[CreatedDate])                                
				SELECT @LastApptLogId,ad.AppointmentDetailId,ad.AppointmentDateTime,ad.TestCompletionStatus,@ProviderId,ad.HomeVisit,@UserName,@CurrentDate                                
				FROM AppointmentDetails ad WHERE ad.AppointmentId = @AppointmentId;                                
            
				IF (ISNULL(@SlotId, 0) > 0)                                
				BEGIN    
					INSERT INTO [dbo].[DoctorSlotDetails] ([SlotId],[UserLoginId],[SlotDate],[SlotType],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])                                
					VALUES (@SlotId, @UserLoginId, @AppointmentDateTime, 'Booked by Customer', 'Y', @UserName, @CurrentDate, @UserName, @CurrentDate)                                
					SET @SlotDetailId = SCOPE_IDENTITY();            
					UPDATE Appointment SET SlotDetailId = @SlotDetailId WHERE AppointmentId = @AppointmentId                                
				                        
				END 
				IF (@AppointmentType IN ('TDR', 'NT', 'TELECOUN', 'TELESPEC'))                                
				BEGIN  
					IF (@ModeOfConsultation = 'Video'AND ISNULL(@ModeOfConsultation, '') <> '') 
					BEGIN                                
						DECLARE @VideoLink varchar(500),@VideoId bigint;                                
						IF EXISTS (SELECT MemberId FROM VideoConsultationData WHERE MemberId = @MemberId)                                
						BEGIN                                
							UPDATE VideoConsultationData SET IsActive = 0 WHERE MemberId = @MemberId;                                
						END                                
						INSERT INTO VideoConsultationData (UserLoginId,MemberId,AppointmentId,AppointmentDateTime,DoctorId,VideoLinkForUser,VideoLinkForDoctor,LinkExpiryTime,IsActive,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy)                                
						VALUES (@UserLoginId, @MemberId, @AppointmentId, DATEADD(MINUTE, -15, @AppointmentDateTime), ISNULL(@DoctorId, 0), CONCAT('https://video.healthassure.in/HAVideoConsultation?roomName=', @EncryptedUserLoginId, '&Flag=P&User=1'),          
						CONCAT('https://video.healthassure.in/HAVideoConsultation?roomName=', @EncryptedUserLoginId, '&Flag=D&User=1'), DATEADD(MINUTE, 60,@AppointmentDateTime), 1, @CurrentDate, @Username, @CurrentDate, @Username);                                
					END                                
				END

				--insert into MemberBucketBalance table to maintain history
				SELECT TOP 1 @BucketBalanceId=BucketBalanceId, @BalanceAmount=BalanceAmount FROM MemberBucketBalance WHERE UserPlanDetailsId=@UserPlanDetailsId and MemberPLanBucketId=@MemberPlanBucketId and UserLoginId=@UserLoginId ORDER BY CreatedDate DESC
				SET @BalanceAmount = ISNULL(@BalanceAmount,0) - @FacilityAmount

				INSERT INTO MemberBucketBalance(UserPlanDetailsId, MemberPLanBucketId,UserLoginId,MemberId,BalanceAmount ,TransactionAmount,BalanceCredit,TransactionCredit ,AmountSource, WalletTransactionType, AppointmentId, ActiveStatus, CreatedDate, UpdatedDate, Facilityids, FacilityGroupId)
				VALUES(@UserPlanDetailsId, @MemberPlanBucketId,@UserLoginId,@MemberId,@BalanceAmount,@FacilityAmount,@AvailableCredit ,@FacilityCredit,CONCAT(@FacilityGroup, ' Booking'), 'DEBIT', @AppointmentId, 'Y', @CurrentDate, @CurrentDate, @FacilityIds, @FacilityGroupId)

				UPDATE [Appointment] SET CaseNo = [dbo].[fnGetCaseNo](@AppointmentId),VoucherNumber = @MemberPlanDetailsId WHERE AppointmentId = @AppointmentId;  
				UPDATE EcomUserCart SET ItemIds='',TotalAmount=0,CouponCode=NULL,UpdatedBy=@UserName,UpdatedDate = @CurrentDate WHERE UserLoginId=@UserLoginId--For Ecom Cart Empty
				EXEC UspInsertNotificationData @AppointmentId, @MemberId, @UserLoginId, @FacilityIds
				SELECT @CaseNo=CaseNo FROM Appointment WHERE AppointmentId = @AppointmentId; 

				IF(ISNULL(@FilePrescription,'')<>'')
				BEGIN
					INSERT INTO ReportAppointment (MemberId,AppointmentId,ReportSavePath,DocType,IsActive,CreatedBy,CreatedDate) VALUES(@MemberId,@AppointmentId,@FilePrescription,'PRESCRIPTION','Y',@Username,GetDate())
				END
				SELECT @MessageCode = 'APPOINTMENTBOOKED',@Message ='Your appointment request has been received. We are working on the confirmation and you will soon receive the confirmation details on your email. You can also view the status of this appointment request in the appointments section'		
			END
		END
		/*********************************************[END] Appointment BOOKING Related Logic******************************************/

		/***********************************************Starting Payment************************************************************************/	
		IF(@NeedToBuy='Y')
		BEGIN

			--------------------Apply Coupon---------------------
			IF(ISNULL(@CouponCode,'')<>'')
			BEGIN
				INSERT INTO @ApplyCoupon([Status],SubCode,[Message],FinalAmount,DiscountAmount,CouponId,CouponCode)
				EXEC UspApplyCouponEcom @CouponCode,@FacilityAmount,@MobileNo
				
				SELECT @FacilityAmount = FinalAmount,@DiscountAmount = DiscountAmount,@CouponId=CouponId FROM @ApplyCoupon WHERE [Status]=1
			END
			--------------------Apply Coupon---------------------
			SELECT @ActualFacilityAmount= ISNULL(@FacilityAmount,0), @TotalAmount = ISNULL(@FacilityAmount,0) - ISNULL(@AvailableAmount,0), @GSTAmount=@TotalAmount*0.18, @TotalAmountIncludeGST= (@TotalAmount + @GSTAmount);  
		
			INSERT INTO UserTransactions(UserLoginId, UserPlanDetailsId, BucketId, PaymentGatewayType, TransactionMedium, Message, Status, Amount, TaxAmount, TotalAmount,PartialAmount, ActiveStatus, CreatedDate, UpdatedDate, CreatedBy, UpdatedBy)
			VALUES(@UserLoginId,@UserPlanDetailsId,@MemberPlanBucketId ,'RAZORPAY','ONLINE','Appointment Booking','Requested', @TotalAmount, @GSTAmount, @TotalAmountIncludeGST, ISNULL(@AvailableAmount,0) ,'Y', @CurrentDate, @CurrentDate, @UserName, @UserName)
			SET @IdU = SCOPE_IDENTITY();
	
			---------------------------------------------------------------------------------
			SET @TransactionId = CONCAT('HAR',@IdU,REPLACE(CONVERT(VARCHAR(8),@CurrentDate, 112) + CONVERT(VARCHAR(8),@CurrentDate, 114), ':',''))
			UPDATE UserTransactions SET TransactionId=@TransactionId WHERE Id=@IdU
 
			UPDATE HealthCoachRecommendation SET TransactionId = @TransactionId,@HealthCoachId=HealthCoachRecommendationId WHERE MemberId = @MemberId
		
			UPDATE HealthCoachRecommendationLog SET TransactionId = @TransactionId WHERE HealthCoachRecommendationId = @HealthCoachId
			UPDATE HealthCoachDetails SET TransactionId = @TransactionId WHERE HealthCoachRecommendationId = @HealthCoachId

			------------------------------------temporary insert request parameters in UserBookingRequest------------
			INSERT INTO UserBookingRequest(UserLoginId, ClientId, MemberId, UserPlanDetailsId, MemberPlanBucketId, FirstName, LastName, Gender, MobileNo, Email,Relation, ProviderId, FacilityIds, AppointmentId, AppointmentDate, AppointmentTime, VisitType, SlotId, Address, DoctorId,DocCoachApptType
			,DOB,ModeOfConsultation,SubSpecialityId,EncryptedUserLoginId,CouponCode,ModeOfPayment,PaymentStatus,TransactionId,PaymentMessage,RefId,FilePrescription,UserLatitude,UserLongitude,ServiceName,ParentAppointmentId, TotalAmount, CityId, StateId)
			VALUES(@UserLoginId, @ClientId, @MemberId, @UserPlanDetailsId, @MemberPlanBucketId, @FirstName, @LastName, @Gender, @MobileNo, @EmailId,@Relation ,@ProviderId, @FacilityIds, @AppointmentId, @AppointmentDate,@AppointmentTime, @VisitType, @SlotId, @Address, @DoctorId,@DocCoachApptType
			,@DOB,@ModeOfConsultation,@SubSpecialityId,@EncryptedUserLoginId,@CouponCode,@ModeOfPayment,@PaymentStatus,@TransactionId,@PaymentMessage,@RefId,@FilePrescription,@UserLatitude,@UserLongitude,@ServiceName,@ParentAppointmentId, @ActualFacilityAmount, @CityId, @StateId)

			-------------------------------------------------------end insertion-------------------------------------------------

			SELECT @MessageCode = 'STARTINGPAYMENT',@Message = 'initiate payment'
		END
		/***********************************************Starting Payment************************************************************************/	
	END
	ELSE
	BEGIN
		/*****************************RECHEDULE APPOINTMENT***************************************************/
		DECLARE @HAUserId BIGINT,@AppointmentLogId BIGINT,@CaseAssignLogId BIGINT,@PreviousScheduleStatus INT,@DefaultRole varchar(500),@ActualRate DECIMAL(18,3),@rSProviderId varchar(500) 
	
		INSERT INTO @TmpResheduled(PartnerOrderId,ProviderId,ProviderType,AppointmentDateTime,MemberId,MobileNo,ActualRate)
		SELECT DISTINCT Partner_orderid,AD.ProviderId,PR.ProviderTypeCode,AD.AppointmentDateTime,A.MemberId,A.MobileNo,0 AS ActualRate
		from Appointment A 
		JOIN AppointmentDetails AD ON A.AppointmentId=AD.AppointmentId
		JOIN HAPortalUAT.dbo.Provider PR ON AD.ProviderId=PR.ProviderId AND PR.IsActive='Y'
		WHERE A.AppointmentId=@AppointmentId

		UPDATE @TmpResheduled SET ActualRate=(SELECT SUM(ActualRate) AS ActualRate FROM(
		SELECT DISTINCT HAM.AgreedRate AS ActualRate
		FROM    AppointmentDetails AD 
			JOIN FacilitiesMaster FM  ON AD.PakageId=FM.FacilityID 
			JOIN HARateMaster     HAM ON HAM.FacilityId=AD.PakageId 
		WHERE   HAM.ClientId=0 
			AND AD.AppointmentId=@AppointmentId
			AND FM.IsActive  ='Y'
			AND HAM.IsActive ='Y'
			AND AD.IsActive  ='Y'
			AND HAM.FromDate <= @CurrentDate and @CurrentDate <= ISNULL(HAM.ToDate,@CurrentDate)
		UNION
		SELECT DISTINCT HAM.AgreedRate AS ActualRate
		FROM    AppointmentDetails AD 
			JOIN FacilitiesMaster FM  ON AD.TestId=FM.FacilityID 
			JOIN HARateMaster     HAM ON HAM.FacilityId=AD.TestId 
		WHERE   HAM.ClientId=0 and AD.PakageId=0 
			AND AD.AppointmentId=@AppointmentId
			AND FM.IsActive     ='Y'
			AND HAM.IsActive    ='Y'
			AND AD.IsActive     ='Y'
			) A)

		SELECT @PreviousScheduleStatus = ScheduleStatus,@SlotDetailId = SlotDetailId,@AlternateSlotDetailId = AlternateSlotDetailId FROM Appointment WHERE AppointmentId = @AppointmentId                                
		SELECT TOP 1 @AppointmentLogId = AppointmentLogId FROM AppointmentLog WHERE AppointmentId = @AppointmentId AND ScheduleStatus = @PreviousScheduleStatus ORDER BY CreatedDate DESC                                
                                
		SELECT @HAUserId = UserId FROM [HAPortalUAT].[dbo].[HAUser] WHERE HealthPassId = @UserLoginId                                
		SELECT @DefaultRole = h.DefaultRoleCode FROM [HAPortalUAT].dbo.HAUser h JOIN UserLogin u ON u.UserName = h.UserName WHERE u.UserLoginId = @UserLoginId;                                
    
		SELECT @ScheduleStatus = IIF(ISNULL(@DefaultRole, '') <> 'TELEDOC',1,2) FROM @TmpFacility WHERE ProcessCode = 'TDR' --for opertation tele doctor rechedule booking                               
		SELECT @ScheduleStatus = 2  FROM @TmpFacility WHERE ProcessCode = 'AskApollo'
		SET @ScheduleStatus=IIF(ISNULL(@ProviderFacilityCode,'')<>'',2,@ScheduleStatus)
		UPDATE [Appointment] SET [ScheduleStatus] = @ScheduleStatus,[DCConfirmationFlag] = CASE WHEN @scheduleStatus=1 THEN NULL ELSE DCConfirmationFlag END,
		[DCConfirmationStage] = CASE WHEN @scheduleStatus=1 THEN NULL ELSE DCConfirmationStage END,
		[VisitType] = @VisitType,[UpdatedBy] = @UserName,
		[UpdatedDate] = @CurrentDate,[AssignTo] = NULL,[PremiumFlag] = @PremiumFlag,[ModeOfConsultation] = @ModeOfConsultation,
		[SubSpecialityId] = @SubSpecialityId,[SubFacilityName] = @SubSpecialityName                             
		WHERE AppointmentId = @AppointmentId;

		IF ISNULL(@ModeOfConsultation,'')='Video'                                
		BEGIN                                
			UPDATE VideoConsultationData SET AppointmentDateTime=DATEADD(MINUTE, -15, @AppointmentDateTime),IsActive=1,LinkExpiryTime=DATEADD(hour,1,@AppointmentDateTime) WHERE AppointmentId=@AppointmentId;                                
		END 
	
		UPDATE [AppointmentDetails] SET [ProviderId] = @ProviderId,[AppointmentDateTime] = @AppointmentDateTime,[AlternateAppointmentDateTime] = @AlternateDateTime,[AppointmentScheduleDateTime] = @CurrentDate,                                
		[TestCompletionStatus] = IIF(TestCompletionStatus IN (1, 2, 3), @ScheduleStatus,TestCompletionStatus),[UpdatedBy] = @UserName,[UpdatedDate] = @CurrentDate                                
		FROM [AppointmentDetails] ad WHERE ad.AppointmentId = @AppointmentId AND TestCompletionStatus IN (1, 2, 3, 4, 8);                                

		INSERT INTO [AppointmentLog] ([AppointmentId],[ScheduleStatus],[Remarks],[UserLoginId],[CreatedBy],[CreatedDate])                                
		VALUES (@AppointmentId, @ScheduleStatus, 'Reschedule', @UserLoginId, @UserName, @CurrentDate)                                
		SET @LastApptLogId = SCOPE_IDENTITY();                                
                                
		INSERT INTO [dbo].[AppointmentLogDetails] ([AppointmentLogId],[AppointmentDetailId],[AppointmentDateTime],[TestCompletionStatus],[ProviderId],[HomeVisit],[CreatedBy],[CreatedDate])                                
		SELECT @LastApptLogId,ad.AppointmentDetailId,ad.AppointmentDateTime,ad.TestCompletionStatus,@ProviderId,ad.HomeVisit,@UserName,@CurrentDate FROM AppointmentDetails ad WHERE ad.AppointmentId = @AppointmentId

		UPDATE [dbo].[DoctorSlotDetails] SET [IsActive] = 'N',[UpdatedBy] = @UserName,[UpdatedDate] = @CurrentDate WHERE SlotDetailsId = @SlotDetailId                                
		UPDATE CaseAssignLog SET TaskEndDateTime = @CurrentDate,UpdatedBy = @UserName,UpdatedDate = @CurrentDate,@CaseAssignLogId=CaseAssignLogId FROM CaseAssignLog WHERE AppointmentId = @AppointmentId AND AssignTo = @HAUserId AND AppointmentLogId = @AppointmentLogId AND TaskEndDateTime IS NULL AND IsActive = 'Y'                                

		INSERT INTO CaseAssignLogDetails SELECT CaseAssignLogId, AssignTo,AssignBy,@UserName,@CurrentDate FROM CaseAssignLogDetails WHERE CaseAssignLogId = @CaseAssignLogId                                
		IF @AlternateSlotDetailId IS NOT NULL                                
		BEGIN                                
			 UPDATE [dbo].[DoctorSlotDetails] SET [IsActive] = 'N',[UpdatedBy] = @UserName, [UpdatedDate] = @CurrentDate WHERE SlotDetailsId = @AlternateSlotDetailId                                
		END                             

		IF (ISNULL(@SlotId, 0) > 0)                                
		BEGIN                                
			INSERT INTO [dbo].[DoctorSlotDetails] ([SlotId],[UserLoginId],[SlotDate],[SlotType],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])                                
			VALUES (@SlotId, @UserLoginId, @AppointmentDateTime, 'Booked by Customer', 'Y', @UserName, @CurrentDate, @UserName, @CurrentDate)                                
			SET @SlotDetailId = SCOPE_IDENTITY();                                
            
			UPDATE Appointment SET SlotDetailId = @SlotDetailId WHERE AppointmentId = @AppointmentId                              
                              
		END   

		EXEC UspInsertNotificationData @AppointmentId,@MemberId,@UserLoginId,@FacilityIds 
		SELECT @MessageCode = 'RECHEDULEAPPOINTMENT',@Message ='Your request for rescheduling appointment has been received. We are working on the confirmation and you will soon receive the confirmation details on your email. You can also view the status of this appointment request in the appointments section'
		/*****************************RECHEDULE APPOINTMENT***************************************************/
	END

/*****************************SELECT ALL TABLE***************************************************/
	SELECT @Status AS [Status],@SubCode AS SubCode,@MessageCode AS MessageCode,@Message AS [Message]--TABLE 1
	DECLARE @ClientName varchar(100);
	Declare @BUType varchar(10);
	select @ClientName =ClientName,@BUType=BUType from Client where ClientId=@ClientId

	/************************************** Added by Vikas for NTCspecialityId 3March23 ***************/
	CREATE TABLE #tempntcspecialityId(ntcspecialityId varchar(500));
	Declare @ntcspecialityId varchar(20);
	Insert into #tempntcspecialityId  SELECT F.NTCSpecialityID FROM dbo.SplitString(@FacilityIds,',') T JOIN FacilitiesMaster F ON T.Item=F.FacilityId
	select @ntcspecialityId=(select top 1 * from #tempntcspecialityId );
	/************************************** End of Vikas code 3March23 ***************/

	-------------------------TABLE 2------------------------------------
	IF(@MessageCode = 'APPOINTMENTBOOKED')
	BEGIN
		SELECT @Message AS [Message],@AppointmentId AS AppointmentId, CONCAT(@FirstName,' ',@LastName) AS FullName,@MobileNo AS MobileNo,@EmailId AS EmailId,@DOB AS DoB,@Gender AS Gender,IIF(@FacilityGroup='Tele-Consultation',1,0) AS IsInternalTeleConsultation,@ProviderFacilityCode AS ProviderFacilityCode,@SelectedMemberId AS SelfMemberId, @Relation AS Relation,@RSlotId AS SlotId,@Address AS [Address],@UserLatitude UserLatitude,@UserLongitude UserLongitude,@PartnerOrderId AS PartnerOrderId,@AppointmentDate AppointmentDate,@AppointmentTime AppointmentTime,@DoctorId DoctorId,@ModeOfConsultation ModeOfConsultation,@ProviderType ProviderType,IIF(@FacilityGroup='Doctor Coach',1,0) AS IsDoctorCoach,@CaseNo AS CaseNo,@FacilityIds AS FacilityIds,@ClientName as ClientName,@BUType as BUType,@CityName AS CityName,@Pincode AS Pincode,@ntcspecialityId as NTCSpecialityID,@ProviderName As ProviderName,@ProviderId AS ProviderId,@EmailId as Username, @StateId as StateId, @CityId AS CityId
		IF(ISNULL(@IsNotSendBookingEmail,0)=0)
		BEGIN
			EXEC [dbo].[uspSendAppointmentConfirmation] @AppointmentId,'INSERT' 
		END
	END
	ELSE IF(@MessageCode = 'STARTINGPAYMENT')
	BEGIN    
		SELECT @TransactionId AS TransactionId,@ServiceTax AS ServiceTax,@ActualFacilityAmount FacilityAmount,@GSTAmount AS GSTAmount,@TotalAmountIncludeGST AS AmountIncludingGST, @AvailableAmount as AvailableWalletAmount
	END	
	ELSE IF(@MessageCode = 'RECHEDULEAPPOINTMENT')
	BEGIN    
		SELECT @Message AS [Message],@AppointmentId AS AppointmentId, CONCAT(@FirstName,' ',@LastName) AS FullName,@MobileNo AS MobileNo,@EmailId AS EmailId,@DOB AS DoB,@Gender AS Gender,IIF(@FacilityGroup='Tele-Consultation',1,0) AS IsInternalTeleConsultation,@ProviderFacilityCode AS ProviderFacilityCode,@SelectedMemberId AS SelfMemberId, @Relation AS Relation,@RSlotId AS SlotId,@Address AS [Address],@UserLatitude UserLatitude,@UserLongitude UserLongitude,@PartnerOrderId AS PartnerOrderId,@AppointmentDate AppointmentDate,@AppointmentTime AppointmentTime,@DoctorId DoctorId,@ModeOfConsultation ModeOfConsultation,@ProviderType ProviderType,IIF(@FacilityGroup='Doctor Coach',1,0) AS IsDoctorCoach,@CaseNo AS CaseNo,@FacilityIds AS FacilityIds,@ClientName as ClientName,@BUType as BUType,@CityName AS CityName,@Pincode AS Pincode,@ProviderName As ProviderName,@ProviderId AS ProviderId, @StateId as StateId, @CityId AS CityId
		IF(ISNULL(@IsNotSendBookingEmail,0)=0)
		BEGIN
			EXEC [dbo].[uspSendAppointmentConfirmation] @AppointmentId,'INSERT'
		END
	END
	ELSE IF(@MessageCode ='APPOINTMENTBOOKINGFAILED')
	BEGIN
		SELECT ISNULL(@Message,'Appointment Booking Failed') AS [Message]
	END

	ELSE IF(@MessageCode ='SENDAPPOINTMENTBOOKEDLINK')
	BEGIN
		SELECT @TransactionId AS TransactionId,ISNULL(@Message,'Send Appointment Booking Link') AS [Message]
	END

	 SELECT fm.facilityid AS FacilityID,fm.facilityname AS FacilityName,fm.facilitytype AS FacilityType,
	        hm.AgreedRate AS AgreedRate, fm.IsFasting AS IsFasting from facilitiesmaster fm 
			JOIN haratemaster hm on fm.FacilityId=hm.FacilityId 
			JOIN dbo.SplitString(@FacilityIds,',') TM on TM.Item=fm.FacilityId 
	 WHERE  hm.ClientId=0

	 SELECT * FROM @TmpResheduled

/*****************************SELECT ALL TABLE***************************************************/

END
