USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspGetAllCallDetailsHistory_TeleHealthCoach]    Script Date: 1/11/2024 6:14:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext UspGetAllCallDetailsHistory_TeleHealthCoach 'HA11012024BACCJA','HealthCoach'
ALTER PROCEDURE [dbo].[UspGetAllCallDetailsHistory_TeleHealthCoach]  
@CaseNo varchar(200),  
@OpsMenuName varchar(200)  
AS          
Begin          
     Declare @Appointmentid bigint;        
     set @Appointmentid = (select AppointmentId from Appointment where CaseNo=@CaseNo)
	 DECLARE @UserPlanDetailsId BIGINT=(select UserPlanDetailsId from Appointment where CaseNo=@CaseNo);

	 if @UserPlanDetailsId IS NULL
	  BEGIN
	     SELECT         
       MD.[userLoginId]          
      ,cp.[planName]          
      ,Isnull(N.UpdatedDate,N.CreatedDate) as [lastContacted]          
      ,Isnull(N.Remark,'') as Remarks        
      ,IsNull(N.UpdatedBy,N.CreatedBy) as CallerName          
      ,IsNull(cs.[CallStatus],'') as callStatus          
      ,IsNull(cs.[SubCallStatus],'') as callResponce        
      ,IsNull(MD.OpsMenuName,'') as OpsMenuName      
   ,N.NextCallDate as requestedCallingDate        
  FROM MemberCallLog N          
  Left join MemberCallDetails MD on MD.MemCallId=N.MemCallId        
  Left Join callStatus cs on N.CallStatusId = cs.CallStatusId         
  left join MemberPlan mp  on MD.MemberId=mp.MemberId                    
  left join CorporatePlan cp  on mp.CorporatePlanId=cp.CorporatePlanId        
  Where MD.AppointmentId = @Appointmentid and IsNull(MD.OpsMenuName,'')=@OpsMenuName  
END
ELSE 
BEGIN

  
  SELECT         
       MD.[userLoginId]          
      ,cp.[planName]
	  ,Ap.Appointmentid
	  ,Up.UserPlanDetailsId
      ,Isnull(N.UpdatedDate,N.CreatedDate) as [lastContacted]          
      ,Isnull(N.Remark,'') as Remarks        
      ,IsNull(N.UpdatedBy,N.CreatedBy) as CallerName          
      ,IsNull(cs.[CallStatus],'') as callStatus          
      ,IsNull(cs.[SubCallStatus],'') as callResponce        
      ,IsNull(MD.OpsMenuName,'') as OpsMenuName      
   ,N.NextCallDate as requestedCallingDate        
  FROM MemberCallLog N          
 left join MemberCallDetails MD on MD.MemCallId=N.MemCallId        
   left Join callStatus cs on N.CallStatusId = cs.CallStatusId         
   join Appointment ap  on MD.AppointmentId=ap.AppointmentId
   inner join UserPlanDetails Up on  Up.UserPlanDetailsId=ap.UserPlanDetailsId
  inner join CNPlanDetails cp  on Cp.CNPlanDetailsId=Up.CNPlanDetailsId        
  Where MD.AppointmentId = @Appointmentid and IsNull(MD.OpsMenuName,'')=@OpsMenuName 
END

  
End 