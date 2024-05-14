USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspGetCallHistory]    Script Date: 1/3/2024 11:30:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER procedure [dbo].[uspGetCallHistory]    
@UserLoginId varchar(100)=null,    
--@MemberId varchar(100)=null,    
@fromdate datetime=null,    
@todate datetime=null    
as    
begin    
  
if(@fromdate is null and @todate is null)    
begin    
  select  MD.UserLoginId,MD.MemberId,M.EmailId,M.FirstName,M.LastName,CP.PlanName,C.ClientName,CS.CallStatus,CS.SubCallStatus,ML.CreatedBy,MP.FromDate,ML.CreatedDate as LogDate,  
  CASE                      
    WHEN DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)>0 THEN Convert(varchar,DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)<=-1 THEN Convert(varchar,DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate) between 1 and 24 THEN Convert(varchar,DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate)) +' HOUR'         
    WHEN DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate) between -1 and -24 THEN Convert(varchar,DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate)) +' HOUR'         
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) between 0 and 59 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) between -1 and -60 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) = 0 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
END as CallingDurationTAT  
    
  ,ML.CreatedDate ,ML.Remark,MD.OpsMenuName,LE.PolicyNo    
 from [MemberCallDetails] MD    
 join [MemberCallLog] ML on ML.MemCallId=MD.MemCallId     
 join Member M on M.MemberId = MD.MemberId    
 join UserLogin UL on UL.UserLoginId=MD.UserLoginId    
 join client C on C.ClientId=UL.ClientId    
 join Memberplan MP on MP.MemberPlanId=md.MemberPlanId    
 join CorporatePlan CP on CP.CorporatePlanId=mp.CorporatePlanId    
 join CallStatus CS on CS.CallStatusId=ML.CallStatusId  --and cs.CallStatusId=md.StatusId  
 left join LibertyEmpRegistration LE on LE.UserLoginId=MD.UserLoginId 
 where @UserLoginId is null OR MD.UserLoginId =@UserLoginId order by 1 desc--and @MemberId is null OR MD.MemberId =@MemberId    
 --MD.UserLoginId=@UseroginId and MD.MemberId=@MemberId--739837 --745065  --@UseroginId--734840--576840    
 end    
    
 else    
    
 begin    
 select MD.UserLoginId,MD.MemberId,M.EmailId,M.FirstName,M.LastName,CP.PlanName,C.ClientName,CS.CallStatus,CS.SubCallStatus,ML.CreatedBy,MP.FromDate,ML.CreatedDate as LogDate,  
  CASE                      
    WHEN DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)>0 THEN Convert(varchar,DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)<=-1 THEN Convert(varchar,DATEDIFF(DAY,MP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate) between 1 and 24 THEN Convert(varchar,DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate)) +' HOUR'         
    WHEN DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate) between -1 and -24 THEN Convert(varchar,DATEDIFF(HOUR,MP.FromDate,ML.CreatedDate)) +' HOUR'         
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) between 0 and 59 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) between -1 and -60 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate) = 0 THEN Convert(varchar,DATEDIFF(MINUTE,MP.FromDate,ML.CreatedDate)) +' Min'                      
END as CallingDurationTAT    
  ,ML.CreatedDate ,ML.Remark,MD.OpsMenuName,LE.PolicyNo       
 from [MemberCallDetails] MD    
 join [MemberCallLog] ML on ML.MemCallId=MD.MemCallId     
 join Member M on M.MemberId = MD.MemberId    
 join UserLogin UL on UL.UserLoginId=MD.UserLoginId    
 join client C on C.ClientId=UL.ClientId    
 join Memberplan MP on MP.MemberPlanId=md.MemberPlanId    
 join CorporatePlan CP on CP.CorporatePlanId=mp.CorporatePlanId    
 join CallStatus CS on CS.CallStatusId=ML.CallStatusId  --and cs.CallStatusId=md.StatusId 
 left join LibertyEmpRegistration LE on LE.UserLoginId=MD.UserLoginId
 where  @fromdate is null and @todate is null OR cast (ML.CreatedDate as date )Between  cast (@fromdate as date ) and cast (@todate as date )  order by 1 desc  
 end    
    
 end