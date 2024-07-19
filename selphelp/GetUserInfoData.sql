USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[GetUserInfoData]    Script Date: 6/12/2024 5:15:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Raj>
-- Create date: <05-06-2024>
-- Description:	<Get user Personal Data>
-- exec [dbo].[GetUserInfoData]  500480,494348,'N'
-- =============================================
ALTER PROCEDURE [dbo].[GetUserInfoData]

@Userloginid varchar(50),
@Memberid varchar(50),
@IswithNewplan varchar(50)

AS
BEGIN
	SET NOCOUNT ON;
if Isnull(@IswithNewplan,0)='N'
begin

Select u.UserloginId,m.Memberid,m.FirstName,m.LastName,m.DOB,m.Gender,m.Relation,m.Mobileno,m.Emailid,m.Address1,mp.CorporatePlanId as PlanId,'N'
from userlogin u
join member m on m.userloginid=u.userloginid
join MemberPlan mp on mp.MemberId=m.MemberId and mp.IsActive='Y'
join CorporatePlan cp on cp.CorporatePlanId=mp.CorporatePlanId 
where u.Userloginid=@userloginid and m.Memberid=@Memberid
and Relation='Self'
end

else
begin
Select u.UserloginId,m.Memberid,m.FirstName,m.LastName,m.DOB,m.Gender,m.Relation,m.Mobileno,m.Emailid,m.Address1,up.CNPlanDetailsId as PlanId,'Y' 
from userlogin u
join member m on m.userloginid=u.userloginid and Relation='Self'
join UserPlanDetails up on up.MemberId=m.MemberId and up.ActiveStatus='Y'
join CNPlanDetails cn on cn.CNPlanDetailsId=up.CNPlanDetailsId
where u.Userloginid=@userloginid and m.Memberid=@Memberid
end
END
