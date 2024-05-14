USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspAppointmentBookingV3Ecom]    Script Date: 5/8/2024 1:29:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec UspAppointmentBookingV3Ecom 880085,927389,4396515,156,'773',0,'2023/05/25','11:30:00 PM',null,'CV',0,0,null,0,null,null,null,null,null,'',0,674,null,null,0,null,null,0,null,null,'F2F',null,null,null,null,null,0,'N',null,null,null,null,null,null,'N',null,null,null,0,null,0
ALTER PROCEDURE [dbo].[UspAppointmentBookingV3Ecom]                               
	@UserLoginId BIGINT,                                
	@MemberId BIGINT,       
	@MemberPlanId BIGINT = NULL,
	@ProviderId BIGINT=0,                                
	@FacilityIds VARCHAR(200)='', 
	@AppointmentId BIGINT = 0,--Only pass parameter for Appointment Reschedule
	@AppointmentDate DATE = NULL,                                
	@AppointmentTime TIME(3) = NULL,                                
	@PremiumFlag CHAR(1) = 'N',                               
	@VisitType CHAR(10) = 'CV',                                
	@SlotId BIGINT = 0,                                     
	@TDDoctorId BIGINT = NULL,                                
	@TDEdocDoctorId VARCHAR(50) = NULL, 
	@TDDoctorAmountWithGST INT=0,
	@TDCategoryId VARCHAR(50) = NULL,                      
	@TDAmount VARCHAR(50) = NULL,                                
	@TDAppointmentId VARCHAR(50) = NULL,                           
	@TDSpecialityId VARCHAR(50) = NULL,                             
	@AskApolloMerchantId VARCHAR(50) = NULL,                                
	@Address VARCHAR(5000) = '',                                
	@ProductOfferId BIGINT = 0,                                
	@DoctorId BIGINT = NULL,                                
	@AlternateAppointmentDate DATE = NULL,                   
	@AlternateAppointmentTime TIME(3) = NULL,                                
	@AlternateSlotId BIGINT = NULL,                               
	@FemaleAttendantReqd CHAR(1) = NULL,                                
	@MobileNo VARCHAR(50) = NULL,                                
	@CityId INT = NULL,                                
	@DocCoachApptType VARCHAR(50) = NULL,
	@DOB DATE = NULL,
	@ModeOfConsultation VARCHAR(10) = NULL,
	@SubSpecialityId BIGINT = NULL,
	@EncryptedUserLoginId VARCHAR(50) = NULL,              
	@IsConsent VARCHAR(10) = null,
	@HealthCoachFlag varchar(10)='N',
	@ReportPath VARCHAR(MAX)=NULL,
	@OpsUserLoginId BIGINT = 0,
	@NeedToBuy CHAR(1)='N',
	@CouponCode varchar(50) = NULL,
	@ModeOfPayment VARCHAR(50) = 'ONLINE',
	@PaymentStatus VARCHAR(10) = '',--Only pass parameter for after Payment Success
	@TransactionId VARCHAR(500) = NULL,--Only pass parameter for after Payment Success
	@PaymentMessage VARCHAR(500) = NULL,--Only pass parameter for after Payment Success 
	@RefId VARCHAR(500) = NULL,--Only pass parameter for after Payment Success
	@NeedToDirectBook CHAR(1)='N',--Need To Direct Book without payment
	@FilePrescription NVARCHAR(MAX)=NULL,
	@UserLatitude DECIMAL(18,15)=NULL,
	@UserLongitude DECIMAL(18,15)=NULL,
	@StateId INT=0,
	@ServiceName VARCHAR(200)=NULL,
	@IsSendBookingEmail BIT=0,
	@UserCurrentLat DECIMAL(18,15)=NULL,
	@UserCurrentLong DECIMAL(18,15)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/****************************Start DECLARE VARIABLES*********************************/
	DECLARE @SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX),@CurrentDate DATETIME=GETDATE(),@AcountType CHAR(1),@ProviderFacilityCode VARCHAR(200),@PartnerOrderId VARCHAR(200),@IsNotSendBookingEmail BIT=0
	DECLARE @MasterPlanType VARCHAR(50) = 'SERVICE',@SubSpecialityName VARCHAR(100),@AlternateDateTime DATETIME,@AppointmentDateTime DATETIME,@SelectedMemberId BIGINT,@MemberName VARCHAR(100),@InvoiceType VARCHAR(200)
	DECLARE @EmailId VARCHAR(100),@UserName VARCHAR(200),@ClientId BIGINT,@UserRoleId INT,@ScheduleStatus INT=1,@CorporatePlanId BIGINT,@PlanFromDate DATETIME,@PlanToDate DATETIME
	DECLARE @Area VARCHAR(200),@IsUnlimited CHAR(1)='N',@FacilityGroup VARCHAR(100),@AvailableAmount BIGINT=0,@BookFrom VARCHAR(100),@FacilityGroupId INT,@IsCreditAvailable VARCHAR(5)='N'
	DECLARE @NeedToAppointmentBook CHAR(1)='N',@MemberPlanDetailsId BIGINT,@FacilityAmount DECIMAL(18, 12),@AppointmentType VARCHAR(50),@LastApptLogId BIGINT,@SlotDetailId BIGINT,@AlternateSlotDetailId BIGINT
	DECLARE @MemberPaymentDetailsId BIGINT,@MessageCode VARCHAR(100),@ActualFacilityAmount BIGINT=0,@ClientType INT,@ProviderVisitType VARCHAR(5),@FacilityVisitType VARCHAR(5) 
	DECLARE @ServiceTax DECIMAL(8,2),@GSTAmount BIGINT,@TotalAmount BIGINT,@HAFullMarginRate DECIMAL(18,2),@HAPartialMarginRate DECIMAL(18,2),@HealthCoachId BIGINT
	DECLARE @FirstName VARCHAR(100),@LastName VARCHAR(100),@Gender VARCHAR(10),@Relation VARCHAR(100),@ServiceId BIGINT,@PartialPoints INT,@RSlotId BIGINT,@IntegratedRelation VARCHAR(100)
	DECLARE @ConvenienceFee DECIMAL(18,2),@MarginRate DECIMAL(18,2),@HARate DECIMAL(18,2),@ProviderRate DECIMAL(18,2),@CouponId BIGINT,@DiscountAmount DECIMAL(10, 3)
	DECLARE @ProviderType VARCHAR(50),@CaseNo VARCHAR(100)='',@Credit VARCHAR(200),@CityName VARCHAR (50),@Pincode VARCHAR(20),@LoginUsername varchar(100),@ProviderName VARCHAR(100),@PartialPnt int,@IntegrationProviderType VARCHAR(50)
	------------DECLARE TABLE-----------------------------------------
	DECLARE @TmpMemberPlanDetails TABLE(MemberPlanDetailsId BIGINT,MemberPlanId BIGINT, MemberId BIGINT,FacilityId BIGINT)
	DECLARE @TmpFacility TABLE(Id BIGINT IDENTITY (1, 1),FacilityId BIGINT,FacilityType VARCHAR(50),FacilityGroup VARCHAR(50),HARate DECIMAL(18, 2),ProviderRate DECIMAL(18, 2),ConvenienceFee DECIMAL(18,2),MemberPlanDetailsId BIGINT,ServiceType VARCHAR(50),ProcessCode VARCHAR(50),PackageId BIGINT,IsFasting VARCHAR(50),TestId BIGINT)    
	DECLARE @ApplyCoupon TABLE([Status] BIT,SubCode INT,[Message] VARCHAR(200),FinalAmount DECIMAL(10, 3),DiscountAmount DECIMAL(10, 3),CouponId BIGINT,CouponCode VARCHAR(100))  
	DECLARE @TmpResheduled TABLE(PartnerOrderId VARCHAR(200),ProviderId BIGINT,ProviderType VARCHAR(50),AppointmentDateTime DATETIME,MemberId BIGINT,MobileNo VARCHAR(20),ActualRate DECIMAL(18,3)) 
	CREATE TABLE #TmpHomeVisitCharge(ProviderHomeVisitCharge VARCHAR(200)) 
/****************************End DECLARE VARIABLES*********************************/ 
	----------------------------------CHECK USER------------------------------------------------------
	IF NOT EXISTS(SELECT 1 FROM Member WHERE UserLoginId=@UserLoginId AND MemberId=@MemberId)
	BEGIN
		SELECT 0 AS [Status],500 AS SubCode,'Bad Request, InValid User' AS [Message]--TABLE 1
		RETURN
	END
	-----------------------------------------------------------------------------------------
	IF(@PaymentStatus = 'Success' AND @TransactionId IS NOT NULL)
	BEGIN
		SELECT top 1 @ClientId= c.ClientId,@MemberId=c.MemberId,@VisitType=c.VisitType,@ProviderId=c.Providerid, @AppointmentDate= CONVERT(DATE, c.AppointmentDate,(select dbo.GetDateFormateCode(c.AppointmentDate))) ,@AppointmentTime=c.Appointmenttime,@UserName=CONCAT(c.FirstName,' ',c.LastName),@Relation=c.Relation,  
		@EmailID=c.Email,@MobileNo=c.Mobile,@SlotId=c.SlotId,@ProductOfferId=c.ProductOfferId,@TDDoctorId = c.TDDoctorId, @TDEdocDoctorId = c.TDUserId, @TDCategoryId = c.CategoryId, @TDAmount = c.TDAmount, @TDAppointmentId = c.TDAppointmentId,  
		@TDSpecialityId = c.TDSpecialityId, @AskApolloMerchantId = c.AskApolloMerchantId, @HealthCoachFlag = c.HealthCoachFlag,@ReportPath = c.ReportPath,@SubSpecialityId=c.SubSpecialityId,@PartialPoints=c.PartialPoints,
		@DOB = DOB, @Address = [Address],@DocCoachApptType=DocCoachApptType,@IsConsent=IsPrescriptionConsent,@CityId=c.cityid,@ModeOfConsultation=c.ModeOfConsultation,@UserLatitude=c.UserLatitude,@UserLongitude=c.UserLongitude,@StateId=c.StateId,@DoctorId=c.DoctorId
		FROM ClientMemberDetails c WHERE c.paymenttransid=@TransactionId
		SELECT @FacilityIds = STRING_AGG(Packageid,',') FROM ClientMemberDetails WHERE Paymenttransid=@TransactionId
		SELECT @MemberPlanId=MemberPlanId FROM MemberPaymentDetails WHERE TransactionId=@TransactionId	
	END
	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	SET @RSlotId=@SlotId
	UPDATE Member SET DOB = IIF(@DOB IS NOT NULL,@DOB,DOB), MobileNo = IIF(ISNULL(@MobileNo, '') <> '', @MobileNo,MobileNo) WHERE MemberId = @MemberId                              
	-----------------------------------------------------------------------------------------
/*********************************************[START] Facility AND Memeber Related Logic******************************************/
	INSERT INTO @TmpFacility(FacilityId,FacilityType,ServiceType,FacilityGroup,ProcessCode,IsFasting,PackageId,TestId,ConvenienceFee) 
	SELECT f.FacilityId,f.FacilityType,f.ServiceType,F.FacilityGroup,f.ProcessCode,F.isFasting,IIF(F.FacilityType ='TEST',0,f.FacilityId),IIF(F.FacilityType='TEST',f.FacilityId,0),F.ConvenienceFee FROM dbo.SplitString(@FacilityIds,',') T JOIN FacilitiesMaster F ON T.Item=F.FacilityId
	SELECT TOP 1 @FacilityGroup=IIF(ISNULL(@ServiceName,'')='',FacilityGroup,@ServiceName),@AppointmentType=ProcessCode FROM @TmpFacility
	SELECT @ServiceId=FacilityId FROM FacilitiesMaster WHERE FacilityGroup=@FacilityGroup AND ServiceType='SERVICE' AND IsActive='Y'
	UPDATE T SET T.PackageId=P.PackageId FROM PackageTestMaster p JOIN @TmpFacility T ON p.PackageId = t.FacilityId  AND t.FacilityType = 'PACKAGE';                                
	-------------------------------------------------------------------------------------------------
	SELECT @ProviderFacilityCode=(SELECT STRING_AGG(ProviderFacilityCode, ',') FROM ProviderFacilities p JOIN @TmpFacility t ON p.FacilityId=t.FacilityId WHERE ProviderId=@ProviderId AND IsActive='Y' AND ISNULL(ProviderFacilityCode,'')<>'')
		
	SELECT @ProviderType= P.ProviderTypeCode,@CityName=P.CityName,@Pincode=Pincode,@ProviderName=P.ProviderName,@IntegrationProviderType=P.IntegrationProviderType from haportal.dbo.Provider P  WHERE P.IsActive='Y' AND P.ProviderId=@ProviderId

	 --IF(@ProviderType='HEALTHIANS')
  -- 		BEGIN
  --     		IF ((select count(FacilityId) from @TmpFacility) <> (SELECT Count(P.ProviderFacilityCode) FROM ProviderFacilities p JOIN @TmpFacility t ON p.FacilityId=t.FacilityId WHERE ProviderId=@ProviderId AND IsActive='Y') )
  --     		BEGIN
		--		--SELECT 0 AS [Status],500 AS SubCode,'Invalid Test & Package' AS [Message]--TABLE 1
		--		set @SubCode=500 set @MessageCode='APPOINTMENTBOOKINGFAILED' set @Message='Invalid Test & Package'
		--		SELECT @Status AS [Status],@SubCode AS SubCode,@MessageCode AS MessageCode,@Message AS [Message]--TABLE 1
		--		SELECT ISNULL(@Message,'Invalid Test & Package') AS [Message] --
  --     			--SELECT @MessageCode = 'InvalidTest&Package'--TABLE 1
  --     		 RETURN
  --     		END
  --  END

	----------------------------------------GET PARTNER ORDER ID----------------------------------------
	SELECT  @PartnerOrderId = Partner_orderid FROM Appointment WHERE AppointmentId = @AppointmentId
	IF EXISTS(SELECT c.MemberPlanTypeId FROM MemberPlan m JOIN CorporatePlan c ON m.CorporatePlanId=c.CorporatePlanId JOIN MemberPlanType mt ON mt.MemberPlanTypeId=c.MemberPlanTypeId and mt.IsActive=1 WHERE m.FamilyMemberId=@MemberId)
	BEGIN --=>FamilyIndividual             
	   SELECT @SelectedMemberId = MemberId,@Area = Address1 FROM Member WHERE UserLoginId = @UserLoginId AND MemberId = @MemberId;                                    
	END              
	ELSE ---=>FamilyFloater              
	BEGIN              
	   SELECT @SelectedMemberId = MemberId,@Area = Address1 FROM Member WHERE UserLoginId = @UserLoginId AND Relation = 'SELF';              
	END 
	SELECT @MobileNo = MobileNo ,@Address = IIF(ISNULL(@Address,'')='',Address1,@Address),@Gender=Gender,@Relation=Relation,@DOB=DOB,@FirstName=FirstName,@LastName=LastName FROM Member WHERE MemberId=@MemberId;  
	IF(@OpsUserLoginId=0)  
	BEGIN                         
		SELECT  @UserName = CONCAT(FirstName, ' ', LastName),@EmailId = UserName,@UserRoleId = UserRoleId,@ClientType=UserTypeId FROM UserLogin WHERE UserLoginId = @UserLoginId; 
	END
	ELSE
	BEGIN
		SELECT @UserName = CONCAT(FirstName, ' ', LastName), @EmailId = UserName, @UserRoleId = UserRoleId,@ClientType=UserTypeId FROM UserLogin WHERE UserLoginId = @OpsUserLoginId;
	END
	IF(ISNULL(@MemberPlanId,0)=0)
	BEGIN
		SELECT @MemberPlanId = MemberPlanId,@CorporatePlanId = CorporatePlanId,@PlanFromDate = FromDate,@PlanToDate = CASE WHEN Todate > @CurrentDate THEN TODate ELSE DATEADD(Y, 1, @CurrentDate) END,@AcountType=IsCredits FROM MemberPlan  WHERE FamilyMemberId = @SelectedMemberId                                 
	END
	ELSE
	BEGIN
		SELECT @CorporatePlanId = CorporatePlanId,@PlanFromDate = FromDate,@PlanToDate = CASE WHEN Todate > @CurrentDate THEN TODate ELSE DATEADD(Y, 1, @CurrentDate) END,@AcountType=IsCredits FROM MemberPlan  WHERE FamilyMemberId = @SelectedMemberId AND MemberPlanId=@MemberPlanId                                 
	END
	SELECT @ClientId=ClientId,@InvoiceType=InvoiceType FROM CorporatePlan WHERE CorporatePlanId=@CorporatePlanId
	IF (ISNULL(@DoctorId,0)<> 0 and @FacilityGroup not in ('Family-Physician','Tele-Consultation'))    
	BEGIN    
		UPDATE @TmpFacility SET HARate = d.AppPriceGraded FROM HAModule.tele_consultaion.Doctor d WHERE d.DoctorId = @DoctorId 
	END
	ELSE
	BEGIN   
	    UPDATE T SET T.HARate = h.AgreedRate  FROM @TmpFacility T JOIN HARateMaster h ON T.FacilityId = h.FacilityId                               
		WHERE ClientId=ISNULL(@ClientId,0) AND h.FromDate <= @CurrentDate AND @CurrentDate <= ISNULL(h.ToDate, @CurrentDate) AND h.IsActive = 'Y'; 

		UPDATE T SET T.HARate =F.AppPrice1Graded FROM @TmpFacility T JOIN (SELECT * FROM (SELECT fm.FacilityId,fm.ProviderId,FM.AppPrice1Graded,COUNT(fm.RateId) OVER(PARTITION BY fm.ProviderId,fm.FacilityId ORDER BY fm.RateId) AS cnt FROM @TmpFacility T JOIN FacilitiesRateMster AS fm ON T.FacilityId = fm.FacilityId and fm.IsActive='Y' AND fm.FromDate <= @CurrentDate  and @CurrentDate <= ISNULL(fm.ToDate,@CurrentDate)
		AND FM.ProviderId = @ProviderId) AS T WHERE T.cnt=1) F ON F.FacilityId=T.FacilityId AND ISNULL(HARate,0)=0

		UPDATE T SET T.HARate = FM.AppPrice1Graded FROM @TmpFacility T JOIN FacilitiesRateMster AS fm ON T.FacilityId = fm.FacilityId and fm.IsActive='Y' AND fm.FromDate <= @CurrentDate  and @CurrentDate <= ISNULL(fm.ToDate,@CurrentDate) 
		AND FM.ProviderId = @ProviderId
		WHERE ISNULL(T.HARate,0)=0;

		UPDATE T SET T.HARate = h.AgreedRate  FROM @TmpFacility T JOIN HARateMaster h ON T.FacilityId = h.FacilityId                               
		WHERE ClientId=0 AND h.FromDate <= @CurrentDate AND @CurrentDate <= ISNULL(h.ToDate, @CurrentDate) AND h.IsActive = 'Y' and ISNULL(T.HARate,0)=0;
		--UPDATE T SET T.HARate = ISNULL(R.agreedrate_sum, H.AgreedRate) FROM @TmpFacility T 
		--LEFT JOIN (SELECT FacilityId, SUM(AppPrice1Graded) AS agreedrate_sum   FROM FacilitiesRateMster WHERE ProviderId = @ProviderId AND IsActive='Y' AND FromDate <= @CurrentDate  and @CurrentDate <= ISNULL(ToDate,@CurrentDate) GROUP BY FacilityId) R ON T.FacilityId = R.FacilityId
		--LEFT JOIN HARateMaster H ON T.FacilityId = H.FacilityId AND H.ClientId=0 AND H.FromDate <= @CurrentDate AND (@CurrentDate <= ISNULL(H.ToDate, @CurrentDate)) AND H.IsActive = 'Y' 
		--WHERE ISNULL(T.HARate,0)=0;
	END
	--UPDATE T SET T.ProviderRate = h.AgreedRate,HARate = ISNULL(h.HARate,T.HARate) FROM @TmpFacility T JOIN FacilitiesRateMster h  ON T.FacilityId = h.FacilityId WHERE h.FromDate <= @CurrentDate AND @CurrentDate <= ISNULL(h.ToDate, @CurrentDate) AND h.IsActive = 'Y' AND h.ProviderId = @ProviderId;
	--SELECT  @FacilityAmount = SUM(CASE WHEN ISNULL(HARAte, 0) > ISNULL(ProviderRate, 0) THEN ISNULL(HARAte, 0) ELSE ISNULL(ProviderRate, 0) END),@HARate=SUM(ISNULL(HARate,0)), @ProviderRate=SUM(ISNULL(ProviderRate,0)),@ConvenienceFee=SUM(ISNULL(ConvenienceFee,0)) FROM @TmpFacility
	SELECT  @FacilityAmount = SUM(ISNULL(HARAte, 0)),@HARate=SUM(ISNULL(HARate,0)), @ProviderRate=SUM(ISNULL(ProviderRate,0)),@ConvenienceFee=SUM(ISNULL(ConvenienceFee,0)) FROM @TmpFacility
	
	--IF (ISNULL(@DoctorId,0)<> 0)    
	--BEGIN  
	--	UPDATE @TmpFacility SET HARate = d.AppPriceGraded FROM HAModule.tele_consultaion.Doctor d WHERE d.DoctorId = @DoctorId 
	--	--SELECT @MarginRate = @HARate- ISNULL(Internal_ExternalRate,0) FROM DoctorMaster dm INNER JOIN DoctorProviderMapping dpm ON dpm.DoctorId=dm.DoctorId WHERE dm.IsActive='Y' AND dm.DoctorId=@TDDoctorId 
	--END
	--ELSE
	--BEGIN 
	--	SELECT @MarginRate=DefaultMargin FROM facilitiesmaster fm INNER JOIN @TmpFacility tf ON tf.facilityid=fm.facilityid AND fm.IsActive='Y'
	--END
/***********************************************[END] Facility AND Memeber Related Logic*****************************************************/

/****************By Anurag ****************/
		/*********************************************COUPON UTILISATION CHECK  Start*****************************************************************/

		--Set @CouponCode=ISNULL(@CouponCode,null)
		--PRINT @CouponCode
     IF(LTRIM(RTRIM(@CouponCode)) = '')
	 BEGIN
	  SET @CouponCode=null
	 END

	IF @CouponCode is not null
	begin
			CREATE TABLE #DiscountCouponDetails (Subcode int, Status varchar(MAX), Message varchar(MAX), DiscountAmount_Percent Int,Maxlimit decimal, DiscountType Varchar(100))
			   DECLARE @DiscountCouponPercentAmount int; 

	INSERT INTO #DiscountCouponDetails(Subcode,Status,Message,DiscountAmount_Percent,Maxlimit,DiscountType)
	EXEC [UspUserCouponValidation] @UserLoginId,@MemberPlanId,@MemberId,@FacilityIds,@ProviderId,@CouponCode
	DECLARE @DiscountAmount_Percent int; DECLARE @Maxlimit int; DECLARE @CSubcode int; DECLARE @CStatus varchar(100); DECLARE @CMessage VARCHAR(MAX); DECLARE @DiscountType Varchar(100);
	SELECT @CSubcode=Subcode,@Status=Status,@CMessage=Message,@DiscountAmount_Percent=ISNULL(DiscountAmount_Percent,0),@Maxlimit=ISNULL( Maxlimit,0),@DiscountType=DiscountType FROM #DiscountCouponDetails
	IF (@DiscountAmount_Percent is not null)
	begin
	PRINT @FacilityAmount
	  IF (@DiscountType='FIXED')
      BEGIN
          IF @DiscountAmount_Percent<=@Maxlimit
		   BEGIN
	         SET @FacilityAmount =@FacilityAmount-@DiscountAmount_Percent
          END
		  ELSE
		  BEGIN
		     SET @FacilityAmount=@FacilityAmount-@Maxlimit
		  END
      END
      ELSE
      BEGIN
	  PRINT @FacilityAmount
	       SET @DiscountCouponPercentAmount=((cast(@FacilityAmount as float) * @DiscountAmount_Percent)/100);
		      IF @DiscountCouponPercentAmount<=@Maxlimit
			  BEGIN
		         SET @FacilityAmount=@FacilityAmount - @DiscountCouponPercentAmount
              END
			  ELSE
			  BEGIN
			     SET @FacilityAmount=@FacilityAmount-@Maxlimit
			  END
	  END
	end
	end
	
	/*********************************************COUPON UTILISATION CHECK END*****************************************************************/

/****************** By Anurag ******************/

	/*********************************************GET HOME VISIT Charge Start*****************************************************************/
    PRINT @FacilityAmount PRINT @HARate PRINT @ProviderRate PRINT @ConvenienceFee
	DECLARE @HVChargesApplicable char(10)
	SELECT @HVChargesApplicable=HVChargesApplicable from CorporatePlan where CorporatePlanId=@CorporatePlanId
	PRINT @CorporatePlanId PRINT @HVChargesApplicable PRINT @FacilityAmount
	      IF (ISNULL(@HVChargesApplicable,'')<>'N')
	          BEGIN
	            IF @VisitType = 'HV'
	               BEGIN
	                 INSERT INTO #TmpHomeVisitCharge (ProviderHomeVisitCharge)
	                 EXEC [uspGetProviderHomeVisitChargesProvider] @FacilityIds,@ProviderId
	                 DECLARE @HOMEVISITCHARGE varchar (250);
	                 SELECT @HOMEVISITCHARGE = ISNULL(cast( ProviderHomeVisitCharge as BIGINT),0) FROM #TmpHomeVisitCharge
	                 IF @HOMEVISITCHARGE != ''
	                    BEGIN
	                      IF @FacilityAmount >=350
	                         BEGIN
	                           SET @HOMEVISITCHARGE=0;
	                         END
	                      SET @FacilityAmount = @FacilityAmount + CAST(@HOMEVISITCHARGE AS BIGINT);
	                    END
	               END
	          END
	
	/*********************************************GET HOME VISIT Charge END*****************************************************************/


/*********************************************[START] CHECK WALLET,Credit AND Unlimited Facility FOR BOOKING Related Logic******************************************/	
	print @NeedToBuy;
	IF(@NeedToBuy='N' AND ISNULL(@AppointmentId,0)=0 AND ISNULL(@TransactionId,'')='')
	BEGIN
		EXEC UspGetAvailableAmountEcom @SelectedMemberId,@MemberPlanId,@FacilityGroup,@AvailableAmount OUT,@BookFrom OUT,@FacilityGroupId OUT --GET AMOUNT
		
		IF(@AcountType='Y')
		BEGIN
			SELECT TOP 1 @Credit=ISNULL(MP.Credit,'N') FROM MemberPlanDetails mp JOIN @TmpFacility t ON mp.FacilityId = t.FacilityId WHERE mp.MemberId = @SelectedMemberId AND mp.ISActive = 'Y'                                 
			AND mp.MemberPlanId = @MemberPlanId AND T.FacilityGroup=@FacilityGroup
			IF(ISNULL(@Credit,'N')='N')
			BEGIN
				SELECT TOP 1 @Credit=ISNULL(MP.Credit,'N') FROM MemberPlanDetails mp WHERE mp.MemberId = @SelectedMemberId AND mp.FacilityId=@ServiceId AND mp.ISActive = 'Y'                                 
				AND mp.MemberPlanId = @MemberPlanId 
			END
		END

		SELECT TOP 1  @IsUnlimited = mp.IsUnlimited FROM MemberPlanDetails mp JOIN @TmpFacility t ON mp.FacilityId = t.FacilityId WHERE mp.MemberId = @SelectedMemberId AND mp.ISUtilized = 'N' AND mp.ISActive = 'Y'                                 
		AND mp.MemberPlanId = @MemberPlanId AND (mp.IsBuy = 'N' OR (mp.IsBuy = 'Y' AND mp.MasterPlanType = 'OPD')) AND T.FacilityGroup=@FacilityGroup
		IF(ISNULL(@IsUnlimited,'N')='N')
		BEGIN
			SELECT TOP 1  @IsUnlimited = mp.IsUnlimited FROM MemberPlanDetails mp WHERE mp.MemberId = @SelectedMemberId AND mp.FacilityId=@ServiceId AND mp.ISUtilized = 'N' AND mp.ISActive = 'Y'                                 
			AND mp.MemberPlanId = @MemberPlanId AND (mp.IsBuy = 'N' OR (mp.IsBuy = 'Y' AND mp.MasterPlanType = 'OPD'))
		END
    
		INSERT INTO @TmpMemberPlanDetails(MemberPlanDetailsId,MemberPlanId, MemberId,FacilityId)
		SELECT MemberPlanDetailsId,MemberPlanId,MemberId,FacilityId FROM (SELECT m.MemberPlanDetailsId,m.MemberPlanId,m.MemberId,m.FacilityId,ROW_NUMBER() OVER (PARTITION BY m.FacilityId order by m.FacilityId) AS FacilityIdCOUNT FROM @TmpFacility T JOIN MemberPlanDetails m ON m.FacilityId = T.FacilityId WHERE m.MemberId = @SelectedMemberId AND M.MemberPlanId=@MemberPlanId AND m.IsActive = 'Y' AND m.FromDate <= @CurrentDate                               
		AND @CurrentDate <= ISNULL(m.ToDate, @CurrentDate) AND IsUtilized = 'N' AND IsBuy = @NeedToBuy AND ISNULL(NULLIF(M.IsUnlimited,''),'N') ='N' AND T.FacilityGroup=@FacilityGroup) T
		WHERE T.FacilityIdCOUNT=1
		
		IF NOT EXISTS(SELECT 1 FROM @TmpMemberPlanDetails WHERE ISNULL(MemberPlanDetailsId, 0) > 0)
		BEGIN
			INSERT INTO @TmpMemberPlanDetails(MemberPlanDetailsId,MemberPlanId, MemberId,FacilityId)
			SELECT TOP 1 m.MemberPlanDetailsId,m.MemberPlanId,m.MemberId,m.FacilityId FROM @TmpFacility T JOIN MemberPlanDetails m ON (m.FacilityId = T.FacilityId OR m.FacilityId=@ServiceId) WHERE m.MemberId = @SelectedMemberId AND M.MemberPlanId=@MemberPlanId AND m.IsActive = 'Y' AND m.FromDate <= @CurrentDate                               
			AND @CurrentDate <= ISNULL(m.ToDate, @CurrentDate) AND IsUtilized = 'N' AND IsBuy = @NeedToBuy AND ISNULL(NULLIF(M.IsUnlimited,''),'N') ='N' AND T.FacilityGroup=@FacilityGroup
		END
		SELECT @IsCreditAvailable='Y' FROM @TmpMemberPlanDetails WHERE ISNULL(MemberPlanDetailsId, 0) > 0
	END
	ELSE
	BEGIN
		SELECT @FacilityGroupId=FacilityGroupCombinatonId FROM FacilityGroupCombinaton WHERE FacilityGroupName=@FacilityGroup AND IsActive='Y'
	END
/********************************************************[END]******************************************************************************************/
/*************************************************[START] Appointment VARIABLES*******************************************************************/
		SET @ScheduleStatus = IIF(ISNULL(@UserRoleId, 0) = 1,1,CASE WHEN @UserRoleId = 12 THEN 1 WHEN EXISTS(SELECT 1 FROM @TmpFacility WHERE ProcessCode = 'TDR') THEN 1 ELSE 2 END)-----SET Schedule Status--
		IF EXISTS(SELECT 1 FROM @TmpFacility WHERE FacilityGroup = 'Emergency Assistance') 
		BEGIN
			SELECT @ScheduleStatus=StatusId from StatuSmaster where StatusCode='FORWARDED'
		END
		SET @IsNotSendBookingEmail=IIF(@IntegrationProviderType='API' AND @ScheduleStatus=1,1,0)
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
		SET @AlternateDateTime = CASE WHEN ISNULL(@AlternateAppointmentDate, '') <> '' AND ISNULL(@AlternateAppointmentTime, '') <> '' THEN CAST(@AlternateAppointmentDate AS DATETIME) + CAST(@AlternateAppointmentTime AS DATETIME) ELSE NULL END                               

		SELECT @ProviderVisitType = IsHomeVisit FROM [dbo].[ProviderFacilities] WHERE ProviderId = @ProviderId AND FacilityID IN(SELECT facilityid FROM @TmpFacility)
		SELECT @FacilityVisitType = VisitType FROM [dbo].ClientPackageMaster WHERE FacilityID IN(SELECT facilityid FROM @TmpFacility)

		--IF(@ProviderVisitType = 'Y'  OR @FacilityVisitType = 'HV')
		--BEGIN
		--	SET @VisitType = 'HV'
		--END	
/*************************************************[END] Appointment VARIABLES*******************************************************************/
IF(ISNULL(@AppointmentId,0)=0)
BEGIN

	/********************************************[START] Appointment BOOKING Related Logic********************************************************/			   
	IF(@NeedToBuy='N')
	BEGIN
		IF(@PaymentStatus = 'Success' AND @TransactionId IS NOT NULL)
		
		BEGIN
		print 'in IF';
			SELECT @MemberPaymentDetailsId= m.MemberPaymentDetailsId,@ActualFacilityAmount=M.Amount,@CouponId=CouponId FROM ClientMemberDetails c 
			INNER JOIN MemberPaymentDetails m ON c.paymenttransid=m.TransactionId WHERE m.TransactionId=@TransactionId AND [Status] ='Requested'
			IF(@MemberPaymentDetailsId IS NOT NULL)
			BEGIN
				INSERT INTO [dbo].[MemberPlanDetails] ([MemberPlanId], [MemberId], [CorporatePlanId], [PlanType], [FacilityId], [FromDate], [ToDate], [IsUtilized], [Points], [IsBuy], [IsActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])             
				OUTPUT Inserted.MemberPlanDetailsId,Inserted.MemberPlanId,Inserted.MemberId,Inserted.FacilityId INTO @TmpMemberPlanDetails(MemberPlanDetailsId,MemberPlanId, MemberId,FacilityId)
				SELECT @MemberPlanId,@SelectedMemberId,@CorporatePlanId,ServiceType,FacilityId,@PlanFromDate,@PlanToDate,'N',0,'Y','Y',@UserName,@CurrentDate,@UserName,@CurrentDate FROM @TmpFacility WHERE ISNULL(MemberPlanDetailsId, 0) = 0;                                
				SELECT @BookFrom ='OnlinePayment', @NeedToAppointmentBook='Y'

				INSERT INTO NotificationHistory(UserLoginId,NotificationContent,CreatedOn,NotificationSendOn,NotificationStatus,Title,click_action,AppointmentId,IsPromotional)
				SELECT @UserLoginId,REPLACE(REPLACE(NotificationContent,'$service_name$',(SELECT STRING_AGG(ISNULL(FacilityName, ' '), ',') FROM FacilitiesMaster WHERE FacilityId IN(SELECT FacilityId FROM @TmpFacility))),'[CUSTOMERNAME]',CONCAT(@FirstName,' ',@LastName)),@CurrentDate,null,0,NotificationTitle,ISNULL(ClickAction,'appointments.healthassure'),@AppointmentId,0
				FROM Notificationcontenttitle WHERE NotificationContentId=7
			END
			ELSE 
			BEGIN
				SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'You have already booked this transaction',@MessageCode = 'APPOINTMENTBOOKINGFAILED'
			END
		END
		ELSE IF(ISNULL(@PaymentStatus,'')<>'' AND @PaymentStatus <> 'Success' AND @TransactionId IS NOT NULL)
		BEGIN
		print 'in Else IF 1';
			SELECT @MemberPaymentDetailsId= m.MemberPaymentDetailsId FROM ClientMemberDetails c INNER JOIN MemberPaymentDetails m ON c.paymenttransid=m.TransactionId WHERE m.TransactionId=@TransactionId
			IF(@MemberPaymentDetailsId IS NOT NULL)
			BEGIN
				UPDATE MemberPaymentDetails SET [Message] = @PaymentMessage,RefId = @RefId,Status = @PaymentStatus,UpdatedDate = @CurrentDate,UpdatedBy = @UserName  WHERE MemberPaymentDetailsId = @MemberPaymentDetailsId; 
				SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Appointment Booking Failed',@MessageCode = 'APPOINTMENTBOOKINGFAILED'
			END
			ELSE
			BEGIN
				SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Payment Failed, Appointment Booking Failed',@MessageCode = 'APPOINTMENTBOOKINGFAILED'
			END
		END
		ELSE IF((@BookFrom ='Credit' OR (@Credit='Y' AND @AcountType='Y')) AND @IsCreditAvailable = 'Y')
		BEGIN	
		print 'in Else IF 2';
			UPDATE M SET [UpdatedBy]=@UserName, [UpdatedDate]=@CurrentDate FROM [dbo].[MemberPlanDetails] M JOIN @TmpMemberPlanDetails T ON T.MemberPlanDetailsId=M.MemberPlanDetailsId AND T.FacilityId=M.FacilityId
			SET @NeedToAppointmentBook='Y'
		END
		ELSE IF((@BookFrom ='Credit' OR (@Credit='Y' AND @AcountType='Y')) AND ISNULL(@IsUnlimited,'N')='Y')
		BEGIN
		print 'in Else IF 3';
			INSERT INTO [dbo].[MemberPlanDetails] ([MemberPlanId], [MemberId], [CorporatePlanId], [PlanType], [FacilityId], [FromDate], [ToDate], [IsUtilized], [Points], [IsBuy], [IsUnlimited], [IsActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[MasterPlanType]) 
			OUTPUT Inserted.MemberPlanDetailsId,Inserted.MemberPlanId,Inserted.MemberId,Inserted.FacilityId INTO @TmpMemberPlanDetails(MemberPlanDetailsId,MemberPlanId, MemberId,FacilityId)
			SELECT @MemberPlanId, @SelectedMemberId,@CorporatePlanId,ServiceType,FacilityId,@PlanFromDate,@PlanToDate,'N',0,'N','N','Y',@UserName,@CurrentDate,@UserName,@CurrentDate,@MasterPlanType FROM @TmpFacility 
			SET @NeedToAppointmentBook='Y'
		END
		ELSE IF((@BookFrom ='Wallet' AND @AvailableAmount >= @FacilityAmount AND ISNULL(@Credit,'N')='N') OR ISNULL(@NeedToDirectBook,'N')='Y')
		BEGIN
		print 'in Else IF 4';
			INSERT INTO [dbo].[MemberPlanDetails] ([MemberPlanId], [MemberId], [CorporatePlanId], [PlanType], [FacilityId], [FromDate], [ToDate], [IsUtilized], [Points], [IsBuy], [IsActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])      
			OUTPUT Inserted.MemberPlanDetailsId,Inserted.MemberPlanId,Inserted.MemberId,Inserted.FacilityId INTO @TmpMemberPlanDetails(MemberPlanDetailsId,MemberPlanId, MemberId,FacilityId)
			SELECT @MemberPlanId,@SelectedMemberId,@CorporatePlanId,ServiceType,FacilityId,@PlanFromDate,@PlanToDate,'Y',CAST(@FacilityAmount AS BIGINT),'N','Y',@UserName,@CurrentDate,@UserName,@CurrentDate FROM @TmpFacility WHERE ISNULL(MemberPlanDetailsId, 0) = 0;  
			SET @NeedToAppointmentBook='Y'
		END
		ELSE
		BEGIN
		print 'in Else';
			SELECT @NeedToAppointmentBook = 'N',@NeedToBuy='Y' PRINT 'Starting Payment' 
		END
		IF(ISNULL(@ProviderFacilityCode,'')<>'' AND EXISTS(SELECT TOP 1 1 FROM Appointment a JOIN AppointmentDetails d ON a.AppointmentId=d.AppointmentId JOIN ProviderFacilities f ON f.FacilityId=d.PakageId AND d.ProviderId=f.ProviderId AND f.IsActive='Y' JOIN HAPortal.dbo.provider P ON F.providerId=P.providerId  WHERE UserLoginId=@UserLoginId AND MobileNo=@MobileNo AND ScheduleStatus NOT IN(6,7) AND P.ProviderTypeCode='HEALTHIANS'))
		BEGIN
			SELECT @BookFrom ='OnlinePaymentFailed',@Message = 'Dear '+CONCAT(@FirstName,' ',@LastName)+', you have an on going appointment request with the us for this user. For additional queries please connect with us at +91-22-6167-6600.',@MessageCode = 'APPOINTMENTBOOKINGFAILED',@NeedToAppointmentBook='N'
		END
		IF(@NeedToAppointmentBook='Y' and  @TransactionId IS NULL and @IsSendBookingEmail=1)
		   Begin
				SET @MemberPaymentDetailsId = FLOOR(RAND() * (1000 - 1 + 1)) + 1;
				SELECT @TransactionId = CONCAT('HA',@MemberPaymentDetailsId,REPLACE(CONVERT(VARCHAR(8),@CurrentDate, 112)+CONVERT(VARCHAR(8),@CurrentDate, 114), ':',''))

				INSERT INTO ClientAnonymousbookingDetails(clientid,memberid,memberPlanId,FirstName,LastName,Gender,Relation,Mobile,Email,cityid,CityName,Area,AppointmentDate,Appointmenttime,VisitType,Packageid,Providerid,SiteTransactionId,paymenttransid,SlotId,createdby,createddate,updatedby,updateddate,[address],pincode,agentcode,UserSelfRegistrationId,ClientCustId,IsBuy
				,PartialPoints,IsHealthCoach,TDDoctorId,TDUserId,TDAppointmentId,CategoryId,TDAmount,TDSpecialityId,AskApollomerchantId,HealthCoachFlag,ReportPath, DOB,AskApolloPartnerReferenceId, ModeOfConsultation,SubSpecialityId,SubFacilityName,DocCoachApptType,IsPrescriptionConsent,UserLatitude,UserLongitude,StateId,DoctorId)
				SELECT @ClientId,@MemberId,@MemberPlanId,@FirstName,@LastName,@Gender,@Relation,@MobileNo,NULL,@CityId,NULL,NULL,@AppointmentDate,@AppointmentTime,@VisitType,t.facilityid,@ProviderId,null,@TransactionId,@RSlotId,@UserName,@CurrentDate,@UserName,@CurrentDate,@Address,null,null,null,null,IIF(ISNULL(@AvailableAmount,0)<>0,'P','Y'),@AvailableAmount,CASE WHEN @ModeOfPayment = 'Cash' THEN 'Y' ELSE 'N' END,
				@TDDoctorId, @TDEdocDoctorId,@TDAppointmentId, @TDCategoryId,IIF(ISNULL(@TDEdocDoctorId,'')<>'', @TDDoctorAmountWithGST, @TDAmount),@TDSpecialityId, @AskApollomerchantId,@HealthCoachFlag,@ReportPath,@DOB,IIF(t.facilityid = 580, CONVERT(VARCHAR(20),@MemberId) +'_'+ @TDAppointmentId,NULL),@ModeOfConsultation,@SubSpecialityId,@SubSpecialityName,@DocCoachApptType,@IsConsent,@UserLatitude,@UserLongitude,@StateId,@DoctorId
				FROM @TmpFacility t;

				UPDATE [dbo].[ClientAnonymousbookingDetails] SET paymenttransid = @TransactionId WHERE paymenttransid=@TransactionId

				SELECT @MessageCode = 'SENDAPPOINTMENTBOOKEDLINK',@Message ='Your appointment request has been received, You will recieve appointment confirmation details over your email id.'	
		   End

		ELSE IF(@NeedToAppointmentBook='Y')
		BEGIN		
			INSERT INTO [dbo].[Appointment] ([MemberId],[UserTypeMappingId],[UserLoginId],[FemaleAttendantReqd],[ScheduleStatus],[VisitType],[DoctorrId],[AppointmentType],[PremiumFlag],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[CityId]                                
            ,[ClientId],[MobileNo],[Area],[AppointmentAddress],[TDDoctorId],[TDUserId],[TDAppointmentId],[CategoryId],[TDAmount],[TDSpecialityId],[AskApolloMerchantId],[DocCoachApptType],[ModeOfConsultation],[SubSpecialityId],[SubFacilityName],[IsPrescriptionConsent],BookedVia,UserLatitude,UserLongitude,StateId,CouponCode, UserCurrentLat, UserCurrentLong)                      
            VALUES (@MemberId, 1, @UserLoginId, @FemaleAttendantReqd, @ScheduleStatus, @VisitType, @DoctorId, @AppointmentType, ISNULL(@PremiumFlag, 'N'), 'Y', @UserName, @CurrentDate, @UserName, @CurrentDate, @CityId, @ClientId, @MobileNo, @Area, @Address, @TDDoctorId, 
			@TDEdocDoctorId, @TDAppointmentId, @TDCategoryId, @TDAmount, @TDSpecialityId, @AskApolloMerchantId, @DocCoachApptType, @ModeOfConsultation, @SubSpecialityId,@SubSpecialityName,@IsConsent,CASE WHEN @BookFrom='OnlinePayment' THEN IIF(ISNULL(@PartialPoints,0)<>0,'Wallet and Payment','Payment') ELSE @BookFrom END,@UserLatitude,@UserLongitude,@StateId,@CouponCode, @UserCurrentLat, @UserCurrentLong);                   

            SET @AppointmentId = SCOPE_IDENTITY()
			SET @SelectedMemberId=@MemberId

			INSERT INTO [dbo].[AppointmentDetails] ([AppointmentId],[TestId],[PakageId],[ProviderId],[AppointmentDateTime],[AlternateAppointmentDateTime],[AppointmentScheduleDateTime],[HomeVisit],[Fasting],[TestCompletionStatus],[TestCompletionRemark],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],FacilityAmount)                                 
			SELECT @AppointmentId,P.TestId,P.PackageId,@ProviderId,@AppointmentDateTime,@AlternateDateTime,@CurrentDate,@VisitType,T.IsFasting,1,'','Y',@UserName,@CurrentDate,@UserName,@CurrentDate,t.HARate FROM PackageTestMaster p JOIN @TmpFacility t                                
			ON p.PackageId = t.FacilityId  AND t.FacilityType = 'PACKAGE'                                
			UNION
			SELECT @AppointmentId,t.TestId,t.PackageId,@ProviderId,@AppointmentDateTime,@AlternateDateTime,@CurrentDate,@VisitType,t.isFasting,1,'','Y',@UserName,@CurrentDate,@UserName,@CurrentDate,t.HARate FROM @TmpFacility t WHERE t.FacilityType<>'PACKAGE' 
			
			INSERT INTO [dbo].[AppointmentLog] ([AppointmentId],[ScheduleStatus],[UserLoginId],[CreatedBy],[CreatedDate],[ProviderId])                                
            VALUES (@AppointmentId, @ScheduleStatus, @UserLoginId, @UserName, @CurrentDate,@ProviderId)                                
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
				IF @AlternateSlotId IS NOT NULL                                
                BEGIN                                
					INSERT INTO [dbo].[DoctorSlotDetails] ([SlotId],[UserLoginId],[SlotDate],[SlotType],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])                                
                    VALUES (@AlternateSlotId, @UserLoginId, @AlternateDateTime, 'Booked by Customer','Y', @UserName, @CurrentDate, @UserName, @CurrentDate)                                
					SET @AlternateSlotDetailId = SCOPE_IDENTITY();                                
					UPDATE Appointment SET AlternateSlotDetailId = @AlternateSlotDetailId WHERE AppointmentId = @AppointmentId                                
                END                                
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
			SELECT TOP 1 @MemberPlanDetailsId=MemberPlanDetailsId FROM @TmpMemberPlanDetails

			UPDATE m SET AppointmentId = @AppointmentId,IsUtilized='Y',Points = 0,facilitygroupcombinationid=@FacilityGroupId 
			FROM MemberPlanDetails m JOIN @TmpMemberPlanDetails t ON t.FacilityId=m.FacilityId AND m.MemberPlanDetailsId = T.MemberPlanDetailsId AND M.MemberId=T.MemberId AND m.IsActive='Y'

			UPDATE M SET M.Points = CASE WHEN (@BookFrom ='Credit' OR ISNULL(@IsCreditAvailable,'N') = 'Y' OR ISNULL(@IsUnlimited,'N')='Y') THEN '0' ELSE CAST(@FacilityAmount AS BIGINT) END 
			FROM MemberPlanDetails M WHERE m.MemberPlanDetailsId = @MemberPlanDetailsId AND m.IsActive='Y'

			UPDATE [Appointment] SET CaseNo = [dbo].[fnGetCaseNo](@AppointmentId),VoucherNumber = @MemberPlanDetailsId,ProviderTypeCode=@ProviderType WHERE AppointmentId = @AppointmentId;  
			UPDATE EcomUserCart SET ItemIds='',TotalAmount=0,CouponCode=NULL,UpdatedBy=@UserName,UpdatedDate = @CurrentDate WHERE UserLoginId=@UserLoginId--For Ecom Cart Empty
			EXEC UspInsertNotificationData @AppointmentId, @MemberId, @UserLoginId, @FacilityIds
			SELECT @CaseNo=CaseNo FROM Appointment WHERE AppointmentId = @AppointmentId; 
			IF(@BookFrom ='OnlinePayment')
			BEGIN
			  ---------Added for Partial Points--------
				select @PartialPnt = TotalAmount from MemberPaymentDetails where MemberPaymentDetailsid=@MemberPaymentDetailsId
				UPDATE MemberPaymentDetails SET [Message] = @PaymentMessage,MemberPlanId=@MemberPlanId,RefId = @RefId,[Status] = @PaymentStatus,UpdatedDate = @CurrentDate,UpdatedBy = @UserName  WHERE MemberPaymentDetailsId = @MemberPaymentDetailsId; 
				UPDATE MemberPlanDetails SET MemberPaymentDetailsId = @MemberPaymentDetailsId WHERE AppointmentId = @AppointmentId;      
				UPDATE MemberPlanDetails SET Points = c.PartialPoints,PartialPoints=@PartialPnt FROM ClientMemberDetails c WHERE c.PackageId = MemberPlanDetails.FacilityId AND c.paymenttransid = @TransactionId AND MemberPlanDetails.AppointmentId = @AppointmentId;    
				UPDATE MemberPlan SET BuyAmount=ISNULL(BuyAmount,0)+@ActualFacilityAmount WHERE MemberPlanId=@MemberPlanId 
				UPDATE Coupon SET Limit = Limit-1,UpdatedBy=@UserName, UpdatedDate=@CurrentDate WHERE CouponId = @CouponId
				IF ISNULL(@ProductOfferId,0) > 0   
				BEGIN     
					DECLARE @UtilizeFor VARCHAR(100); 
					SELECT @UtilizeFor = PromoCodeType from ProductOffer where ProductOfferID=@ProductOfferId;  
					INSERT INTO [dbo].[MemberOfferUtilization] ([ProductOfferId],[UserLoginId],[UtilizationDate],[UtilizeFor],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[MemberPaymentDetailsId])  
					SELECT @ProductOfferId,@UserLoginId,@CurrentDate,@UtilizeFor,'Y',@UserName,@CurrentDate,@UserName,@CurrentDate,@MemberPaymentDetailsId;   
				END 
				IF @ReportPath IS NOT NULL  
				BEGIN  
					Exec [dbo].[uspInsertHealthRecordDetails]@UserLoginId,@ClientId,@MemberId,NULL,NULL,NULL,3,@ReportPath,@AppointmentId  
				END  
				IF (@HealthCoachFlag = 'Y')  
				BEGIN  
					CREATE TABLE #tempHealthCoachSMSdetails(Message varchar(500))
					Insert into #tempHealthCoachSMSdetails  
					Exec [dbo].[uspSendHealthCoachCashSMS] @UserLoginId, @TransactionId,'HealthCoach'  
				END 
			END
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
		If(ISNULL(@TDEdocDoctorId,'')<>'') 
		BEGIN
			SELECT @ActualFacilityAmount = @TDDoctorAmountWithGST, @GSTAmount =0, @TotalAmount = @TDAmount
		END
		ELSE 
		BEGIN
			--------------------Apply Coupon---------------------
			IF(ISNULL(@CouponCode,'')<>'')
			BEGIN
				INSERT INTO @ApplyCoupon([Status],SubCode,[Message],FinalAmount,DiscountAmount,CouponId,CouponCode)
				EXEC UspApplyCouponEcom @CouponCode,@FacilityAmount,@MobileNo
				
				SELECT @FacilityAmount = FinalAmount,@DiscountAmount = DiscountAmount,@CouponId=CouponId FROM @ApplyCoupon WHERE [Status]=1
			END
			--------------------Apply Coupon---------------------
			SELECT @ActualFacilityAmount= ISNULL(@FacilityAmount,0),@TotalAmount = ISNULL(@FacilityAmount,0) - ISNULL(@AvailableAmount,0),@GSTAmount=0
			--EXEC UspCalculateGstAmountEcom @AvailableAmount,@FacilityAmount,@FacilityGroup,@HARate,@ProviderRate,@ConvenienceFee,@MarginRate,@AcountType,@ActualFacilityAmount OUT,@ServiceTax OUT,@GSTAmount OUT,@TotalAmount OUT,@HAFullMarginRate OUT,@HAPartialMarginRate OUT
		END
		INSERT INTO [dbo].[MemberPaymentDetails]([MemberPlanId],[Amount],[ServiceTaxAmount],[TotalAmount],[Status],[TransactionId],[ClientType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[UserLoginId],[ModeOfPayment],[DiscountAmount],CouponId)
		SELECT @MemberPlanId,@ActualFacilityAmount,@GSTAmount,@TotalAmount,'Requested',0,@ClientType,@UserName,@CurrentDate,@UserName,@CurrentDate,@UserLoginId,@ModeOfPayment,@DiscountAmount,@CouponId
		SET @MemberPaymentDetailsId = SCOPE_IDENTITY();
		   
		SELECT @TransactionId = CONCAT('HA',@MemberPaymentDetailsId,REPLACE(CONVERT(VARCHAR(8),@CurrentDate, 112)+CONVERT(VARCHAR(8),@CurrentDate, 114), ':',''))
		UPDATE [dbo].[MemberPaymentDetails] SET TransactionId = @TransactionId,HAFullMarginrate=@HAFullMarginRate ,HAPartialMarginrate=@HAPartialMarginRate,Conveniencefeecharged=@ConvenienceFee WHERE MemberPaymentDetailsId = @MemberPaymentDetailsId;
 
		UPDATE HealthCoachRecommendation SET TransactionId = @TransactionId,@HealthCoachId=HealthCoachRecommendationId WHERE MemberId = @MemberId
		
		UPDATE HealthCoachRecommendationLog SET TransactionId = @TransactionId WHERE HealthCoachRecommendationId = @HealthCoachId
		UPDATE HealthCoachDetails SET TransactionId = @TransactionId WHERE HealthCoachRecommendationId = @HealthCoachId

		IF(@IsSendBookingEmail=1)
		   BEGIN
				INSERT INTO ClientAnonymousbookingDetails(clientid,memberid,memberPlanId,FirstName,LastName,Gender,Relation,Mobile,Email,cityid,CityName,Area,AppointmentDate,Appointmenttime,VisitType,Packageid,Providerid,SiteTransactionId,paymenttransid,SlotId,createdby,createddate,updatedby,updateddate,[address],pincode,agentcode,UserSelfRegistrationId,ClientCustId,IsBuy
				,PartialPoints,IsHealthCoach,TDDoctorId,TDUserId,TDAppointmentId,CategoryId,TDAmount,TDSpecialityId,AskApollomerchantId,HealthCoachFlag,ReportPath, DOB,AskApolloPartnerReferenceId, ModeOfConsultation,SubSpecialityId,SubFacilityName,DocCoachApptType,IsPrescriptionConsent,UserLatitude,UserLongitude,StateId,DoctorId,ServiceName)
				SELECT @ClientId,@MemberId,@MemberPlanId,@FirstName,@LastName,@Gender,@Relation,@MobileNo,NULL,@CityId,NULL,NULL,@AppointmentDate,@AppointmentTime,@VisitType,t.facilityid,@ProviderId,null,@TransactionId,@SlotId,@UserName,@CurrentDate,@UserName,@CurrentDate,@Address,null,null,null,null,IIF(ISNULL(@AvailableAmount,0)<>0,'P','Y'),@AvailableAmount,CASE WHEN @ModeOfPayment = 'Cash' THEN 'Y' ELSE 'N' END,
				@TDDoctorId, @TDEdocDoctorId,@TDAppointmentId, @TDCategoryId,IIF(ISNULL(@TDEdocDoctorId,'')<>'', @TDDoctorAmountWithGST, @TDAmount),@TDSpecialityId, @AskApollomerchantId,@HealthCoachFlag,@ReportPath,@DOB,IIF(t.facilityid = 580, CONVERT(VARCHAR(20),@MemberId) +'_'+ @TDAppointmentId,NULL),@ModeOfConsultation,@SubSpecialityId,@SubSpecialityName,@DocCoachApptType,@IsConsent,@UserLatitude,@UserLongitude,@StateId,@DoctorId,@ServiceName
				FROM @TmpFacility t;
		   END
        ELSE
		   BEGIN
				INSERT INTO ClientMemberDetails(clientid,memberid,FirstName,LastName,Gender,Relation,Mobile,Email,cityid,CityName,Area,AppointmentDate,Appointmenttime,VisitType,Packageid,Providerid,SiteTransactionId,paymenttransid,SlotId,createdby,createddate,updatedby,updateddate,[address],pincode,agentcode,UserSelfRegistrationId,ClientCustId,IsBuy
				,PartialPoints,IsHealthCoach,TDDoctorId,TDUserId,TDAppointmentId,CategoryId,TDAmount,TDSpecialityId,AskApollomerchantId,HealthCoachFlag,ReportPath, DOB,AskApolloPartnerReferenceId, ModeOfConsultation,SubSpecialityId,SubFacilityName,DocCoachApptType,IsPrescriptionConsent,UserLatitude,UserLongitude,StateId,DoctorId,CouponCode)
				SELECT @ClientId,@MemberId,@FirstName,@LastName,@Gender,@Relation,@MobileNo,NULL,@CityId,NULL,NULL,@AppointmentDate,@AppointmentTime,@VisitType,t.facilityid,@ProviderId,null,@TransactionId,@SlotId,@UserName,@CurrentDate,@UserName,@CurrentDate,@Address,null,null,null,null,IIF(ISNULL(@AvailableAmount,0)<>0,'P','Y'),@AvailableAmount,CASE WHEN @ModeOfPayment = 'Cash' THEN 'Y' ELSE 'N' END,
				@TDDoctorId, @TDEdocDoctorId,@TDAppointmentId, @TDCategoryId,IIF(ISNULL(@TDEdocDoctorId,'')<>'', @TDDoctorAmountWithGST, @TDAmount),@TDSpecialityId, @AskApollomerchantId,@HealthCoachFlag,@ReportPath,@DOB,IIF(t.facilityid = 580, CONVERT(VARCHAR(20),@MemberId) +'_'+ @TDAppointmentId,NULL),@ModeOfConsultation,@SubSpecialityId,@SubSpecialityName,@DocCoachApptType,@IsConsent,@UserLatitude,@UserLongitude,@StateId,@DoctorId,@CouponCode
				FROM @TmpFacility t;
		  END
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
	JOIN HAPortal.dbo.Provider PR ON AD.ProviderId=PR.ProviderId AND PR.IsActive='Y'
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

    
	SELECT @PreviousScheduleStatus = ScheduleStatus,@SlotDetailId = SlotDetailId,@AlternateSlotDetailId = AlternateSlotDetailId, @SelectedMemberId=MemberId FROM Appointment WHERE AppointmentId = @AppointmentId    
	Print '@PreviousScheduleStatus'
	Print @PreviousScheduleStatus
    SELECT TOP 1 @AppointmentLogId = AppointmentLogId FROM AppointmentLog WHERE AppointmentId = @AppointmentId AND ScheduleStatus = @PreviousScheduleStatus ORDER BY CreatedDate DESC                                
                                
    SELECT @HAUserId = UserId FROM [HAPortal].[dbo].[HAUser] WHERE HealthPassId = @UserLoginId                                
    SELECT @DefaultRole = h.DefaultRoleCode FROM [HAPortal].dbo.HAUser h JOIN UserLogin u ON u.UserName = h.UserName WHERE u.UserLoginId = @UserLoginId;                                
    
	SELECT @ScheduleStatus = IIF(ISNULL(@DefaultRole, '') <> 'TELEDOC',1,2) FROM @TmpFacility WHERE ProcessCode = 'TDR' --for opertation tele doctor rechedule booking                               
	SELECT @ScheduleStatus = 2  FROM @TmpFacility WHERE ProcessCode = 'AskApollo'
	SET @ScheduleStatus=IIF(ISNULL(@ProviderFacilityCode,'')<>'' AND @IntegrationProviderType='API',2,@ScheduleStatus)
	UPDATE [Appointment] SET [ScheduleStatus] = @ScheduleStatus,[DCConfirmationFlag] = CASE WHEN @scheduleStatus=1 THEN NULL ELSE DCConfirmationFlag END,
	[DCConfirmationStage] = CASE WHEN @scheduleStatus=1 THEN NULL ELSE DCConfirmationStage END,
	[VisitType] = @VisitType,[UpdatedBy] = @UserName,ProviderTypeCode=@ProviderType,
	[UpdatedDate] = @CurrentDate,[AssignTo] = NULL,[PremiumFlag] = @PremiumFlag,[ModeOfConsultation] = @ModeOfConsultation,
	[TDDoctorId] = @TDDoctorId,[SubSpecialityId] = @SubSpecialityId,[SubFacilityName] = @SubSpecialityName,[IsPrescriptionConsent]=@IsConsent                             
    WHERE AppointmentId = @AppointmentId;

	IF ISNULL(@ModeOfConsultation,'')='Video'                                
    BEGIN                                
		UPDATE VideoConsultationData SET AppointmentDateTime=DATEADD(MINUTE, -15, @AppointmentDateTime),IsActive=1,LinkExpiryTime=DATEADD(hour,1,@AppointmentDateTime) WHERE AppointmentId=@AppointmentId;                                
    END 
	
    UPDATE [AppointmentDetails] SET [ProviderId] = @ProviderId,[AppointmentDateTime] = @AppointmentDateTime,[AlternateAppointmentDateTime] = @AlternateDateTime,[AppointmentScheduleDateTime] = @CurrentDate,                                
    [TestCompletionStatus] = IIF(TestCompletionStatus IN (1, 2, 3), @ScheduleStatus,TestCompletionStatus),[UpdatedBy] = @UserName,[UpdatedDate] = @CurrentDate                                
    FROM [AppointmentDetails] ad WHERE ad.AppointmentId = @AppointmentId AND TestCompletionStatus IN (1, 2, 3, 4, 8);                                

	INSERT INTO [AppointmentLog] ([AppointmentId],[ScheduleStatus],[Remarks],[UserLoginId],[CreatedBy],[CreatedDate],[ProviderId])                                
    VALUES (@AppointmentId, @ScheduleStatus, 'Reschedule', @UserLoginId, @UserName, @CurrentDate,@ProviderId)                                
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
        IF @AlternateSlotId IS NOT NULL                                
        BEGIN                                
             INSERT INTO [dbo].[DoctorSlotDetails] ([SlotId],[UserLoginId],[SlotDate],[SlotType],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])                    
             VALUES (@AlternateSlotId, @UserLoginId, @AlternateDateTime, 'Booked by Customer', 'Y', @UserName, @CurrentDate, @UserName, @CurrentDate)                                
             SET @AlternateSlotDetailId = SCOPE_IDENTITY();                                
             UPDATE Appointment SET AlternateSlotDetailId = @AlternateSlotDetailId  WHERE AppointmentId = @AppointmentId                                
        END                                
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
	select @LoginUsername =username from UserLogin where UserLoginId=@UserLoginId

	/************************************** Added by Vikas for NTCspecialityId 3March23 ***************/
	CREATE TABLE #tempntcspecialityId(ntcspecialityId varchar(500));
	Declare @ntcspecialityId varchar(20);
	Insert into #tempntcspecialityId  SELECT F.NTCSpecialityID FROM dbo.SplitString(@FacilityIds,',') T JOIN FacilitiesMaster F ON T.Item=F.FacilityId
	select @ntcspecialityId=(select top 1 * from #tempntcspecialityId );
	/************************************** End of Vikas code 3March23 ***************/

	---ADDED BY SAURAV SUMAN---
	if @Relation ='SELF'
    BEGIN
        SET @IntegratedRelation = 'Self';
    END
    ELSE 
	BEGIN
	    SELECT @IntegratedRelation = IntegrationRelationMaster from RelationMaster where RelationCode=@Relation;
	END
	---ADDED BY SAURAV SUMAN---
	-------------------------TABLE 2------------------------------------
	IF(@MessageCode = 'APPOINTMENTBOOKED')
	BEGIN
		SELECT @Message AS [Message],@AppointmentId AS AppointmentId, CONCAT(@FirstName,' ',@LastName) AS FullName,@MobileNo AS MobileNo,@EmailId AS EmailId,@DOB AS DoB,@Gender AS Gender,IIF(@FacilityGroup='Tele-Consultation',1,0) AS IsInternalTeleConsultation,@ProviderFacilityCode AS ProviderFacilityCode,@SelectedMemberId AS SelfMemberId, @StateId as StateId, @Relation AS Relation,@RSlotId AS SlotId,@CityId AS CityId,@Address AS [Address],@UserLatitude UserLatitude,@UserLongitude UserLongitude,@StateId StateId,@PartnerOrderId AS PartnerOrderId,@AppointmentDate AppointmentDate,@AppointmentTime AppointmentTime,@DoctorId DoctorId,@ModeOfConsultation ModeOfConsultation,@ProviderType ProviderType,IIF(@FacilityGroup='Doctor Coach',1,0) AS IsDoctorCoach,@CaseNo AS CaseNo,@FacilityIds AS FacilityIds,@ClientName as ClientName,@BUType as BUType,@CityName AS CityName,@Pincode AS Pincode,@LoginUsername as Username,@ntcspecialityId as NTCSpecialityID,@ProviderName As ProviderName,@ProviderId AS ProviderId,@MemberId as MemberId,@clientId as ClientId, @FacilityGroup as ServiceName,@IntegratedRelation as IntegrationRelation
		IF(ISNULL(@IsNotSendBookingEmail,0)=0)
		BEGIN
			EXEC [dbo].[uspSendAppointmentConfirmation] @AppointmentId,'INSERT' 
		END
	END
	ELSE IF(@MessageCode = 'STARTINGPAYMENT')
	BEGIN    
		SELECT @TransactionId AS TransactionId,@ServiceTax AS ServiceTax,@ActualFacilityAmount FacilityAmount,@GSTAmount AS GSTAmount,@TotalAmount AS AmountIncludingGST,@AvailableAmount as AvailableWalletAmount,@InvoiceType AS InvoiceType
	END	
	ELSE IF(@MessageCode = 'RECHEDULEAPPOINTMENT')
	BEGIN    
 	
		SELECT @Message AS [Message],@AppointmentId AS AppointmentId, CONCAT(@FirstName,' ',@LastName) AS FullName,@MobileNo AS MobileNo,@EmailId AS EmailId,@DOB AS DoB,@Gender AS Gender,IIF(@FacilityGroup='Tele-Consultation',1,0) AS IsInternalTeleConsultation,@ProviderFacilityCode AS ProviderFacilityCode,@SelectedMemberId AS SelfMemberId, @StateId as StateId, @Relation AS Relation,@RSlotId AS SlotId,@CityId AS CityId,@Address AS [Address],@UserLatitude UserLatitude,@UserLongitude UserLongitude,@StateId StateId,@PartnerOrderId AS PartnerOrderId,@AppointmentDate AppointmentDate,@AppointmentTime AppointmentTime,@DoctorId DoctorId,@ModeOfConsultation ModeOfConsultation,@ProviderType ProviderType,IIF(@FacilityGroup='Doctor Coach',1,0) AS IsDoctorCoach,@CaseNo AS CaseNo,@FacilityIds AS FacilityIds,@ClientName as ClientName,@BUType as BUType,@CityName AS CityName,@Pincode AS Pincode,@ProviderName As ProviderName,@ProviderId AS ProviderId,@MemberId as MemberId, @FacilityGroup as ServiceName,@IntegratedRelation as IntegrationRelation
		IF(ISNULL(@IsNotSendBookingEmail,0)=0)
		BEGIN
			EXEC [dbo].[uspSendAppointmentConfirmation] @AppointmentId,'INSERT'
		END
	END
	ELSE IF(@MessageCode ='APPOINTMENTBOOKINGFAILED')
	BEGIN
		SELECT ISNULL(@Message,'Appointment Booking Failed') AS [Message] --
	END

	ELSE IF(@MessageCode ='SENDAPPOINTMENTBOOKEDLINK')
	BEGIN
		SELECT @TransactionId AS TransactionId,ISNULL(@Message,'Send Appointment Booking Link') AS [Message]
	END
		
	 SELECT fm.facilityid AS FacilityID,fm.facilityname AS FacilityName,fm.facilitytype AS FacilityType,	
	        hm.AgreedRate AS AgreedRate,fm.IsFasting AS IsFasting  from facilitiesmaster fm 	
			JOIN haratemaster hm on fm.FacilityId=hm.FacilityId 	
			JOIN dbo.SplitString(@FacilityIds,',') TM on TM.Item=fm.FacilityId 	
	 WHERE  hm.ClientId=0

	 SELECT * FROM @TmpResheduled
/*****************************SELECT ALL TABLE***************************************************/

END

