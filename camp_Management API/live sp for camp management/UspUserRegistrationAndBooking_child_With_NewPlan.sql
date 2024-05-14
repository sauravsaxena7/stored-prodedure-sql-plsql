USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspUserRegistrationAndBooking_child_With_NewPlan]    Script Date: 2/9/2024 11:14:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UspUserRegistrationAndBooking_child_With_NewPlan]
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
@UploadedBy varchar(200)=NULL,
@CNPLanBucketId BIGINT=NULL
AS
BEGIN



      --@AppointmentVisitType IS NULL --added by saurav suman start
		  IF @AppointmentVisitType is null or @AppointmentVisitType='' or @AppointmentVisitType=' '
		    BEGIN
			   SET @AppointmentVisitType='CV'
			END
		--@AppointmentVisitType IS NULL --added by saurav suman END


  set @PlanName = (select top 1 planname from CNPlanDetails where CNPlanDetailsId=@PlanId);
	 SET @clientname= (select top 1 clientname from client where ClientId=@ClientId);

     declare @ColumnName varchar(100)='';
     declare @Status int=0;
     declare @Success varchar(100)='False';
	 declare @Message varchar(MAX)='';
	 declare @Plantodate datetime =(select top 1 todate from CNPlanDetails  where CNPlanDetailsId=@PlanId)
     Declare @PlanIdExistitance varchar(100)=(select top 1 CNPlanDetailsId from CNPlanDetails where CNPlanDetailsId=@PlanId);

     Declare @PlanAmount varchar(100)=(select top 1 PlanAmount from CNPlanDetails where CNPlanDetailsId=@PlanId  );
    
     Declare @BUType varchar(100)=(select top 1 butype from client where clientid=@ClientId);

     Declare @ToDate datetime = (select top 1 Todate from CNPlanDetails 
	     where CNPlanDetailsId=@PlanId and clientid= @ClientId );

	 Declare @FromDate datetime = (select top 1 FromDate from CNPlanDetails 
	     where CNPlanDetailsId=@PlanId and clientid= @ClientId );
	
	 DECLARE @UserLoginId varchar(100)=(select top 1 userloginid from userlogin where username=@UserLoginName)
	 DECLARE @userstatus varchar(100)=(select top 1 status from userlogin where userloginid=@UserLoginId)
	 DECLARE @Memberstatus varchar(100)=(select top 1 Isactive from member where MemberId=@MemberId)
	 DECLARE @UserPlanDetailsId bigint;
	 DECLARE @MaxRelationAllowed BIGINT=(SELECT MaxRelationAllowed FROM CNPlanDetails WHERE CNPlanDetailsId=@PlanId and ActiveStatus='Y');

	 declare @correctedmobileno varchar(100)=(select SUBSTRING (@MobileNo,1,LEN(@MobileNo)-2) as correctedmobileno);
     print @correctedmobileno;

	 declare @correctedpincode varchar(100)=(select SUBSTRING (@UserPincode,1,LEN(@UserPincode)-2) as correctedpincode);
     print @correctedpincode;
	
	 print '@UploadedBy'
	 print @UploadedBy

	 print '@userstatus'
	 print @userstatus

	 
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
	  ELSE IF @UserLoginName = ''
	  BEGIN---9
	      set @Message= @Message+'UserLoginName is empty, ' 
		  set @ColumnName= @ColumnName+'UserLoginName, '
	  END
	  ELSE
	    BEGIN--PARENT ELSE VALID SECTION START 
		  IF (@Relation='SELF' OR @Relation='Self' OR @Relation='self')
		     BEGIN --SELF USER SECTION START

			 
			   IF EXISTS(select 1 from UserLogin  where username =@UserLoginName)
			      BEGIN --START USER ALREADY EXIST AS SELF MEMBER
			         SET @Message = @Message+' USER ALREADY EXIST AS SELF MEMBER, ';
		             SET @ColumnName = @ColumnName + 'UserLoginName, ';
				     ---IF SELF USER IS EXIST AND APPOINTMENT IS NOT BOOKED THEN APPOINTMENT WILL HAPPEN'
					 
				     SElect @UserLoginId =  UserLoginId FROM USERLOGIN WHERE username=@UserLoginName;
					 print 'SELF SECTION START'
				     SET @MemberId = (SELECT TOP 1 MEMBERID FROM MEMBER WHERE UserLoginId=@UserLoginId and relation='SELF')
					 

					 SET @UserPlanDetailsId=(SELECT TOP 1 UserPlanDetailsId FROM UserPlanDetails WHERE  MemberId=@MemberId and CNPlanDetailsId=@PlanId and ClientId=@ClientId)

					 PRINT '@UserLoginId'
					 print @UserLoginId

					 print 'MemberId'
					 print @MemberId

					 print 'UserPlanDetailsId'
					 print @UserPlanDetailsId
					 print 'SELEF USER END'

			      END--END USER ALREADY EXIST AS SELF MEMBER
               ELSE
			     BEGIN--INSERTING SELF USER START
				   ---USERLOGIN---
				   --INSERT INTO USERLOGIN TABLE FOR SUCCESS---
		           INSERT INTO UserLogin ([FirstName], [LastName], [UserName], [MobileNo], [Password],  [UserTypeId], [UserRoleId], [ClientId], [Status], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
                        VALUES  (@MemberFirstName,@MemberLastName,@UserLoginName,@correctedmobileno,
						'Hassure@123',3,1,@ClientId,'T',@UploadedBy,Getdate(),@UploadedBy,Getdate())

				   SELECT  @UserLoginId= SCOPE_IDENTITY(); --GRAB USERLOGINID FOR ABOVE INSERTING USER

				   --MEMBER---
				   --INSERT INTO MEMBER TABLE FOR SUCCESS---
                   INSERT INTO Member ([UserLoginId], [FirstName], [LastName], [Relation], [DOB], [Gender], [MobileNo], [EmailId],  [IsActive],  [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate])    
                      VALUES   (@UserLoginId,@MemberFirstName,@MemberLastName,UPPER(@Relation),@Dob,@Gender,
					  @correctedmobileno,@MemberEmail,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate())


				   SELECT  @MemberId  = SCOPE_IDENTITY(); --GRAB MEMBERID FOR ABOVE INSERTING MEMBER

				   ---INSERT INTO USERPLANDETAILS TABLE

				   --SELECT TOP 10 * FROM UserPlanDetails ORDER BY 1 DESC

				   INSERT INTO UserPlanDetails([MemberId],[ClientId],[CNPlanDetailsId],[PlanAmount],[FromDate],[ToDate],[MaxRelationAllowed],[ActiveStatus],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate]) VALUES(@MemberId,@ClientId,@PlanId,@PlanAmount,@FromDate,@ToDate,
				   @MaxRelationAllowed,'Y',@UploadedBy,Getdate(),@UploadedBy,Getdate())


			       -----GRAB USERPLANDETAILS ID-----
				   SELECT @UserPlanDetailsId=SCOPE_IDENTITY();


				   --INSERTING INTO MEMBERPLANBUCKET---
				   --SELECT TOP 10 * FROM MemberPlanBucket ORDER BY 1 DESC
				   --SELECT TOP 10 * FROM CNPLanBucket WHERE CNPlanDetailsId=896 order by 1 desc
				   INSERT INTO MemberPlanBucket([UserPlanDetailsId],[CNPLanBucketId],[BucketName],[PlanBucketType],[WalletAmount],[TotalCredit],[IsUnlimited],[ISPayPerUse],[ActiveStatus],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[IsMultiService])
				   SELECT @UserPlanDetailsId ,CNPLanBucketId,BucketName,PlanBucketType,WalletAmount,
				   TotalCredit,IsUnlimited,IsPayPerUse,'Y',@UploadedBy,GETDATE(),@UploadedBy,GETDATE(),
				   IsMultiService
				   FROM CNPlanBucket WHERE CNPlanDetailsId=@PlanId and ActiveStatus='Y'

				   --INSERT INTO MemberPlanBucketDetails--
				   ---SELECT TOP 10 * FROM CNPLanBucketsDetails  order by 1 desc
				   ---SELECT TOP 10 * FROM MemberPlanBucketsDetails ORDER BY 1 DESC
				   INSERT INTO MemberPlanBucketsDetails ([MemberPLanBucketId],[CNPLanBucketRelationId],[FacilityId],[CappingLimit],[ActiveStatus],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[FacilityType],[FacilityGroup],[CappingLimitIndex])
				   SELECT  CNPB.MemberPLanBucketId,CNPBD.CNPLanBucketRelationId,CNPBD.FacilityId,
				   CNPBD.CappingLimit,CNPBD.ActiveStatus,@UploadedBy,GETDATE(),@UploadedBy,
				   GETDATE(),CNPBD.FacilityType,CNPBD.FacilityGroup,CNPBD.CappingLimitIndex
				   FROM  MemberPLanBucket CNPB
				   JOIN CNPlanBucketsDetails CNPBD ON CNPBD.CNPLanBucketId=CNPB.CNPLanBucketId
				   WHERE CNPB.UserPlanDetailsId=@UserPlanDetailsId and CNPB.ActiveStatus='Y'; 

				   ---ENTRY IN MEMBERBUCKETBALANCE AS DEFAULT ENTRY---
				   --SELECT TOP 10 * FROM MemberBucketBalance ORDER BY 1 DESC;

				   --- --SELECT TOP 10 * FROM MemberPlanBucket WHERE CNPlanDetailsId=896 order by 1 desc                                                                       
				   INSERT INTO MemberBucketBalance ([UserPlanDetailsId],[MemberPLanBucketId],[MemberId],[UserLoginId],[BalanceAmount],[TransactionAmount],[BalanceCredit],[TransactionCredit],[AmountSource],[WalletTransactionType],[TransactionId],[AppointmentId],[ActiveStatus],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[Facilityids],[IsReimbursement],[ReimbursementBalanceAmount],[ReimbursementBalanceCredit],[FacilityGroupId])
				   SELECT @UserPlanDetailsId ,MemberPLanBucketId,@MemberId,@UserLoginId,
				   WalletAmount,NULL,TotalCredit,NULL,NULL,NULL,NULL,NULL,ActiveStatus,
				   @UploadedBy,GETDATE(),@UploadedBy,GETDATE(),NULL,NULL,NULL,NULL,NULL
				   FROM MemberPLanBucket WHERE UserPlanDetailsId=@UserPlanDetailsId and ActiveStatus='Y';


				   ---ENTRY MemberPlanMapping  ----
				   --SELECT TOP 10 * From MemberPlanMapping order by 1 desc

				   Insert INTO MemberPlanMapping ([MemberId],[PlanId],[MemberPlanId],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[IsPaidMember],[UserPlanDetailsId])
				   VALUES(@MemberId,@PlanId,NULL,'Y',@UploadedBy,GETDATE(),@UploadedBy,GETDATE(),NULL,@UserPlanDetailsId);
				     


				   SET @Message = @Message+'Self User Registered as Member successfully, ';
			     SET @ColumnName = @ColumnName + 'UserLoginName,Member ';
				  

				 END--INSERTING SELF USER END
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
			         BEGIN ---MEMBER VALID SECTION START
			            IF @UserLoginId IS NOT NULL
						   BEGIN
						      DECLARE @existrelationcount bigint= (select count(userloginid) from member where userloginid=@userloginid and relation!='self' and IsActive='Y');

							  IF (@MaxRelationAllowed) <= @existrelationcount
							    BEGIN
								    print 'rel count exausted'
				                    SET @Message = @Message+'Relation count 
									exausted and Member is not Added, ';
				                    SET @ColumnName= @ColumnName + 'Relation, '
								END
                              ELSE
							    BEGIN--SELF User Have Enough RelationCount to insert A memeber  START

								    DECLARE @relationIdsStr varchar(MAX);
                                    DECLARE @relationNameStrs varchar(MAX);
                                    SELECT @relationIdsStr= STRING_AGG(RelationIds, ',')  
									      From CNPlanRelation WHERE CNPlanDetailsId=@PlanId;

                                    SELECT @relationNameStrs= STRING_AGG(Relation, ',')  
									From RelationMaster WHERE 
									      RelationId in (select * from SplitString (@relationIdsStr,','));

                                    PRINT 'relationid '+ @relationIdsStr
                                    PRINT 'relationname '+ @relationNameStrs
                                    DECLARE @idRelation bigint;
                                    SElECT  @idRelation= RelationId FROM RelationMaster Where Relation=@Relation;
                                    IF CHARINDEX(CAST(@idRelation AS VARCHAR(10)),@relationIdsStr)>0 
                                      BEGIN --valid relation Adding Member Section in plan Start
                                        PRINT 'TRUE RELATION ALLOWED TO ADD MEMBER'
										INSERT INTO Member 
									    ([UserLoginId], [FirstName], [LastName], [Relation], [DOB], [Gender],                   [MobileNo], [EmailId],  [IsActive],
									     [CreatedBy], [CreatedDate],
									     [UpdatedBy], [UpdatedDate])    
                                         VALUES   (@UserLoginId,@MemberFirstName,@MemberLastName,
									     @Relation,@Dob,@Gender,@correctedmobileno,@MemberEmail,'Y',
									     @UploadedBy,Getdate(),@UploadedBy,Getdate());

					                    SELECT  @MemberId = SCOPE_IDENTITY(); 

										DECLARE @SelfMemberId BIGINT;
										SELECT @SelfMemberId = MemberId FROM Member where UserLoginId=@UserLoginId and Relation='SELF';

										SELECT @UserPlanDetailsId = UserPlanDetailsId FROM UserPlanDetails Where MemberId=@SelfMemberId and CNPlanDetailsId=@PlanId;

										 Insert INTO MemberPlanMapping ([MemberId],[PlanId],[MemberPlanId],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[IsPaidMember],[UserPlanDetailsId])
				               VALUES(@MemberId,@PlanId,NULL,'Y',@UploadedBy,GETDATE(),@UploadedBy,GETDATE(),NULL,@UserPlanDetailsId);

					                     PRINT  'Other Relation successfully added in database'
									    SET @Message = @Message+'Member with ('+ @Relation + ') successfully added in Member Table, ';
			                        SET @ColumnName= @ColumnName + 'Relation, '
                                      END--valid relation Adding Member Section in plan END
                                    ELSE
                                       BEGIN
                                          print 'Not Allowed Relation'
										  
				                          SET @Message = @Message+'You Cannot Add Member As '+@Relation+ ' In Current Plan, Only These Relation are Allowed 
										  ALLOWED_RELATION('+@relationNameStrs+') ,'
				                          SET @ColumnName= @ColumnName + 'Relation, '
                                       END
								 
								END--SELF User Have Enough RelationCount to insert A memeber  End
						   END----USERLOGIN ID IS NOT NULL
						   ELSE 
						     BEGIN
							    PRINT 'self user is not Exist our database' 
			                    SET @Message = @Message+'Self user does not exist in our database, ';
			                    SET @ColumnName= @ColumnName + 'UserLoginName,'
							 END
			         END---MEMBER VALID SECTION ENS
			   END--MEMBER SECTION END IF USER NOT WITH SELF
		  
		END--PARENT ELSE VALID SECTION	END 
  


  ---APPOINTMENT BOOKING SECTION START FOR CNPLANDETAILS AND NEW USER LOGIN ID--
        IF @UserPlanDetailsId IS NULL
		   BEGIN

		      SET @UserPlanDetailsId=(SELECT TOP 1 UserPlanDetailsId FROM UserPlanDetails WHERE  
			  MemberId=(SELECT MemberId from Member Where UserLoginId=@UserLoginId and relation='SELF') 
			  and CNPlanDetailsId=@PlanId and ClientId=@ClientId)
		   END

		   IF (@UserLoginId is null)
            BEGIN
              SET @UserLoginId= (select userloginid from member where memberid=@MemberId);
            END
        

          DECLARE @XML AS xml;      
          DECLARE @Delimiter AS char(1) = ',';      
          DECLARE @date datetime;       
          SET @XML = CAST(('<X>' + REPLACE(@PackageId, @Delimiter, '</X><X>') + '</X>') AS xml)       
          SET @date = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AppointmentDate, 103), 102) + ' ' + @AppointmentTime, 121);
          print @date;
		  DECLARE @AppointmentId bigint=-1;
		  DECLARE @AvailableCreditCount bigint
		  DECLARE @FacilityType VARCHAR(150);
		  DECLARE @FacilityGrop VARCHAR(150);
		  DECLARE @AppointmentType varchar(100);
		  select @FacilityType= FacilityType,@FacilityGrop=FacilityGroup,@AppointmentType=ProcessCode from FacilitiesMaster where facilityid=@packageid;

		  DECLARE @AppointmentNeedToBook VARCHAR(1)='N'
		  DECLARE @FacilityCreditPoint BIGINT ;
		  
		  Declare @CNPlanBucketRelationIdString VARCHAR(150)=''
		  DECLARE @RelationName varchar(100);
		  SELECT @RelationName  = Relation from Member Where MemberId=@MemberId;
		  DECLARE @RelationId BIGINT;
		  SELECT @RelationId= RelationId From RelationMaster Where Relation =@RelationName

		  IF @RelationName = 'SELF' OR @RelationName = 'self' or @RelationName = 'Self'
		   BEGIN
		      set @RelationId=0
		   END

		  DECLARE @MemberPlanBucketId BIGINT;
		  DECLARE @CaseNo VARCHAR(100);
		  DECLARE @alternatedate datetime = NULL;
		  DECLARE @AlternateAppointmentDate varchar(10) = NULL;                               
          DECLARE @AlternateAppointmentTime varchar(10) = NULL; 
		  DECLARE @LastApptLogId varchar(100);
          DECLARE @LastApptDetailsLogId Varchar(100); 
		  DECLARE @SumOfCreditPoint bigint;
		  DECLARE @SumOfDebitPoint bigint;
		  DECLARE @TotalCredit bigint;
		  DECLARE @ActualFacilityCreditPoinOnMemberLevel bigint;
		  DECLARE @ActualFacilityCreditPoint bigint;

		  SET @XML = CAST(('<X>' + REPLACE(@PackageId, @Delimiter, '</X><X>') + '</X>') AS xml)       
          SET @date = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AppointmentDate, 103), 102) + ' ' + @AppointmentTime, 121);
          print @date;

		  

		  IF ISNULL(@AlternateAppointmentDate, '') != '' AND ISNULL(@AlternateAppointmentTime, '') != ''                                          
           BEGIN     ---2                                     
             SET @alternatedate = CONVERT(datetime, CONVERT(varchar, CONVERT(date, @AlternateAppointmentDate, 103), 102) + ' ' + @AlternateAppointmentTime, 121);                                          
           END   ---2

  IF @UserLoginId IS NULL 
     BEGIN
	    SET @Message = @Message+'Some thing went wrong, Please Check Missing Column';
	    SET @ColumnName= @ColumnName + 'MISSING(@UserLoginId), '
	 END
 ELSE IF  @MemberId IS NULL 
     BEGIN
	    SET @Message = @Message+'Some thing went wrong, Please Check Missing Column';
	    SET @ColumnName= @ColumnName + 'MISSING(@MemberId), '
	 END

ELSE IF  @UserPlanDetailsId IS NULL 
     BEGIN
	    SET @Message = @Message+'Some thing went wrong, Please Check Missing Column';
	    SET @ColumnName= @ColumnName + 'MISSING(@UserPlanDetailsId), '
	 END

ELSE IF  @CNPLanBucketId IS NULL 
     BEGIN
	    SET @Message = @Message+'Some thing went wrong, Please Check Missing Column';
	    SET @ColumnName= @ColumnName + 'MISSING(@CNPLanBucketId), '
	 END
ELSE IF   @PackageId IS NULL 
     BEGIN
	    SET @Message = @Message+'Some thing went wrong, Please Check Missing Column';
	    SET @ColumnName= @ColumnName + 'MISSING(@PackageId), '
	 END
  ELSE
     BEGIN
	    DECLARE @PlanBucketType VARCHAR(100);
		SELECT @PlanBucketType=   PLanBucketType FROM MemberPLanBucket WHERE UserPlanDetailsId=@UserPlanDetailsId AND CNPLanBucketId =@CNPLanBucketId;
		IF @PlanBucketType IS NULL OR @PlanBucketType!='CREDIT'
		   BEGIN
		       SET @Message = @Message+'CNPlanBucketId is not type of CREDIT, ';
	           SET @ColumnName= @ColumnName + 'CNPlanBucketId, ';
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
		  BEGIN
		     DECLARE @IsCreditUnLimited VARCHAR(10);
			 
		    
			 DECLARE @MemberPlanBucketFacilityId BIGINT = -1;
			 SELECT @IsCreditUnLimited=IsUnlimited FROM MemberPLanBucket WHERE UserPlanDetailsId=@UserPlanDetailsId AND CNPLanBucketId =@CNPLanBucketId;
			 DECLARE @ScheduleStatus varchar(100)=1;
			 

			 --CHECK IF FACILITYID EXIST OR NOT IN MEMBERPLANBUCKESDETAILS 
			 --THIS STATEMENT WHERE FACILITYID IS ZERO SELECT ALL CASE
			 SELECT @MemberPlanBucketFacilityId =  ISNULL(FacilityId,-1),@FacilityCreditPoint=CappingLimit,
			 @CNPlanBucketRelationIdString=CNPLanBucketRelationId , @MemberPlanBucketId=MPBD.MemberPLanBucketId From MemberPlanBucketsDetails MPBD
                  JOIN MemberPlanBucket MPB on MPB.MemberPLanBucketId=MPBD.MemberPLanBucketId
                  WHERE MPB.UserPlanDetailsId=@UserPlanDetailsId and MPBD.FacilityGroup=@FacilityGrop  and MPB.CNPLanBucketId=@CNPLanBucketId and MPBD.ActiveStatus='Y' and MPB.ActiveStatus='Y' and MPBD.FacilityId=0 and MPBD.FacilityType=@FacilityType;


            --IF FACILITY ID IS NOT ZERO AND IT'S NOT THE CASE OF SELECT ALL
			IF @MemberPlanBucketFacilityId=-1
			  BEGIN
			    SELECT @MemberPlanBucketFacilityId =  ISNULL(FacilityId,-1),@FacilityCreditPoint=CappingLimit ,
				@CNPlanBucketRelationIdString=CNPLanBucketRelationId ,@MemberPlanBucketId=MPBD.MemberPLanBucketId From MemberPlanBucketsDetails MPBD
                  JOIN MemberPlanBucket MPB on MPB.MemberPLanBucketId=MPBD.MemberPLanBucketId
                  WHERE MPB.UserPlanDetailsId=@UserPlanDetailsId and MPBD.FacilityId=@PackageId  and MPB.CNPLanBucketId=@CNPLanBucketId and MPBD.ActiveStatus='Y' and MPB.ActiveStatus='Y'
			  END

			  SELECT @ActualFacilityCreditPoinOnMemberLevel  = CappingLimit FROM CNPLanBucketRelation where CNPLanBucketRelationId IN (select * from SplitString(@CNPlanBucketRelationIdString,',')) and RelationId=@RelationId

			  DECLARE @IsCreditDefinedOnMemberLevel VARCHAR(10) = 'N'
			  ---IMPORTANT LOGIC HANDLING MEMBERLEVEL CAPPING IN -
			  IF  ISNULL(@ActualFacilityCreditPoinOnMemberLevel,0) =0
			    BEGIN
				   IF ISNULL( @FacilityCreditPoint,0)!=0
				    BEGIN
					   SET @ActualFacilityCreditPoint=@FacilityCreditPoint;
					END
				END
			 ELSE
			    BEGIN
				   SET @IsCreditDefinedOnMemberLevel='Y'
				   SET @ActualFacilityCreditPoint=@ActualFacilityCreditPoinOnMemberLevel;
				END

				PRINT '@ActualFacilityCreditPoint'
				PRINT @ActualFacilityCreditPoint
			
			 SELECT @SumOfDebitPoint = SUM(ISNULL(TransactionCredit,0)) from MemberBucketBalance Where UserLoginId=@UserLoginId and UserPlanDetailsId=@UserPlanDetailsId and MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y' and  WalletTransactionType='DEBIT';

			 SELECT @SumOfCreditPoint=SUM(ISNULL(TransactionCredit,0)) from MemberBucketBalance Where UserLoginId=@UserLoginId and UserPlanDetailsId=@UserPlanDetailsId and MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y' and  WalletTransactionType='CREDIT';


			
			 SELECT @TotalCredit=ISNULL(TotalCredit,0) from MemberPlanBucket 
			 WHERE MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y';

			 SET @AvailableCreditCount=ISNULL(@TotalCredit,0)-ISNULL(@SumOfDebitPoint,0)
			 SET @AvailableCreditCount = @AvailableCreditCount+ISNULL(@SumOfCreditPoint,0)

			 DECLARE @CNPlanBucketRelationIdForActualRelationOnMemerLevel bigint;
			  SELECT @CNPlanBucketRelationIdForActualRelationOnMemerLevel  = RelationId FROM CNPLanBucketRelation where CNPLanBucketRelationId IN (select * from SplitString(@CNPlanBucketRelationIdString,',')) and RelationId=@RelationId

			  print '@CNPlanBucketRelationIdString'
			  print @CNPlanBucketRelationIdString

			  print '@CNPlanBucketRelationIdForActualRelationOnMemerLevel '
			  print @CNPlanBucketRelationIdForActualRelationOnMemerLevel 
			

			  IF @MemberPlanBucketFacilityId =-1
			     BEGIN
				   SET @Message= @Message+ 'This PackageId is not mapped with Plan Buckets'
                   SET @ColumnName=@ColumnName+ 'PackageId,PlanId'
				 END
			ELSE IF ISNULL(@CNPlanBucketRelationIdString,'')!='' and @CNPlanBucketRelationIdForActualRelationOnMemerLevel  is null 
			   BEGIN
			      SET @Message= @Message+ 'This Facility Has contain member level defination and your given reation is not valid For Appointment Booking. '
                   SET @ColumnName=@ColumnName+ 'relationId,'
			   END
			ELSE 
			   BEGIN
			      IF ISNULL(@ActualFacilityCreditPoint,0)=0 
				     BEGIN
					    IF ISNULL(@IsCreditUnlimited,'N')='Y'
						   BEGIN
						      PRINT 'APPOINTMENT BOOKING SECTION UNLIMITED CREDIT.';
						      SET @AppointmentNeedToBook='Y'
						   END
						ELSE
						  BEGIN
						     IF @AvailableCreditCount<1
				                BEGIN
					              SET @Message= @Message+ 'Avalable Credit Point Is Less Than Required 
								  Credit Point,AppointmentBooking Stopped'
                                  SET @ColumnName=@ColumnName+ '@FacilityCreditPoint,@AvailableCreditCount, '
					            END
				             ELSE
				                BEGIN
				                  SET @AppointmentNeedToBook='Y'
					              PRINT 'APPOINTMENT BOOKING START'
				                END
						  END
					 END
				  
				  ELSE 
				    BEGIN
					   --we are finding the consumed credit facility---

					   DECLARE @FinalConsumedCreditPoint BIGINT;

					   --WE ARE FINDING CONSUMED FACILITY WITHOUT RELATION --

					   DECLARE @ConsumeCreditWithoutRelation bigint;
					   DECLARE @CancelAppointmentCreditWitoutRelation bigint;

					   SELECT @ConsumeCreditWithoutRelation=SUM(ISNULL(mbb.TransactionCredit,0)) from MemberBucketBalance mbb Where mbb.UserLoginId=@UserLoginId and mbb.UserPlanDetailsId=@UserPlanDetailsId and mbb.MemberPlanBucketId=@MemberPlanBucketId and mbb.ActiveStatus='Y' and mbb.Facilityids=@packageid 
					   and WalletTransactionType='DEBIT';

					   SELECT @CancelAppointmentCreditWitoutRelation = SUM(ISNULL(mbb.TransactionCredit,0)) from MemberBucketBalance mbb Where mbb.UserLoginId=@UserLoginId and mbb.UserPlanDetailsId=@UserPlanDetailsId and mbb.MemberPlanBucketId=@MemberPlanBucketId and mbb.ActiveStatus='Y' and mbb.Facilityids=@packageid  and WalletTransactionType='CREDIT';

					    ---FINAL CONSUMED CREDIT ON WITHOUT RELATION LEVE---
					   SET @ConsumeCreditWithoutRelation=ISNULL(@ConsumeCreditWithoutRelation,0)-ISNULL(@CancelAppointmentCreditWitoutRelation,0)




					   ---WE ARE FINDING ON MEMBER LEVEL---
					   DECLARE @ConsumedCreditOnMemberLevel bigint;
					   DECLARE @CancelAppointmentCreditOnMemberLevel bigint;

					   ----@ConsumedFacilityCreditCountForGivenFacilityIdInMemberBucketBalance---
					   SELECT @ConsumedCreditOnMemberLevel=
					   SUM(ISNULL(mbb.TransactionCredit,0)) from MemberBucketBalance mbb Where mbb.UserLoginId=@UserLoginId and mbb.UserPlanDetailsId=@UserPlanDetailsId and mbb.MemberPlanBucketId=@MemberPlanBucketId and mbb.ActiveStatus='Y' and mbb.Facilityids=@packageid and (SELECT Relation From Member Where MemberId=mbb.MemberId)=@Relation and WalletTransactionType='DEBIT';


					   --- @FacilityCreditCountForGivenFacilityIdInMemberBucketBalanceForCancelAppoibtment---
					   SELECT @CancelAppointmentCreditOnMemberLevel=SUM(ISNULL(mbb.TransactionCredit,0)) from MemberBucketBalance mbb Where mbb.UserLoginId=@UserLoginId and mbb.UserPlanDetailsId=@UserPlanDetailsId and mbb.MemberPlanBucketId=@MemberPlanBucketId and mbb.ActiveStatus='Y' and mbb.Facilityids=@packageid and (SELECT Relation From Member Where MemberId=mbb.MemberId)=@Relation and WalletTransactionType='CREDIT';

					   ---FINAL CONSUMED CREDIT ON MEMBER LEVEL---
					   SET @ConsumedCreditOnMemberLevel=ISNULL(@ConsumedCreditOnMemberLevel,0)-ISNULL(@CancelAppointmentCreditOnMemberLevel,0)


					   PRINT '@ConsumedFacilityCreditCountForGivenFacilityIdInMemberBucketBalance'
					   PRINT ISNULL(@ConsumedCreditOnMemberLevel,0)

					   PRINT '@ConsumeCreditWithoutRelation'
					   PRINT ISNULL(@ConsumeCreditWithoutRelation,0)

					   IF @IsCreditDefinedOnMemberLevel = 'Y'
					     BEGIN 
						    SET @FinalConsumedCreditPoint=ISNULL(@ConsumedCreditOnMemberLevel,0);
						 END
					   ELSE
					     BEGIN
						   SET @FinalConsumedCreditPoint=ISNULL(@ConsumeCreditWithoutRelation,0);
						 END

						 PRINT '@FinalConsumedCreditPoint'
						 PRINT @FinalConsumedCreditPoint

						 PRINT '@ActualFacilityCreditPoint'
						 PRINT @ActualFacilityCreditPoint

					  If ISNULL(@ConsumeCreditWithoutRelation,0)>=@FacilityCreditPoint and @FacilityCreditPoint is not null
					   begin
					     SET @Message= @Message+ 'Credit Is Exhaust For Current FacilityId, '
                            SET @ColumnName=@ColumnName+ '@ConsumeCreditWithoutRelation, '
					   end
					   else IF ISNULL(@FinalConsumedCreditPoint,0)<@ActualFacilityCreditPoint
					      BEGIN
						     IF @AvailableCreditCount<1
				                BEGIN
					              SET @Message= @Message+ 'Avalable Credit Point Is Less Than Required 
								  Credit Point,AppointmentBooking Stopped'
                                  SET @ColumnName=@ColumnName+ '@FacilityCreditPoint,@AvailableCreditCount, '
					            END
				             ELSE
				                BEGIN
				                  SET @AppointmentNeedToBook='Y'
					              PRINT 'APPOINTMENT BOOKING START'
				                END
						  END
                       ELSE
					     BEGIN
						    SET @Message= @Message+ 'Credit Is Exhaust For Current FacilityId,  '
                            SET @ColumnName=@ColumnName+ '@FinalConsumedCreditPoint, '
						 END 
					END
			     
			     
			   END
		  END
	 END
  


  IF @AppointmentNeedToBook ='Y'
     BEGIN
	    

		---select top 10 * from Appointment order by 1 desc----
        INSERT INTO [dbo].[Appointment] ([MemberId],[UserTypeMappingId],[UserLoginId],[ScheduleStatus],[VisitType],[AppointmentType],[IsActive],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate]                               
				,[ClientId],[MobileNo],[AppointmentAddress],[DocCoachApptType], UserPlanDetailsId, MemberPlanBucketId)                      
				VALUES (@MemberId, 1, @UserLoginId, @ScheduleStatus, @AppointmentVisitType, @AppointmentType,  'Y', @UploadedBy, GETDATE(), @UploadedBy, GETDATE(), @ClientId, @correctedmobileno,@UserAddress, 
				 'Excel Upload', @UserPlanDetailsId, @MemberPlanBucketId);                            
				SET @AppointmentId = SCOPE_IDENTITY()

				SELECT @CaseNo= [dbo].[fnGetCaseNo](@AppointmentId)                   
                                            
               UPDATE [Appointment] SET CaseNo = @CaseNo WHERE AppointmentId = @AppointmentId;
			   
			   --APPOINTMENT DETAILS TABLE---

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

			   ----------------Appointment log---------------------------------------- 
		    INSERT INTO [AppointmentLog] ([AppointmentId]  , [ScheduleStatus], [Remarks], [UserLoginId] , [CreatedBy], [CreatedDate])                 
            VALUES (@AppointmentId, @ScheduleStatus, 'Requested', @UserLoginId,@UploadedBy, GETDATE())                                            
            SELECT @LastApptLogId = SCOPE_IDENTITY();                                            
            PRINT @LastApptLogId      
            PRINT 'Record insert successfully in AppointmentLog Table'
			
			---------------Appointment log  details----------------------------------------  

			INSERT INTO [dbo].[AppointmentLogDetails] ( [AppointmentLogId] , [AppointmentDetailId], [AppointmentDateTime] , [TestCompletionStatus] , [ProviderId]  , [HomeVisit]  , [CreatedBy]    , [CreatedDate])                                            
               (SELECT   @LastApptLogId, ad.AppointmentDetailId, ad.AppointmentDateTime,   ad.TestCompletionStatus, @ProviderId, ad.HomeVisit,   @UploadedBy, GETDATE() 
			     FROM AppointmentDetails ad                                            
                 WHERE ad.AppointmentId = @AppointmentId);

		    SELECT @LastApptDetailsLogId = SCOPE_IDENTITY();                                                                           
            PRINT @LastApptDetailsLogId;    
            PRINT 'Record insert successfully in AppointmentLogDetails Table'

			DECLARE @FacilityGroupId BIGINT;
			SELECT @FacilityGroupId=FacilityId FROM FacilityGroupCombinaton WHERE FacilityGroupName=@FacilityGrop AND IsActive='Y'
		   

				INSERT INTO MemberBucketBalance(UserPlanDetailsId, MemberPLanBucketId,UserLoginId,MemberId,BalanceCredit,TransactionCredit ,AmountSource, WalletTransactionType, AppointmentId, ActiveStatus, CreatedDate, UpdatedDate, Facilityids, FacilityGroupId)
				VALUES(@UserPlanDetailsId, @MemberPlanBucketId,@UserLoginId,@MemberId,(@AvailableCreditCount-1) ,1,CONCAT(@FacilityGrop, ' Booking'), 'DEBIT', @AppointmentId, 'Y', GETDATE(), GETDATE(), @PackageId, @FacilityGroupId)



				SET @Message=@Message+ 'Appointment Booked Successfully'
	        SET @ColumnName=@ColumnName+'Appointment'
	        SET @Status=1
	        SET @Success='TRUE'

	 END
 ELSE
   BEGIN
      SET @Message=@Message+ 'Appointment Booked Failed.'
	        SET @ColumnName=@ColumnName+'Appointment'
   END


PRINT 'LOLA'

--SELECT @ColumnName AS ColumnName, @Message AS Message
	INSERT INTO  ##GlobalLogResultCampBooking VALUES(@ColumnName,@Status,@Success,@Message)

END