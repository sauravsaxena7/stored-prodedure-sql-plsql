USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspLastTransctionHistory]    Script Date: 1/6/2024 10:35:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[uspLastTransctionHistory]       
      
@UserLoginId varchar(50)  
AS  
begin  
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
where a.userloginid=@UserLoginId ORDER BY [CreatedDate] DESC  
  
end