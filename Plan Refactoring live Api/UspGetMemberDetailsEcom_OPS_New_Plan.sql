USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspGetMemberDetailsEcom_OPS]    Script Date: 12/29/2023 4:44:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC  [dbo].[UspGetMemberDetailsEcom_OPS_New_Plan] 534805, 656
    
ALTER PROCEDURE [dbo].[UspGetMemberDetailsEcom_OPS_New_Plan]      
 @UserLoginId BIGINT,      
 @MemberPlanId BIGINT=0 
AS       
BEGIN      
 SET NOCOUNT ON;      
/****************************Start DECLARE VARIABLES*********************************/      
 DECLARE @SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@Gender VARCHAR(10),@PlanId BIGINT,@RelCount INT=0      
      
/****************************End DECLARE VARIABLES*********************************/       
      
/****************************Start Main Logic************************************************/      
 SELECT TOP 1 @Gender=m.Gender FROM UserLogin u JOIN Member m ON u.UserLoginId=m.UserLoginId AND m.Relation='SELF'       
 WHERE u.UserLoginId=@UserLoginId      
       
 SELECT @PlanId=CNPlanDetailsId FROM UserPlanDetails WHERE UserPlanDetailsId=@MemberPlanId AND ActiveStatus='Y'      
/****************************End Main Logic************************************************/      
      
/**************************SELECT ALL TABLE*******************************/      
       
 SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message] --TABLE 1      
      
 IF(ISNULL(@PlanId,0)=0)      
 BEGIN      
  SELECT M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,'') FirstName,ISNULL(LastName,'') LastName,M.Gender,Relation, 
  ISNULL(DOB,CAST('1900-01-17 00:00:00.000' AS DATETIME))AS DOB,Address1,MobileNo,C.CNPlanDetailsId as CorporatePlanId,p.MemberPlanId,STRING_AGG(C.PlanName,', ') PlanNames FROM Member m      
  LEFT JOIN MemberPlanMapping P ON M.MemberId=P.MemberId AND P.IsActive='Y' 
  LEFT JOIN CNPlanDetails C ON C.CNPlanDetailsId=P.PlanId WHERE UserLoginId=@UserLoginId AND M.IsActive='Y' ----TABLE 2      
  GROUP BY M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,''),ISNULL(LastName,''),M.Gender,Relation,DOB,Address1,MobileNo,p.MemberPlanId,C.CNPlanDetailsId END      
 ELSE      
 BEGIN      
     SELECT M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,'') FirstName,ISNULL(LastName,'') LastName,M.Gender,Relation, 
	 ISNULL(DOB,CAST('1900-01-17 00:00:00.000' AS DATETIME))AS DOB,Address1,MobileNo,C.CNPlanDetailsId as CorporatePlanId,p.MemberPlanId,STRING_AGG(C.PlanName,', ') PlanNames   
  FROM Member m        
  LEFT JOIN MemberPlanMapping P ON M.MemberId=P.MemberId AND P.IsActive='Y'   
  LEFT JOIN CNPlanDetails C ON C.CNPlanDetailsId=P.PlanId   
  WHERE UserLoginId=@UserLoginId AND P.PlanId=@PlanId AND m.Relation!='SELF' AND M.IsActive='Y' ----TABLE 2        
  GROUP BY M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,''),ISNULL(LastName,''),M.Gender,Relation,
   DOB,Address1,MobileNo,p.MemberPlanId,C.CNPlanDetailsId   
  UNION  
  SELECT M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,'') FirstName,ISNULL(LastName,'') LastName,M.Gender,Relation,
  ISnull(DOB,CAST('1900-01-17 00:00:00.000' AS DATETIME)) AS DOB,Address1,MobileNo,C.CNPlanDetailsId as CorporatePlanId,MP.UserPlanDetailsId,STRING_AGG(C.PlanName,', ') PlanNames   
  FROM Member M  
  Inner join UserPlanDetails MP on MP.MemberId=M.MemberId  
  Inner join CNPlanDetails C On C.CNPlanDetailsId=MP.CNPlanDetailsId 
  where UserLoginId=@UserLoginId AND MP.UserPlanDetailsId=@MemberPlanId AND m.Relation='SELF' AND M.IsActive='Y' ----TABLE 2     
  GROUP BY M.MemberId,M.UserLoginId,EmailId,ISNULL(FirstName,''),ISNULL(LastName,''),M.Gender,Relation,DOB,Address1,MobileNo,mp.UserPlanDetailsId,C.CNPlanDetailsId          
 END      
      
 SELECT RelationCode as Relation,R.RelationId FROM RelationMaster R JOIN CorporatePlanRelation C ON C.RelationId=R.RelationId WHERE C.CorporatePlanId=@PlanId AND R.IsActive='Y' AND C.IsActive='Y' AND RelationCode <> IIF(@Gender = 'F','WIFE','HUSBAND') ----TABLE 3      
      
 SELECT @RelCount=SUM(c.RelCount)+1 FROM CorporatePlanRelation c WHERE c.CorporatePlanId=@PlanId AND c.IsActive='Y' ----TABLE 4      
 SELECT ISNULL(@RelCount,1) AS RelCount      
/**************************SELECT ALL TABLE*******************************/    
END