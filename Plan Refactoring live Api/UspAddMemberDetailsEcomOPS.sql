USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspAddMemberDetailsEcomOPS]    Script Date: 1/10/2024 10:15:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UspAddMemberDetailsEcomOPS]  
 @UserLoginId BIGINT,  
 @MemberId BIGINT=NULL,  
 @FirstName VARCHAR(200),  
 @LastName VARCHAR(200)=NULL,  
 @EmailId VARCHAR(150)=NULL,  
 @Gender VARCHAR(10),  
 @Relation VARCHAR(100),  
 @DOB DATE=NULL,  
 @MobileNo VARCHAR(100)=NULL,  
 @Address NVARCHAR(500)=NULL,  
 @MemberPlanId BIGINT=0  
AS   
BEGIN  
 SET NOCOUNT ON;  
/****************************Start DECLARE VARIABLES*********************************/  
 DECLARE @SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@LoginUserName VARCHAR(200),@PlanId BIGINT   
 DECLARE @TotalMemberAllowed int = 0,@ExistingMemberCount int = 0,@SelfMemberId BIGINT  
/****************************End DECLARE VARIABLES*********************************/   
  
 ---------------------------------------------------  
 SELECT @LoginUserName = CONCAT(FirstName,LastName) FROM UserLogin where UserLoginId=@UserLoginId  
 SELECT @PlanId=CorporatePlanId,@SelfMemberId=MemberId FROM MemberPlan WHERE MemberPlanId=@MemberPlanId AND IsActive='Y'  
 Select @ExistingMemberCount = COUNT(MemberId) FROM MemberPlanMapping WHERE PlanId=@PlanId AND MemberPlanId=@MemberPlanId AND MemberId<>@SelfMemberId AND IsActive='Y'  
 SELECT @TotalMemberAllowed = ISNULL(SUM(RelCount),0) FROM CorporatePlanRelation WHERE CorporatePlanId = @PlanId AND IsActive='Y'  
 ----------------------------------------------------  
  
/****************************Start Main Logic************************************************/  
 IF EXISTS(SELECT 1 FROM Member WHERE UserLoginId=@UserLoginId AND MemberId=ISNULL(@MemberId,0))  
 BEGIN  
  UPDATE Member SET FirstName=@FirstName,LastName=@LastName,DOB=@DOB,Gender=@Gender,MobileNo=@MobileNo,EmailId=@EmailId,Address1=@Address,  
  UpdatedBy=@LoginUserName,UpdatedDate=@CurrentDateTime WHERE UserLoginId=@UserLoginId AND MemberId=@MemberId  
  SELECT @Message='Member Updated Successfully'  
 END  
 ELSE  
 BEGIN  
  IF NOT EXISTS(SELECT 1 FROM Member WHERE UserLoginId=@UserLoginId AND TRIM(FirstName)=TRIM(@FirstName) AND TRIM(LastName)=TRIM(@LastName) AND IsActive='Y')  
  BEGIN  
   IF(ISNULL(@MemberPlanId,0)<>0)  
   BEGIN  
    IF(@TotalMemberAllowed <= @ExistingMemberCount)  
    BEGIN  
     SELECT @Status=0,@SubCode=400,@Message = 'Member addition not allowed beyond ' + CONVERT(VARCHAR(10), @TotalMemberAllowed);  
    END  
    ELSE  
    BEGIN  
     INSERT INTO Member(UserLoginId,FirstName,LastName,Relation,DOB,Gender,MobileNo,EmailId,Address1,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
     VALUES(@UserLoginId,@FirstName,@LastName,@Relation,@DOB,@Gender,@MobileNo,@EmailId,@Address,'Y',@LoginUserName,@CurrentDateTime,@LoginUserName,@CurrentDateTime)  
     SET @MemberId=SCOPE_IDENTITY();  
     INSERT INTO MemberPlanMapping(MemberId,PlanId,MemberPlanId,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
     VALUES(@MemberId,@PlanId,@MemberPlanId,'Y',@LoginUserName,@CurrentDateTime,@LoginUserName,@CurrentDateTime)  
     SELECT @Message='Member added successfully'  
    END  
   END  
   ELSE  
   BEGIN  
    INSERT INTO Member(UserLoginId,FirstName,LastName,Relation,DOB,Gender,MobileNo,EmailId,Address1,IsActive,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
    VALUES(@UserLoginId,@FirstName,@LastName,@Relation,@DOB,@Gender,@MobileNo,@EmailId,@Address,'Y',@LoginUserName,@CurrentDateTime,@LoginUserName,@CurrentDateTime)  
    SET @MemberId=SCOPE_IDENTITY();  
    SELECT @Message='Member added successfully to your profile, please select member and add it your plan.'  
   END  
  END  
  ELSE  
  BEGIN  
   SELECT @Status=0,@SubCode=400,@Message='Member alreay exists'  
  END  
 END  
/****************************End Main Logic************************************************/  
  
/**************************SELECT ALL TABLE*******************************/  
   
 SELECT @Status AS [Status],@SubCode AS StatusCode,@Message AS [Message] --TABLE 1  
   
/**************************SELECT ALL TABLE*******************************/  
  
END