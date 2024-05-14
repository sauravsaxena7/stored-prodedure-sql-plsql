USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[Usp_CancelUserPlan]    Script Date: 12/30/2023 4:55:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Usp_CancelUserForNewPlan '679','884'
Alter Proc [dbo].[Usp_CancelUserForNewPlan]          
@UserLoginId varchar(100),    
@CorporatePlanId varchar(100)    
as          
begin   
---@UserLoginId===UserPlanDetaiLSiD
declare @Plancount varchar(100);    
Declare @MemberId varchar(50);
Declare @SomeMemberId varchar(50);
Declare @MenberUserLogind varchar(50);

select @SomeMemberId=MemberId from UserPlanDetails  where UserPlanDetailsId=@UserLoginId
 select @MenberUserLogind=UserLoginId from Member  where MemberId=@MemberId
  select @MemberId=MemberId from Member  where UserLoginId=@MenberUserLogind and Relation='SELF'
select @plancount=(select count(CNPlanDetailsId) from UserPlanDetails where MemberId=@MemberId)    
--select @PlanId= CorporatePlanId from MemberPlan where = @UserLoginId and relation = 'SELF' 
Print @Plancount+' plancount'
if (@Plancount >1)    
begin    
Print @Plancount  
  
update UserPlanDetails set ActiveStatus='Y' where UserPlanDetailsId=@UserLoginId and CNPlanDetailsId=@CorporatePlanId          
--update MemberPlanDetails set IsActive='N', Isutilized='Y' where MemberId=@MemberId and CorporatePlanId=@CorporatePlanId    
end    
else    
begin    
Print 'Plan Cannot be Deleted Member has only one plan'    
end    
    
end