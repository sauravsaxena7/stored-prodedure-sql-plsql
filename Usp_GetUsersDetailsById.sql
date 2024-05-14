USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Usp_GetUsersDetails]    Script Date: 11/28/2023 8:35:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC  [dbo].[Usp_GetUsersDetails]  520818
ALTER Proc [dbo].[Usp_GetUsersDetails]                
@UserLoginID int                
as                
begin     
    
select distinct UL.UserLoginId,M.FirstName,M.LastName,UL.UserName,UL.MobileNo,M.MemberId,UL.ClientId,isnull(M.DOB,getdate()) as DOB,M.Gender,M.EmailId,                
mp.CorporatePlanId,MP.MemberPlanId,cp.plancode,CP.PlanName, convert(varchar, MP.FromDate, 126) as PlanFrom           
,convert(varchar, MP.ToDate, 126) as PlanTo,isnull(CP.AgeFrom,0) as AgeFrom,isnull(CP.AgeTo,0) as AgeTo,CP.PlanAmount,               
CP.IsActive As PlanIsActive,CP.CreatedDate as PlanCreateDtae,UL.Status,UL.CreatedBy,                
UL.CreatedDate,UL.UpdatedBy,UL.UpdatedDate,isnull(UL.Language   ,'') as Language ,isnull(lr.PolicyNo,'')  as PolicyNo ,
ISNULL(UL.UnblockByAdminId,0) AS UnblockByAdminId,
ISNULL((SELECT top 1 name FROM [HAModuleUAT].[ops].[Admin] where id=UL.UnblockByAdminId),'') AS UnblockByAdminName
from UserLogin as UL                 
inner join Member M on M.UserLoginId=UL.UserLoginId                 
inner join MemberPlan MP on MP.memberid=m.memberid   and MP.IsActive='Y'        
inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId    
--join CorporatePlanRelation CPI on CPI.CorporatePlanId=mp.CorporatePlanId                
inner Join Client C on C.ClientId=Ul.ClientId               
left join libertyempregistration lr on lr.UserLoginId=ul.UserLoginId   and lr.PlanCode=cp.PlanCode --and lr.ClientId=cp.ClientId and cp.IsActive='Y'         
where UL.UserLoginId=@UserLoginID and MP.Isactive='Y'    
    
    
--select distinct UL.UserLoginId,M.FirstName,M.LastName,UL.UserName,UL.MobileNo,M.MemberId,UL.ClientId,isnull(M.DOB,getdate()) as DOB,M.Gender,M.EmailId,                
--mp.CorporatePlanId,MP.MemberPlanId,cp.plancode,CP.PlanName, convert(varchar, MP.FromDate, 126) as PlanFrom           
--,convert(varchar, MP.ToDate, 126) as PlanTo,isnull(CP.AgeFrom,0) as AgeFrom,isnull(CP.AgeTo,0) as AgeTo,CP.PlanAmount,               
--CP.IsActive As PlanIsActive,CP.CreatedDate as PlanCreateDtae,UL.Status,UL.CreatedBy,                
--UL.CreatedDate,UL.UpdatedBy,UL.UpdatedDate,isnull(UL.Language   ,'') as Language ,isnull(lr.PolicyNo,'')  as PolicyNo          
--from UserLogin as UL                 
--inner join Member M on M.UserLoginId=UL.UserLoginId                 
--inner join MemberPlan MP on MP.memberid=m.memberid    -- and MP.IsActive='Y'        
--inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId    
----join CorporatePlanRelation CPI on CPI.CorporatePlanId=mp.CorporatePlanId                
--inner Join Client C on C.ClientId=Ul.ClientId               
--join libertyempregistration lr on lr.UserLoginId=ul.UserLoginId     and lr.PlanCode=cp.PlanCode and lr.ClientId=cp.ClientId and cp.IsActive='Y'         
--where UL.UserLoginId=576840 and MP.Isactive='Y'    
               
               
--select distinct UL.UserLoginId,M.FirstName,M.LastName,UL.UserName,UL.MobileNo,M.MemberId,UL.ClientId,isnull(M.DOB,getdate()) as DOB,M.Gender,M.EmailId,                
--mp.CorporatePlanId,MP.MemberPlanId,cp.plancode,CP.PlanName, convert(varchar, CP.FromDate, 126) as PlanFrom           
--,convert(varchar, CP.ToDate, 126) as PlanTo,isnull(CP.AgeFrom,0) as AgeFrom,isnull(CP.AgeTo,0) as AgeTo,CP.PlanAmount,               
--CP.IsActive As PlanIsActive,CP.CreatedDate as PlanCreateDtae,UL.Status,UL.CreatedBy,                
--UL.CreatedDate,UL.UpdatedBy,UL.UpdatedDate,isnull(UL.Language   ,'') as Language ,isnull(lr.PolicyNo,'')  as PolicyNo       
--from UserLogin as UL                 
--inner join Member M on M.UserLoginId=UL.UserLoginId                
--inner join MemberPlan MP on MP.memberid=m.memberid              
--inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId                
----join CorporatePlanRelation CPI on CPI.CorporatePlanId=mp.CorporatePlanId                
--inner Join Client C on C.ClientId=Ul.ClientId               
----join Appointment A on A.UserLoginId=Ul.UserLoginId     
--join libertyempregistration lr on lr.UserLoginId=ul.UserLoginId              
    
--where UL.UserLoginId=@UserLoginID and MP.Isactive='Y' --and  UL.Status='A'      
          
--select * from Member where UserLoginId=735399          
          
            
--select top 10* from UserLogin where ClientId in(292) order by 1 desc    
    
end 
