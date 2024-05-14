SELECT top 1 name FROM [HAModuleUAT].[ops].[Admin] where id=1
 

ISNULL(UL.LastUnblockByAdminName,'') AS LastUnblockByAdminName,
ISNULL(UL.LastUnblockedRemarksByAdmin,'') AS LastUnblockedRemarksByAdmin,
ISNULL(UL.LastInActiveByAdminName,'') AS LastInActiveByAdminName,
ISNULL(UL.LastInActiveRemarksByAdmin,'') AS LastInActiveRemarksByAdmin


SELECT TRY_CONVERT( INT ,'5678.1') as Result;
SELECT FLOOR('315.0') as Result;


--Alter Table userlogin drop column LastUnblockByAdminName,LastInActiveByAdminName, LastInActiveRemarksByAdmin,LastUnblockedRemarksByAdmin

ALTER TABLE USERLOGIN ADD LastUnblockByAdminName Varchar(50)
ALTER TABLE USERLOGIN ADD LastInActiveByAdminName Varchar(50)
ALTER TABLE USERLOGIN ADD LastInActiveRemarksByAdmin Varchar(200)
ALTER TABLE USERLOGIN ADD LastInActiveDateTime datetime

select  * from UserLogin where UserLoginId=523086
--1900-01-01 17:00:00.597

select MemberPlanId,UserLoginId,PolicyNo, * from LibertyEmpRegistration where UserLoginId=534712 
SELECT top 10 * FROM MemberPlanMapping where MemberPlanId=1546875

SELECT top 10 * FROM Member order by 1 desc

SELECT top 10 * FROM MemberPlanMapping order by 1 desc

--T ->CREDENTIAL TRIGGERED
--V->CREDENTIAL TRIGGERED-> PASSWORED RESET->ACCOUNT NOT LOGIN YET
--A->LOGIN -> ACTIVE ACCOUNT
--I-> ACCOUNT INACTIVE
--L-> WRONG PASSWORD MULTIPLE TIMES BLOCK USER


Select  * from userlogin where userLoginId=523645
Update UserLogin SET Status='A' where userLoginId=523645;

SELECT * FROM CorporatePlan WHERE CorporatePlanId=716


select * from LibertyEmpRegistration where UserLoginId=523645 and PolicyNo = 'HAOP-230324163917'
--clientid 292 and pleancode=HAOPDR005

 
select * from MemberPlan where MemberPlanId=1535254

UPDATE MemberPlan SET IsActive='Y'  WHERE MemberPlanid=1536780

select * from MemberPlanMapping where MemberPlanId=5831268
 
Plancode and clientid if Memberplanid  is NULL --> corporateplan
 
select * from CorporatePlan where Plancode='HAOPDR008' --corporateplanid=670
select * from MemberPlan where corporateplanid=670
select * from MemberPlan WHERE MemberPlanid=1536780

select * from MemberPlan where memberid=531330

--clienid -294 
---plancode HAOPDR008 

select * from member where userloginid=534712 and relation='Self'
select * from CorporatePlan where Plancode='HAOPDR008' and clientId=292;

---liberty mein krna hain
ALTER TABLE LibertyEmpRegistration ADD PolicyInActiveByAdminName Varchar(50);
ALTER TABLE LibertyEmpRegistration ADD PolicyInActiveRemarks Varchar(200);
ALTER TABLE LibertyEmpRegistration ADD PolicyInActiveDatetime datetime;

--Alter Table MemberPlan drop column PolicyInActiveByAdminName,PolicyInActiveRemarks, PolicyInActiveDatetime;


--CorporaatePlanId=742

select * from MemberPlan where CorporatePlanId=742 and MemberId=531330

select * from LibertyEmpRegistration where UserLoginId=523645 and PolicyNo = 'HAOP-230324163917'




--plancode HAOPDR005
--HAMemberid=519646

Select * from Member where memberid=519646;



--if member planid is not null
select mp.MemberPlanId from LibertyEmpRegistration  r join MemberPlan mp on R.MemberPlanId=mp.MemberPlanId AND ISNULL(r.MemberPlanId,0)<>0
R.PolicyNo=
 
 --if memberplan id is null
select mp.MemberPlanId,r.PolicyNo,r.UserLoginId from LibertyEmpRegistration  r 
join Member m on r.HAMemberId=m.MemberId 
join MemberPlan mp on m.MemberId=mp.MemberId
join CorporatePlan p on p.CorporatePlanId=mp.CorporatePlanId 
and p.PlanCode=r.PlanCode 
and p.ClientId=r.ClientId 
and cast(FORMAT(r.CreatedDate,'yyyy-MM-dd HH:mm:ss') as datetime)=cast(FORMAT(mp.createddate,'yyyy-MM-dd HH:mm:ss') as datetime) and ISNULL(r.MemberPlanId,0)=0 and r.PolicyNo='HA00-230206114924'

select * from MemberPlan where MemberPlanId=1535254




----NEW PLAN FOR USER MANAGEMENT-------
SELECT * FROM Member where MobileNo = '9449054816';

SELECT * FROM UserLogin where UserLoginId=14571

Select top 10 * from CNPlanDetails;

SELECT TOP 10 * FROM CorporatePlan

Select top 10 * from UserPlanDetails;

SELECT TOP 10 * FROM LibertyEmpRegistration;

SELECT * FROM UserLogin where UserloginId=7552
NULL