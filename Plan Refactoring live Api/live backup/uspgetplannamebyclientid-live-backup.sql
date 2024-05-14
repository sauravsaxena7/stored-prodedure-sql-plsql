USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspgetplannamebyclientid]    Script Date: 1/6/2024 10:51:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 ----exec uspgetplannamebyclientid 1937086,292
 ----------------------------------------------
ALTER PROCEDURE [dbo].[uspgetplannamebyclientid]                    
@userloginid varchar(50),          
@clientid varchar (50)          
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
  
 --   select c.corporateplanid,  
 --c.planname,  
 --iif(isnull(@BUType,'')='OPD',l.Createddate,c.fromdate) as FromDate,  
  
 --case when isnull(@BUType,'')='OPD'    
 --   then Dateadd(Month,iif(ISNULL(c.PlanDurationInMonths,0)=0,DateDiff(Month,c.fromdate,C.todate),c.PlanDurationInMonths),getdate())   
 --   else c.Todate end as ToDate   
  
 --,l.plancode,l.PolicyNo from userlogin u  
 --   right join LibertyEmpRegistration l on u.UserLoginId=l.userloginid  
 --join corporateplan c on c.PlanCode=l.PlanCode and u.clientid=c.ClientId  
 --where u.ClientId=@clientid  and  u.UserLoginId=  @userloginid    and c.isactive='Y'  



select mp.corporateplanid,cp.planname,mp.FromDate,mp.ToDate,cp.plancode,isnull(l.policyno,null) as PolicyNo
from userlogin u join member m on u.UserLoginId=m.UserLoginId and relation='self'
join memberplan mp on mp.memberid=m.MemberId
join CorporatePlan cp on cp.CorporatePlanid=mp.CorporatePlanId
left join LibertyEmpRegistration l on mp.MemberPlanId=l.memberplanid
where  u.UserLoginId= @userloginid  and u.ClientId=@clientid   ---added by sayali wayangankar 8 june 2023
  
 SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]  
          
end 