USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetUsersDetails]    Script Date: 12/30/2023 2:55:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  EXEC  [dbo].[Usp_GetUsersDetails]  524601,'Y'
ALTER Proc [dbo].[Usp_GetUsersDetails]                
@UserLoginID int ,
@IsWithNewPlan VARCHAR(1)
as                
begin     
IF @IsWithNewPlan = 'N'
BEGIN
 select distinct UL.UserLoginId,M.FirstName,M.LastName,UL.UserName,UL.MobileNo,M.MemberId,UL.ClientId,isnull(M.DOB,getdate()) as DOB,M.Gender,M.EmailId,                
mp.CorporatePlanId,MP.MemberPlanId,cp.plancode,CP.PlanName, convert(varchar, MP.FromDate, 126) as PlanFrom           
,convert(varchar, MP.ToDate, 126) as PlanTo,isnull(CP.AgeFrom,0) as AgeFrom,isnull(CP.AgeTo,0) as AgeTo,CP.PlanAmount,               
CP.IsActive As PlanIsActive,CP.CreatedDate as PlanCreateDtae,UL.Status,UL.CreatedBy,                
UL.CreatedDate,UL.UpdatedBy,UL.UpdatedDate,isnull(UL.Language   ,'') as Language ,lr.PolicyNo as PolicyNo ,
 ([dbo].[GetUserPolicyStatusFunction](UL.UserLoginId,lr.PolicyNo,'N')) As PolicyStatus
from UserLogin as UL                 
inner join Member M on M.UserLoginId=UL.UserLoginId
inner join MemberPlan MP on MP.memberid=m.memberid   and MP.IsActive='Y'        
inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId    
--join CorporatePlanRelation CPI on CPI.CorporatePlanId=mp.CorporatePlanId                
inner Join Client C on C.ClientId=Ul.ClientId               
left join libertyempregistration lr on lr.UserLoginId=ul.UserLoginId   and lr.PlanCode=cp.PlanCode --and lr.ClientId=cp.ClientId and cp.IsActive='Y'         
where UL.UserLoginId=@UserLoginID and MP.Isactive='Y'; 
END
ELSE
BEGIN
     select  distinct (UL.UserLoginId),M.FirstName,M.LastName,UL.UserName,UL.MobileNo,M.MemberId,UL.ClientId,isnull(M.DOB,getdate()) as DOB,M.Gender,M.EmailId,                
     mp.CNPlanDetailsId AS CorporatePlanId,MP.UserPlanDetailsId AS MemberPlanId,cp.plancode,CP.PlanName, convert(varchar, MP.FromDate, 126) as PlanFrom           
     ,convert(varchar, MP.ToDate, 126) as PlanTo,isnull(CP.AgeFrom,0) as AgeFrom,isnull(CP.AgeTo,0) as AgeTo,CP.PlanAmount,               
     CP.ActiveStatus As PlanIsActive,CP.CreatedDate as PlanCreateDtae,UL.Status,UL.CreatedBy,                
     UL.CreatedDate,UL.UpdatedBy,UL.UpdatedDate,isnull(UL.Language   ,'') as Language ,isnull(lr.PolicyNo,'')  as PolicyNo ,
      ([dbo].[GetUserPolicyStatusFunction](UL.UserLoginId,lr.PolicyNo,'Y')) As PolicyStatus
     from UserLogin as UL                 
     inner join Member M on M.UserLoginId=UL.UserLoginId
     inner join UserPlanDetails MP on MP.memberid=M.memberid and MP.ActiveStatus='Y'
     inner join CNPlanDetails cp on cp.CNPlanDetailsId=mp.CNPlanDetailsId and cp.ClientId=ul.ClientId   
     LEFT join libertyempregistration lr on lr.UserLoginId=@UserLoginID and lr.HAMemberId=m.MemberId
     and lr.PlanCode=cp.PlanCode        
     where UL.UserLoginId=@UserLoginID  AND CP.ActiveStatus='Y';
END  
end 
