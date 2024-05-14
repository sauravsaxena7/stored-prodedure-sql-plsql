USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspgetplannamebyclientid]    Script Date: 12/30/2023 4:24:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --exec [dbo].[uspgetplannamebyclientid]  7552,454,'Y'
ALTER PROCEDURE [dbo].[uspgetplannamebyclientid]                    
@userloginid varchar(50),          
@clientid varchar (50) ,
@IsWithNewPlan VARCHAR(2)
AS    
     
 DECLARE @SubCode INT=200,  
 @Status BIT=1,  
 @Message VARCHAR(MAX)='Get Plan Successful',  
 @CurrentDate DATETIME=GETDATE()          
 Declare @MemberId varchar(50);          
 Declare @MemberplanID varchar(50);  
 Declare @BUType varchar(50);   
          
begin              
       select  @BUType= BUType from client  where clientid=@clientid  
    select @MemberId=MemberId from Member where UserLoginId=@userloginid 
	
 IF @IsWithNewPlan = 'N'
 BEGIN
   select mp.corporateplanid,cp.planname,mp.FromDate,mp.ToDate,cp.plancode,isnull(l.policyno,null) as PolicyNo
from userlogin u join member m on u.UserLoginId=m.UserLoginId and relation='self'
join memberplan mp on mp.memberid=m.MemberId
join CorporatePlan cp on cp.CorporatePlanid=mp.CorporatePlanId
left join LibertyEmpRegistration l on mp.MemberPlanId=l.memberplanid
where  u.UserLoginId= @userloginid  and u.ClientId=@clientid 
 END
 ELSE
 BEGIN
     select UP.CNPlanDetailsId as corporateplanid,  
 c.planname,UP.FromDate,UP.ToDate,c.PlanCode as plancode ,isnull(l.policyno,null) as PolicyNo
 from userlogin u  
 join member m on u.UserLoginId=m.UserLoginId and relation='self'
 join UserPlanDetails UP on UP.MemberId=m.MemberId
 join CNPlanDetails c on c.CNPlanDetailsId=UP.CNPlanDetailsId 
 join LibertyEmpRegistration l on u.UserLoginId=l.userloginid  
 where u.ClientId=@clientid  and  u.UserLoginId=  @userloginid   
 END
  
 SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]  
            
end 