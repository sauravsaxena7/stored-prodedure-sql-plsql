USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspLastTransctionHistory]    Script Date: 1/3/2024 1:24:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [dbo].[uspLastTransctionHistory]  '534805'
ALTER  PROCEDURE [dbo].[uspLastTransctionHistory]     
    
@UserLoginId varchar(50)
AS
begin

CREATE TABLE #Temporary(AppointmentId BIGINT,CreatedDate DATETIME,caseNo VARCHAR(50),UserLoginid BIGINT,MemberId BIGINT,
FirstName VARCHAR(50),LastName VARCHAR(50),Relation VARCHAR(50),MobileNo VARCHAR(50),emailid VARCHAR(50),
corporateplanid BIGINT,Planname VARCHAR(50),FacilityName VARCHAR(50),ScheduleStatus VARCHAR(50),statusName VARCHAR(50))


INSERT INTO #Temporary 
select distinct a.AppointmentId,a.CreatedDate,a.caseNo,a.UserLoginid,a.MemberId,m.FirstName,m.LastName,m.Relation,m.MobileNo,m.emailid,mpd.corporateplanid,cp.Planname,
fm.FacilityName,
a.ScheduleStatus,st.statusName
from Appointment a join AppointmentDetails ad on a.AppointmentId=ad.AppointmentId
join FacilitiesMaster fm on ad.PakageId=fm.FacilityId
join memberPlanDetails mpd on a.AppointmentId=mpd.AppointmentId
join corporateplan cp on cp.CorporatePlanId=mpd.CorporatePlanId
join userlogin u on u.userloginid=a.UserLoginId
join Member m on a.MemberId=m.MemberId
join client c on a.clientId=c.clientId
join StatusMaster st on a.ScheduleStatus=st.StatusId
where a.userloginid=@UserLoginId 

UNION ALL 

select distinct a.AppointmentId,a.CreatedDate,a.caseNo,a.UserLoginid,a.MemberId,m.FirstName,m.LastName,m.Relation,m.MobileNo,m.emailid,UP.CNPlanDetailsId,cp.Planname,
fm.FacilityName,
a.ScheduleStatus,st.statusName
from Appointment a join AppointmentDetails ad on a.AppointmentId=ad.AppointmentId
join FacilitiesMaster fm on ad.PakageId=fm.FacilityId
join UserPlanDetails UP on a.UserPlanDetailsId=UP.UserPlanDetailsId
join CNPlanDetails cp on cp.CNPlanDetailsId=UP.CNPlanDetailsId
join userlogin u on u.userloginid=a.UserLoginId
join Member m on a.MemberId=m.MemberId
join client c on a.clientId=c.clientId
join StatusMaster st on a.ScheduleStatus=st.StatusId
where a.userloginid=@UserLoginId; 


SELECT TOP 10 * FROM #Temporary ORDER BY [CreatedDate] DESC
end