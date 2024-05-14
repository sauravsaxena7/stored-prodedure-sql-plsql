USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspGetCallHistory]    Script Date: 1/3/2024 12:07:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ---ALTER TABLE MemberCallDetails ADD  UserPlanDetailsId BIGINT
 ---EXEC [dbo].[uspGetCallHistory]    '534805',NULL,NULL
ALTER procedure [dbo].[uspGetCallHistory]    
@UserLoginId varchar(100)=null,    
--@MemberId varchar(100)=null,    
@fromdate datetime=null,    
@todate datetime=null    
as    
begin    
   Create table #Temporary(UserLoginId BIGINT,MemberId BIGINT ,EmailId VARCHAR(200),
   FirstName VARCHAR(50), LastName VARCHAR(50) ,PlanName VARCHAR(50),
   ClientName VARCHAR(50),CallStatus VARCHAR(50),SubCallStatus VARCHAR(50),
   CreatedBy VARCHAR(50),FromDate DATETIME,LogDate DATETIME, CallingDurationTAT VARCHAR(100),
   CreatedDate DATETIME ,Remark VARCHAR(300),OpsMenuName VARCHAR(50) ,PolicyNo   VARCHAR(50))

   INSERT INTO #Temporary select DISTINCT MD.UserLoginId,MD.MemberId,M.EmailId,M.FirstName,M.LastName,CP.PlanName,C.ClientName,CS.CallStatus,CS.SubCallStatus,ML.CreatedBy,MP.FromDate,ML.CreatedDate as LogDate,  
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
 where MD.UserLoginId=@UserLoginId and (( @fromdate is null OR @todate is null)
 OR (cast (ML.CreatedDate as date )  Between  cast (@fromdate as date ) and cast (@todate as date )))

 UNION ALL

 select DISTINCT MD.UserLoginId,MD.MemberId,M.EmailId,M.FirstName,M.LastName,CP.PlanName,C.ClientName,CS.CallStatus,CS.SubCallStatus,ML.CreatedBy,UP.FromDate,ML.CreatedDate as LogDate,  
  CASE                      
    WHEN DATEDIFF(DAY,UP.FromDate,ML.CreatedDate)>0 THEN Convert(varchar,DATEDIFF(DAY,UP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(DAY,UP.FromDate,ML.CreatedDate)<=-1 THEN Convert(varchar,DATEDIFF(DAY,UP.FromDate,ML.CreatedDate)) +' Days'                      
    WHEN DATEDIFF(HOUR,UP.FromDate,ML.CreatedDate) between 1 and 24 THEN Convert(varchar,DATEDIFF(HOUR,UP.FromDate,ML.CreatedDate)) +' HOUR'         
    WHEN DATEDIFF(HOUR,UP.FromDate,ML.CreatedDate) between -1 and -24 THEN Convert(varchar,DATEDIFF(HOUR,UP.FromDate,ML.CreatedDate)) +' HOUR'         
 WHEN DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate) between 0 and 59 THEN Convert(varchar,DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate) between -1 and -60 THEN Convert(varchar,DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate)) +' Min'                      
 WHEN DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate) = 0 THEN Convert(varchar,DATEDIFF(MINUTE,UP.FromDate,ML.CreatedDate)) +' Min'                      
END as CallingDurationTAT    
  ,ML.CreatedDate ,ML.Remark,MD.OpsMenuName,LE.PolicyNo       
 from [MemberCallDetails] MD    
 join [MemberCallLog] ML on ML.MemCallId=MD.MemCallId     
 join Member M on M.MemberId = MD.MemberId       
 join UserLogin UL on UL.UserLoginId=MD.UserLoginId    
 join client C on C.ClientId=UL.ClientId    
 join UserPlanDetails UP on UP.UserPlanDetailsId=md.UserPlanDetailsId    
 join CNPlanDetails  CP on CP.CNPlanDetailsId=UP.CNPlanDetailsId    
 join CallStatus CS on CS.CallStatusId=ML.CallStatusId  --and cs.CallStatusId=md.StatusId 
 left join LibertyEmpRegistration LE on LE.UserLoginId=MD.UserLoginId
 where MD.UserLoginId=@UserLoginId and (( @fromdate is null OR @todate is null)
 OR (cast (ML.CreatedDate as date )  Between  cast (@fromdate as date ) and cast (@todate as date )))



SELECT * FROM #Temporary ORDER BY 1 DESC;

DROP TABLE #Temporary;
    
 end