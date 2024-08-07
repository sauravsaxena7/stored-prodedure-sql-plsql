USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[GetBulkActiveUser]    Script Date: 12/6/2023 5:34:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
	
--EXEC [dbo].[GetBulkActiveUser] '719','292',1,1000,'OPD'
                                      
ALTER PROCEDURE [dbo].[GetBulkActiveUser]   
                             
 @Plan varchar(100)                                    
,@ClientId varchar(100)                                                                           
,@pageNumber int=1  --page Number                                
,@recordPerPage int=10                                
                             
,@buType varchar(100) = null                                    



AS                                    
BEGIN                                   
Declare @totalRows int ,@DisplayFromDate datetime,@DisplayToDate datetime   
select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50),@DisplayFromDate = isnull(GETDATE(),@DisplayFromDate),@DisplayToDate=isnull(Getdate(),@DisplayToDate)                                                          
                                                                    
select distinct u.UserLoginId,u.UserName,cp.CorporatePlanId,cp.PlanName,c.ClientId,c.ClientName,u.FirstName,u.LastName,m.MobileNo,m.EmailId,IsNull(u.CreatedDate,'') as UserCreatedDate,IsNull(mp.ToDate,'') as PlanExpiryDate,             
isnull(cp.PlanCode,'') as PlanCode,mp.MemberPlanId,m.MemberId,cp.PlanType,mp.planAmount,u.ClientHrName,u.ClientHrEmailId,u.EmpNo,L.PolicyNo
,CASE WHEN(u.Status = 'A') THEN 'Active'
      WHEN(u.Status = 'I') THEN 'Inactive'
	  WHEN(u.Status = 'L') THEN 'Locked'
	  WHEN(u.Status = 'T') THEN 'Temporary'
	  WHEN(u.Status = 'V') THEN 'Verifyed'
	  ELSE 'Inactive'
      END as Status, -------------Table 1
  ([dbo].[GetUserPolicyStatusFunction](u.UserLoginId,L.PolicyNo)) As PolicyStatus
  
from UserLogin u                                    
inner join Member m on u.UserLoginId=m.UserLoginId                                    
inner join MemberPlan mp on m.MemberId=mp.MemberId                                                
inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId                                    
inner join client c on cp.clientId=c.clientId 
inner join LibertyEmpRegistration L on L.MemberPlanId = mp.MemberPlanId                           
where m.Relation='SELF' AND u.Status<>'I' and ([dbo].[GetUserPolicyStatusFunction](u.UserLoginId,L.PolicyNo))='Y'
and (@buType is null OR c.BUType like '%'+@buType+'%')                                      
and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                             
and (@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')) )   
                             
                                   
order by UserCreatedDate 
--offset @RecordPerPage * (@PageNumber-1)rows                                
--FETCH NEXT @RecordPerPage rows only   
END