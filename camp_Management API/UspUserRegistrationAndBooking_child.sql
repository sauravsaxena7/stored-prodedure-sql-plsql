USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspUserRegistrationAndBooking_child]    Script Date: 1/19/2024 6:39:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC UspUserRegistrationAndBooking_child_saurav 280,'Indus Tower Limited','Annual Health Check Self (Male 40-49 years)',629,
--'demoxyzdemo90@gmail.com','one','user','demoxyzdemo90@gmail.com','9146480293','M','1998-09-10','FATHER','Y',822,7122,'CV',NULL,NULL,'2023-09-10',"09:15",NULL,NULL

--EXEC UspUserRegistrationAndBooking_child 280,'Indus Tower Limited','Annual Health Check Self (Male 40-49 years)',629,'abhiraRRRRR@gmail.com','demoother',
--'AM','s765liwRRR@gmail.com','8271113231','M','2000-09-10','SELF',822,7122,'CV',NULL,NULL,'2023-04-28','23:15'

--EXEC UspUserRegistrationAndBooking_child 280.0,'Indus Tower Limited','Annual Health Check Self (Male 40-49 years)',629.0,'swami89771@gmail.com','demo','user','demoswar9099@gmail.com','9146480293.0','M','Dob":"2000-09-10","Relation":"SELF","PackageId":822.0,"ProviderId":7122.0,"AppointmentVisitType":"CV","UserAddress":"NULL","UserPincode":"NULL","AppointmentDate":"2023-09-10","AppointmentTime":"09:15"}

--EXEC UspUserRegistrationAndBooking_child_29042023 280	,NULL	,'Pre Employment Health Check Self (Female)',	626,	'demoyustyur78@mailinator.com',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	819,	7122,	'CV',	NULL,	NULL,	'2023-09-10',	'13:15'	,520154	,'Demo'

---exec UspUserRegistrationAndBooking_child 280,'Indus Tower Limited','Annual Health Check Self (Male 40-49 years)',	629	,'sayali343434a76ypp8@gmail.com',	'demo',	'one',	'demoswar9099@gmail.com',	'9146480293.0',	'M',	'2000-09-10',	'SELF',	822,	7122,	'CV',	NULL,	NULL,	'2023-09-10',	'09:15',	NULL,	NULL,	'sayali way'

 --exec UspUserRegistrationAndBooking_child 280	,NULL,'Pre Employment Health Check Self (Female)',	626	,'male50above@mailinator.com',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	819,	7122,	'CV',	NULL	,NULL,	'2023-09-10',	'13:15',	520154,'Demo',	NULL
--------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[UspUserRegistrationAndBooking_child]



@ClientId bigint=NULL,
@clientname Varchar(100)=NULL,
@PlanName Varchar(100)=NULL,
@PlanId bigint=NULL,
@UserLoginName varchar(100)=NULL,
@MemberFirstName varchar(100)=NULL,
@MemberLastName varchar(100)=NULL,
@MemberEmail varchar(100)=NULL,
@MobileNo VARCHAR(200)=NULL,
@Gender varchar(100)=NULL,
@Dob datetime = NULL,
@Relation varchar(100)=NULL,
@PackageId	bigint=NULL,
@ProviderId	bigint=NULL,
@AppointmentVisitType varchar(100)=NULL,
@UserAddress varchar(100)=NULL,
@UserPincode VARCHAR(200)=NULL,
@AppointmentDate datetime = NULL,                                           
@AppointmentTime datetime =NULL,
@MemberId bigint=NULL,
@MemberName varchar(200)=NULL,
@UploadedBy varchar(200)=NULL

  

AS
BEGIN  ----1




	 set @PlanName = (select top 1 planname from CorporatePlan where CorporatePlanId=@PlanId);
	 SET @clientname= (select top 1 clientname from client where ClientId=@ClientId);

     declare @ColumnName varchar(100)='';
     declare @Status int=0;
     declare @Success varchar(100)='False';
	 declare @Message varchar(MAX)='';

	 
	 declare @Plantodate datetime =(select top 1 todate from CorporatePlan  where corporateplanid=@PlanId)
	 
	 

     Declare @PlanIdExistitance varchar(100)=(select top 1 corporateplanid from corporateplan where corporateplanid=@PlanId);
     Declare @PlanAmount varchar(100)=(select top 1 PlanAmount from corporateplan where corporateplanid=@PlanId  );
     Declare @IsCredits varchar(10)= (select top 1 IsCredits from corporateplan where corporateplanid=@PlanId  );
     Declare @BUType varchar(100)=(select top 1 butype from client where clientid=@ClientId);
     Declare @ToDate datetime = (select top 1 todate from CorporatePlan where corporateplanid=@PlanId and clientid= @ClientId );
	 --DECLARE @MemberId varchar(100);
	 --DECLARE @UserLoginId varchar(100)=(select top 1 userloginid from userlogin where username like '%'+@UserLoginName+'%');
	 DECLARE @UserLoginId varchar(100)=(select top 1 userloginid from userlogin where username=@UserLoginName)
	 DECLARE @userstatus varchar(100)=(select top 1 status from userlogin where userloginid=@UserLoginId)
	 DECLARE @Memberstatus varchar(100)=(select top 1 Isactive from member where MemberId=@MemberId)
	 DECLARE @MemberPlanId varchar(100);
	
	 print '@UploadedBy'
	 print @UploadedBy

	 print '@userstatus'
	 print @userstatus

	 declare @correctedmobileno varchar(100)=(select SUBSTRING (@MobileNo,1,LEN(@MobileNo)-2) as correctedmobileno);
     print @correctedmobileno;

	 declare @correctedpincode varchar(100)=(select SUBSTRING (@UserPincode,1,LEN(@UserPincode)-2) as correctedpincode);
     print @correctedpincode;

	  if  (ISNUMERIC(@correctedmobileno)=0 or LEN(@correctedmobileno) < 10 or LEN(@correctedmobileno) > 10) and @correctedmobileno <> 'MOBILE'
	  Begin---2
	     
		 set @Message= @Message+'Invalid Mobile No, ' 
		 set @ColumnName= @ColumnName+'MobileNo, '

	  END
	  else if @Gender not in ('M','F','O') and @Gender<>'GENDER'
	  BEGIN---3
         set @Message= @Message+'Gender is only belong To [M, F, O], ' 
		 set @ColumnName= @ColumnName+'Gender, '
		 
		 	      
	  END
	  ELSE if (select  dbo.ChkValidEmail(@MemberEmail))=0 and @MemberEmail <> 'EMAIL'
	  BEGIN---5
	     set @Message= @Message+'Invalid Email, ' 
		 set @ColumnName= @ColumnName+'EmailId, '
	  END
	  ELSE if @Plantodate < getdate()
	  BEGIN
	     set @Message= @Message+'Selected Plan has been expired, ' 
		 set @ColumnName= @ColumnName+'CorporatePlanId, '
	  END
	  ELSE if @userstatus = 'I'
	  BEGIN
	     set @Message= @Message+'User is Inactive, ' 
		 set @ColumnName= @ColumnName+'Status, '
	  END
	  
	  ELSE if @Memberstatus = 'N'
	  BEGIN
	     set @Message= @Message+'Member is Inactive, ' 
		 set @ColumnName= @ColumnName+'Isactive, '
	  END

	  --ELSE IF ISNUMERIC(@ClientId)=0 
	  --BEGIN---6
	  --    set @Message= @Message+'Client Id Should be numeric, ' 
		 -- set @ColumnName= @ColumnName+'ClientId, '
	  --END
	  --ELSE IF ISNUMERIC(@PlanId)=0 
	  --BEGIN----7
	  --    set @Message= @Message+'Plan Id Should be numeric, ' 
		 -- set @ColumnName= @ColumnName+'CorporatePlanId, '
	  --END
	  --ELSE IF ISNUMERIC(@PackageId)=0 
	  --BEGIN ----8
	  --    set @Message= @Message+'PackageId Should be numeric, ' 
		 -- set @ColumnName= @ColumnName+'PackageId, '
	  --END
	  --ELSE IF ISNUMERIC(@ProviderId)=0 
	  --BEGIN---9
	  --    set @Message= @Message+'ProviderId Should be numeric, ' 
		 -- set @ColumnName= @ColumnName+'ProviderId, '
	  --END  ---10
	  ELSE IF @UserLoginName = ''
	  BEGIN---9
	      set @Message= @Message+'UserLoginName is empty, ' 
		  set @ColumnName= @ColumnName+'UserLoginName, '
	  END  ---10
      ELSE
      BEGIN --PARENT ELSE VALID SECTION START 
	     --set @Message= @Message+'Valid Section, '
		 --set @ColumnName= @ColumnName+'ALL, '

		 IF (@Relation='SELF' OR @Relation='Self' OR @Relation='self')
		  BEGIN --SELF USER SECTION START
		    IF EXISTS(select 1 from UserLogin  where username like '%'+@UserLoginName+'%')
			 BEGIN --START USER ALREADY EXIST AS SELF MEMBER
			    SET @Message = @Message+' USER ALREADY EXIST AS SELF MEMBER, ';
		        SET @ColumnName = @ColumnName + 'UserLoginName, ';
				---IF SELF USER IS EXIST AND APPOINTMENT IS NOT BOOKED THEN APPOINTMENT WILL HAPPEN'
				SET @UserLoginId = (SELECT UserLoginId FROM USERLOGIN WHERE username like '%'+@UserLoginName+'%' )
				SET @MemberId = (SELECT TOP 1 MEMBERID FROM MEMBER WHERE UserLoginId=@UserLoginId )

			 END --END USER ALREADY EXIST AS SELF MEMBER
			 ELSE
			  BEGIN --VALID ELSE SECTION START FOR SELF

			     ---USERLOGIN---
				 --INSERT INTO USERLOGIN TABLE FOR SUCCESS---
		         INSERT INTO UserLogin ([FirstName], [LastName], [UserName], [MobileNo], [Password],  [UserTypeId], [UserRoleId], [ClientId], [Status], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
                 VALUES  (@MemberFirstName,@MemberLastName,@UserLoginName,@correctedmobileno,'Hassure@123',3,1,@ClientId,'T',@UploadedBy,Getdate(),@UploadedBy,Getdate())

				 SELECT  @UserLoginId= SCOPE_IDENTITY(); --GRAB USERLOGINID FOR ABOVE INSERTING USER

				 --MEMBER---
				 --INSERT INTO MEMBER TABLE FOR SUCCESS---
                 INSERT INTO Member ([UserLoginId], [FirstName], [LastName], [Relation], [DOB], [Gender], [MobileNo], [EmailId],  [IsActive],  [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
                 VALUES   (@UserLoginId,@MemberFirstName,@MemberLastName,@Relation,@Dob,@Gender,@correctedmobileno,@MemberEmail,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate())

				 SELECT  @MemberId  = SCOPE_IDENTITY(); --GRAB MEMBERID FOR ABOVE INSERTING MEMBER
				 
				 ----MEMMEBRPLAN-----
				 --INSERT INTO MEMBERPLAN TABLE FOR SUCCESS---
				 INSERT INTO MemberPlan ([MemberId], [FamilyMemberId], [CorporatePlanId], [PlanAmount], [IsCredits], [FromDate], [ToDate], [IsActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
		         VALUES   ( @MemberId , @MemberId,@PlanId,@PlanAmount,@IsCredits,Getdate(),@ToDate,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate())
				 
				 SELECT  @MemberPlanId = SCOPE_IDENTITY(); --GRAB MEMBERID FOR ABOVE INSERTING MEMBERPLAN
				 
				 ----MEMMEBRPLANDETAILS-----
				 DECLARE @Tmp TABLE (MemberPlanId	varchar(100),MemberId varchar(100),CorporatePlanId varchar(100), PlanType  varchar(100),FacilityId varchar(100),FromDate datetime,ToDate datetime,IsUtilized varchar(10),IsBuy varchar(10),	
				 ProductOfferId varchar(100),IsUnlimited varchar(10),IsActive  varchar(10),CreatedBy	varchar(100),CreatedDate datetime,UpdatedBy	varchar(100),UpdatedDate datetime,MasterPlanType varchar(100),Credit varchar(100))

			     INSERT INTO @Tmp (MemberPlanId,MemberId,CorporatePlanId,PlanType,FacilityId,FromDate,ToDate,IsUtilized,IsBuy,ProductOfferId,IsUnlimited,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,MasterPlanType,Credit)         
				   SELECT @MemberPlanId,@MemberId ,c.corporateplanid,cp.plantype,cp.facilityid,c.fromdate,c.todate ,cp.IsUtilized,'N',0,cp.IsUnlimited,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate(),fm.ServiceType,'Y'
				   FROM CorporatePlan c join CorporatePlanDetails cp on c.CorporatePlanId=cp.CorporatePlanId
				     join FacilitiesMaster fm on fm.FacilityId=cp.FacilityId 
				   WHERE c.CorporatePlanId=@PlanId and c.ClientId=@ClientId and cp.IsActive='Y'

                 INSERT INTO MemberPlanDetails (MemberPlanId,MemberId,CorporatePlanId,PlanType,FacilityId,FromDate,ToDate,IsUtilized,IsBuy,ProductOfferId,IsUnlimited,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,MasterPlanType,Credit)
	                SELECT tt.MemberPlanId,tt.MemberId,tt.CorporatePlanId,tt.PlanType,tt.FacilityId,tt.FromDate,tt.ToDate,tt.IsUtilized,tt.IsBuy,tt.ProductOfferId,tt.IsUnlimited,tt.IsActive,tt.CreatedBy,tt.CreatedDate,tt.UpdatedBy,tt.UpdatedDate,tt.MasterPlanType,tt.Credit
				    FROM @Tmp tt

				 DECLARE @MemberPlanDetailsId varchar(100);
                 SELECT  @MemberPlanDetailsId  = SCOPE_IDENTITY(); 

				 PRINT 'self user is inserted successfully with PlanDetails in database'

				 ------membercreditdetails-----
				 Declare @Tmp1 table (MemberPlanId varchar(100),MemberId varchar(100),CorporatePlanId varchar(100),FacilityGroupCombinatonId varchar(100),FromDate datetime,ToDate datetime,WalletCredits varchar(100),IsActive varchar(100),CreatedBy varchar(100),CreatedDate datetime,UpdatedBy	varchar(100),UpdatedDate datetime)

				 INSERT INTO @Tmp1 (MemberPlanId,MemberId,CorporatePlanId,FacilityGroupCombinatonId,FromDate,ToDate ,WalletCredits,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
				    SELECT @MemberPlanId,@MemberId ,c.corporateplanid,ccd.FacilityGroupCombinatonId,c.fromdate,c.todate,ccd.WalletCredits,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate()
					  FROM CorporatePlan c join CorporateCreditDetails ccd on c.CorporatePlanId=ccd.CorporatePlanId
					  WHERE c.CorporatePlanId=@PlanId and c.ClientId=@ClientId and ccd.IsActive='Y'

				 INSERT INTO MemberCreditDetails (MemberPlanId,MemberId,CorporatePlanId,FacilityGroupCombinatonId,FromDate,	ToDate ,WalletCredits,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	                SELECT tt.MemberPlanId,tt.MemberId,tt.CorporatePlanId,tt.FacilityGroupCombinatonId,tt.FromDate,	tt.ToDate ,tt.WalletCredits,tt.IsActive,tt.CreatedBy,tt.CreatedDate,tt.UpdatedBy,tt.UpdatedDate
				    FROM @Tmp1 tt
		                  
                 DECLARE @MembercreditDetailsId varchar(100);
                 SELECT  @MembercreditDetailsId  = SCOPE_IDENTITY();  
				 PRINT 'Self user is inserted successfully with membercreditdetails in database'

                 -----MemberPlanReimbursementDetails-----
				 DECLARE @TmpReim TABLE (CorporatePlanId varchar(100),PlanReimbursementDetailsId varchar(100),MemberPlanId varchar(100),FacilityGroupCombinatonId  varchar(10),
				 IsPartOfPlan varchar(100),ReimbursementLimit varchar(100),PerTxnLimitAmount varchar(100),FrequencyId varchar(10),FrequencyLimit  varchar(10),FromDate datetime,	ToDate datetime ,IsActive varchar(100),CreatedBy varchar(100),CreatedDate datetime,UpdatedBy	varchar(100),UpdatedDate datetime,Flag varchar(10)) 

				 INSERT INTO @TmpReim (CorporatePlanId,PlanReimbursementDetailsId,MemberPlanId,FacilityGroupCombinatonId,IsPartOfPlan,ReimbursementLimit,PerTxnLimitAmount,FrequencyId,FrequencyLimit,FromDate,	ToDate,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,Flag)
	                SELECT @PlanId,rem.PlanReimbursementDetailsId,@MemberPlanId,rem.FacilityGroupCombinatonId,rem.IsPartOfPlan,rem.ReimbursementLimit,rem.PerTxnLimitAmount,rem.FrequencyId,rem.FrequencyLimit,cp.fromdate,cp.todate,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate(),rem.Flag
				    FROM CorporatePlan cp join PlanReimbursementDetails rem on cp.CorporatePlanId=rem.CorporatePlanId
				    WHERE cp.CorporatePlanId=@PlanId and cp.ClientId=@ClientId and rem.IsActive='Y'

			     INSERT INTO MemberPlanReimbursementDetails (CorporatePlanId,PlanReimbursementDetailsId,MemberPlanId,FacilityGroupCombinatonId,IsPartOfPlan,ReimbursementLimit,PerTxnLimitAmount,FrequencyId,FrequencyLimit,FromDate,ToDate,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,Flag)
	                SELECT tt.CorporatePlanId,tt.PlanReimbursementDetailsId,tt.MemberPlanId,tt.FacilityGroupCombinatonId,tt.IsPartOfPlan,tt.ReimbursementLimit,tt.PerTxnLimitAmount,tt.FrequencyId,tt.FrequencyLimit,tt.FromDate,tt.ToDate ,tt.IsActive,tt.CreatedBy,tt.CreatedDate,tt.UpdatedBy,tt.UpdatedDate,tt.Flag
					FROM @TmpReim tt

			     DECLARE @MemberPlanReimbursementDetailsId varchar(100);
                 SELECT  @MemberPlanReimbursementDetailsId  = SCOPE_IDENTITY(); 
				 
				 PRINT 'self user is inserted successfully with MemberPlanReimbursementDetails in database'

				 SET @Message = @Message+'Self User Registered as Member successfully With (Plan Details,Membercreditdetails,MemberPlanReimbursementDetails), ';
			     SET @ColumnName = @ColumnName + 'UserLoginName,Member ';


			  END --VALID ELSE SECTION END FOR SELF

		  END--SELF USER SECTION END
		  ELSE IF @Relation IS NOT NULL
		   BEGIN--MEMBER SECTION START IF USER NOT WITH SELF

		      SET @UserLoginId=( SELECT userloginid FROM userlogin WHERE username=@UserLoginName);
			  IF EXISTS(SELECT 1 FROM member WHERE userloginid=@UserLoginId and firstname=@MemberFirstName and lastname=@MemberLastName and relation=@Relation )
			   BEGIN --IF MEMBER ALREADY EXIST SECTION START
			      PRINT 'This Member Already Exist For This Relation. '

				  ---IF OTHER USER IS EXIST AND APPOINTMENT IS NOT BOOKED THEN APPOINTMENT WILL HAPPEN'

				   SET @MemberId =(select memberid from member where UserLoginId=@UserLoginId and  firstname=@MemberFirstName and lastname=@MemberLastName and relation=@Relation) 
				   SET @Message = @Message+'This Member Already Exist For This Relation., ';
		  	       SET @ColumnName= @ColumnName + 'Relation, '
			   END --IF MEMBER ALREADY EXIST SECTION END

			ELSE 
			 BEGIN --Inserting Member Section Start

			    
			    IF EXISTS(select 1 from UserLogin  where username like '%'+@UserLoginName+'%') --self user existed then member inserted.

				 BEGIN --valid section for inserting member start
				   DECLARE @relationcount varchar(100)= (select top 1 Relcount from CorporatePlanRelation where RelationId=17 and isactive='Y' and corporateplanid=@PlanId )+1;
				   print  @relationcount;
				   DECLARE @existrelationcount varchar(100)= (select count(userloginid) from member where userloginid=@userloginid);

				   IF @existrelationcount < @relationcount --SELF User Have Enough RelationCount to insert A memeber

				    BEGIN --SELF User Have Enough RelationCount to insert A memeber START
					  INSERT INTO Member ([UserLoginId], [FirstName], [LastName], [Relation], [DOB], [Gender], [MobileNo], [EmailId],  [IsActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
                      VALUES   (@UserLoginId,@MemberFirstName,@MemberLastName,@Relation,@Dob,@Gender,@correctedmobileno,@MemberEmail,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate())

					   SELECT  @MemberId = SCOPE_IDENTITY(); 
					   PRINT  'Other Relation successfully added in database'
					   SET @Message = @Message+'Member with ( Other Relation ) successfully added in Member Table, ';
			           SET @ColumnName= @ColumnName + 'Relation, '

					END --SELF User Have Enough RelationCount to insert A memeber  End
				 ELSE
				   BEGIN --Relation Count Exausted Start
				      print 'rel count exausted'
				      SET @Message = @Message+'Relation count exausted and Member is not Added, ';
				      SET @ColumnName= @ColumnName + 'Relation, '
				   END--Relation Count Exausted END

				 END--valid section for inserting member END
			   ELSE
			    BEGIN --self user is not Exist our database secton start
				   PRINT 'self user is not Exist our database' 
			       SET @Message = @Message+'Self user does not exist in our database, ';
			       SET @ColumnName= @ColumnName + 'UserLoginName,'
				END --self user is not Exist our database secton end

			 END--Inserting Member Section End
		   END--MEMBER SECTION END IF USER NOT WITH SELF


		  ---------------------------------APPPOINTMENT BOOKING PART START-----------------------------------------------------------------

		  DECLARE @AvailableCreditCount bigint = (SELECT count (mem.facilityid) from  memberplanDetails  mem 
                                                      join memberplan mp on mem.memberplanid=mp.MemberPlanId
                                       				  join member m on m.MemberId=mp.MemberId
                                       				  join userlogin u on u.UserLoginId=m.UserLoginId
                                       			 WHERE u.userloginid=@userloginid and mem.FacilityId=@PackageId and mem.IsUtilized='N' and mem.IsActive='Y' and Credit='Y');
		  PRINT @AvailableCreditCount; 

		  DECLARE @ScheduleStatus varchar(100)=1;		
          DECLARE @AppointmentType varchar(100)=(SELECT fm.ProcessCode from FacilitiesMaster  fm where fm.FacilityId=@PackageId); 
          PRINT   @AppointmentType;
          DECLARE @CaseNo varchar(MAX);
          DECLARE @AppointmentId bigint;
          DECLARE @LastApptLogId varchar(100);
          DECLARE @LastApptDetailsLogId Varchar(100); 
          DECLARE @MasterPlanType varchar(50) = NULL; 
          DECLARE @alternatedate datetime = NULL;  
          DECLARE @AlternateAppointmentDate varchar(10) = NULL;                               
          DECLARE @AlternateAppointmentTime varchar(10) = NULL; 
		  
		  IF ISNULL(@AlternateAppointmentDate, '') != '' AND ISNULL(@AlternateAppointmentTime, '') != ''                                            
           BEGIN  -- SETTING VALID APPOINDATETIME SECTION START                                       
             SET @alternatedate = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AlternateAppointmentDate, 103), 102) + ' ' + @AlternateAppointmentTime, 121);      	                                        
           END  -- SETTING VALID APPOINDATETIME SECTION END

		  DECLARE @XML AS xml;      
          DECLARE @Delimiter AS char(1) = ',';      
          DECLARE @date datetime;       
          SET @XML = CAST(('<X>' + REPLACE(@PackageId, @Delimiter, '</X><X>') + '</X>') AS xml)       
          SET @date = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AppointmentDate, 103), 102) + ' ' + @AppointmentTime, 121);
          print @date;

		  print'sayali_date'

		  IF ISNULL(@AlternateAppointmentDate, '') != '' AND ISNULL(@AlternateAppointmentTime, '') != ''                                          
           BEGIN     ---2                                     
             SET @alternatedate = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AlternateAppointmentDate, 103), 102) + ' ' + @AlternateAppointmentTime, 121);                                          
           END   ---2

		    print 'sayali_alternatedateandtime'
	     ---------------sayali APPOINTMENT VALIDATION START----------------
		 IF @MemberId is null or @UserLoginId is NULL  
          BEGIN 
            SET @Message= @Message+ 'Member Not Exist hence Appointment booking process stoped'
            SET @ColumnName=@ColumnName+ 'MemberId, UserLoginId'
			print 'Member Not Exist hence Appointment booking process stoped'
          END
        ELSE IF @AvailableCreditCount <= 0
           BEGIN
              SET @Message= @Message+ 'You not have enough credit points to booked a appointment'
              SET @ColumnName=@ColumnName+ 'PackageId'
			  print 'You not have enough credit points to booked a appointment'
           END
        ELSE IF @gender not in (select gender from FacilitiesMaster where facilityid=@packageid ) AND (select gender from FacilitiesMaster where facilityid=@packageid ) <> 'B'
           BEGIN
             SET @Message= @Message+ 'For this PackageId User Gender is not matched hence Appointment booking process stoped'
             SET @ColumnName=@ColumnName+ 'PackageId'
			 
           END
        ELSE IF @date < getdate()
           BEGIN
             SET @Message= @Message+ 'Appointment Date should be grater than present date hence Appointment booking process stoped'
             SET @ColumnName=@ColumnName+ 'AppointmentDate'
           END

		ELSE
		  BEGIN --VALID APPOINTMENT BOOKING SECTION START

		    print 'sayali_appointmentstrat'
		    INSERT INTO [dbo].[Appointment] ( [MemberId], [UserTypeMappingId], [UserLoginId], [ScheduleStatus],[VisitType], [AppointmentType], [IsActive], [CreatedBy], [CreatedDate] , [UpdatedBy]   , [UpdatedDate] , [ClientId], [MobileNo] , [AppointmentAddress],[DocCoachApptType]) 
            VALUES (@MemberId, 1, @UserLoginid, @ScheduleStatus, @AppointmentVisitType,  @AppointmentType, 'Y',@UploadedBy, GETDATE(),@UploadedBy, GETDATE(), @ClientId, @correctedmobileno,@UserAddress ,'Excel Upload' );
			SELECT  @AppointmentId = SCOPE_IDENTITY(); 
			
			SELECT @CaseNo= [dbo].[fnGetCaseNo](@AppointmentId)                   
                                            
            UPDATE [Appointment] SET CaseNo = @CaseNo WHERE AppointmentId = @AppointmentId;                                                                       
            PRINT 'Record insert successfully in Appointment Table' 

			----------------Appointment log---------------------------------------- 
		    INSERT INTO [AppointmentLog] ([AppointmentId]  , [ScheduleStatus], [Remarks], [UserLoginId] , [CreatedBy], [CreatedDate])                 
            VALUES (@AppointmentId, @ScheduleStatus, 'Requested', @UserLoginId,@UploadedBy, GETDATE())                                            
            SELECT @LastApptLogId = SCOPE_IDENTITY();                                            
            PRINT @LastApptLogId      
            PRINT 'Record insert successfully in AppointmentLog Table'

			 DECLARE @PACKAGEType varchar(500)= (select facilitytype from facilitiesmaster where facilityid=@PackageId);

			
		             DECLARE @Tmpp table (AppointmentId bigint,TestId	bigint ,PakageId bigint,	ProviderId bigint,AppointmentDateTime	datetime,AppointmentScheduleDateTime      datetime,	HomeVisit varchar(100),	Fasting varchar(100),TestCompletionStatus varchar(100),QCDone	varchar(100),	IsActive varchar(100),	CreatedBy varchar     (100),	CreatedDate	datetime,UpdatedBy varchar(100),	UpdatedDate datetime,AlternateAppointmentDateTime datetime)

			 IF @PACKAGEType='AHC'
			BEGIN

			    INSERT INTO @Tmpp  (AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
				   SELECT  @AppointmentId,fm.FacilityId,fm.FacilityId,@ProviderId,@date, GETDATE(), @AppointmentVisitType,  fm.isFasting,1,'N','Y',@UploadedBy,Getdate(),@UploadedBy,Getdate(),@alternatedate
				   FROM  facilitiesmaster fm 
                   WHERE  fm.Facilityid=@PackageId and fm.FacilityType='AHC'
                   GROUP BY fm.FacilityId,fm.isFasting
            
			

		           INSERT INTO AppointmentDetails(AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
                   SELECT tp.AppointmentId,tp.TestId,tp.PakageId,tp.ProviderId ,tp.AppointmentDateTime,tp.AppointmentScheduleDateTime,tp.HomeVisit ,tp.Fasting,tp.TestCompletionStatus,tp.QCDone,tp.IsActive,tp.CreatedBy,tp.CreatedDate,tp.UpdatedBy,tp.UpdatedDate,tp.AlternateAppointmentDateTime         
				    FROM @Tmpp tp
			   
			END
			ELSE
			BEGIN
			     
                 INSERT INTO @Tmpp  (AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
				   SELECT  @AppointmentId,pm.TestId,pm.packageid ,@ProviderId,@date, GETDATE(), @AppointmentVisitType,  fm.isFasting,1,'N','Y',@UploadedBy,Getdate(),@UploadedBy,Getdate(),@alternatedate
				   FROM packagetestmaster  pm
                     join facilitiesmaster fm on fm.facilityid=pm.testid
                   WHERE  pm.packageid=@PackageId
                   GROUP BY pm.TestId,pm.packageid,fm.isFasting
            
			

		           INSERT INTO AppointmentDetails(AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
                   SELECT tp.AppointmentId,tp.TestId,tp.PakageId,tp.ProviderId ,tp.AppointmentDateTime,tp.AppointmentScheduleDateTime,tp.HomeVisit ,tp.Fasting,tp.TestCompletionStatus,tp.QCDone,tp.IsActive,tp.CreatedBy,tp.CreatedDate,tp.UpdatedBy,tp.UpdatedDate,tp.AlternateAppointmentDateTime         
				    FROM @Tmpp tp
			 END
			
			---------------Appointment log  details----------------------------------------  

			INSERT INTO [dbo].[AppointmentLogDetails] ( [AppointmentLogId] , [AppointmentDetailId], [AppointmentDateTime] , [TestCompletionStatus] , [ProviderId]  , [HomeVisit]  , [CreatedBy]    , [CreatedDate])                                            
               (SELECT   @LastApptLogId, ad.AppointmentDetailId, ad.AppointmentDateTime,   ad.TestCompletionStatus, @ProviderId, ad.HomeVisit,   @UploadedBy, GETDATE() 
			     FROM AppointmentDetails ad                                            
                 WHERE ad.AppointmentId = @AppointmentId);

		    SELECT @LastApptDetailsLogId = SCOPE_IDENTITY();                                                                           
            PRINT @LastApptDetailsLogId;    
            PRINT 'Record insert successfully in AppointmentLogDetails Table'

		    ------------MemberPlanDetails table----------------------- 

			DECLARE @selfmemberid varchar(100)=(select memberid from member where Relation='SELF' and UserLoginId=@UserLoginId);
			SET @MemberPlanId= (select  memberplanid from memberplan where memberid=@selfmemberid  and CorporatePlanId=@PlanId)
		   
		    update TOP (1) memberplanDetails 
			set IsUtilized='Y' ,IsActive='Y' ,AppointmentId=@AppointmentId,UpdatedBy=@UploadedBy,UpdatedDate=getdate() 
			where memberplanId=@MemberPlanId and facilityid=@PackageId and  IsUtilized='N' and  IsActive='Y' and  Credit='Y';

		    PRINT 'Record updated successfully in MemberPlanDetails Table' 
			SET @Message= @Message + 'Member credit point has been utilized successfully for appointment booking, '

			
		   
		  --  ----------------AppointmentDetails table -----------------------

		  --  DECLARE @Tmpp table (AppointmentId bigint,TestId	bigint ,PakageId bigint,	ProviderId bigint,AppointmentDateTime	datetime,AppointmentScheduleDateTime datetime,	HomeVisit varchar(100),	Fasting varchar(100),TestCompletionStatus varchar(100),QCDone	varchar(100),	IsActive varchar(100),	CreatedBy varchar(100),	CreatedDate	datetime,UpdatedBy varchar(100),	UpdatedDate datetime,AlternateAppointmentDateTime datetime)

    --        INSERT INTO @Tmpp  (AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
				--   SELECT  @AppointmentId,pm.TestId,pm.packageid ,@ProviderId,@date, GETDATE(), @AppointmentVisitType,  fm.isFasting,1,'N','Y',@UploadedBy,Getdate(),@UploadedBy,Getdate(),@alternatedate
				--   FROM packagetestmaster  pm
    --                 join facilitiesmaster fm on fm.facilityid=pm.testid
    --               WHERE  pm.packageid=@PackageId
    --               GROUP BY pm.TestId,pm.packageid,fm.isFasting
            
			

		  --  INSERT INTO AppointmentDetails(AppointmentId,TestId,PakageId,ProviderId ,AppointmentDateTime,AppointmentScheduleDateTime,HomeVisit , Fasting,TestCompletionStatus,QCDone,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AlternateAppointmentDateTime)
    --            SELECT tp.AppointmentId,tp.TestId,tp.PakageId,tp.ProviderId ,tp.AppointmentDateTime,tp.AppointmentScheduleDateTime,tp.HomeVisit ,tp.Fasting,tp.TestCompletionStatus,tp.QCDone,tp.IsActive,tp.CreatedBy,tp.CreatedDate,tp.UpdatedBy,tp.UpdatedDate,tp.AlternateAppointmentDateTime         
				--FROM @Tmpp tp
		    PRINT 'All OPERATIONS ARE PERFORMED SUCEESFFULLY'
	        SET @Message=@Message+ 'Appointment Booked Successfully'
	        SET @ColumnName=@ColumnName+'Appointment'
	        SET @Status=1
	        SET @Success='TRUE'
		   --select 'All OPERATIONS ARE PERFORMED SUCEESFFULLY' as message,200 as statuscode ,1 as status;
		   print 'sayali_end'
		  END --VALID APPOINTMENT BOOKING SECTION END
                             
	  END --PARENT ELSE VALID SECTION END

	  --SELECT @ColumnName AS ColumnName, @Message AS Message
	  INSERT INTO  ##GlobalLogResultCampBooking VALUES(@ColumnName,@Status,@Success,@Message)
	  

END