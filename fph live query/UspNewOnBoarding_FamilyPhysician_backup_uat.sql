USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspNewOnBoarding_FamilyPhysician]    Script Date: 2/12/2024 3:47:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 -- UspNewOnBoarding_FamilyPhysician null,null, null, null,null, null ,1,10 ,null,null,null,null        
 -- UspNewOnBoarding_FamilyPhysician null,null, null, null,'demo4april2023harsh@gmail.com', null ,1,10 ,null,null,null,null       
 -- UspNewOnBoarding_FamilyPhysician null,null, null, '9146480293',null, null ,1,10 ,null,null,null,null       
 -- UspNewOnBoarding_FamilyPhysician null,null,'ram', null,null, null ,1,10 ,null,null,null,null     
 -- UspNewOnBoarding_FamilyPhysician null,null,'sita', null,null, null ,1,10 ,null,null,null,null      
 -- UspNewOnBoarding_FamilyPhysician 1898,null, null, null,null, null ,1,10 ,null,null,null,null   
 -- UspNewOnBoarding_FamilyPhysician null,440, null, null,null, null ,1,10 ,null,null,null,null   


 -- UspNewOnBoarding_FamilyPhysician null,null, 'Ram', null,null, null ,1,10 ,null,null,null,null   
              
ALTER  PROCEDURE [dbo].[UspNewOnBoarding_FamilyPhysician]                  
                            
 @Plan varchar(100)                                        
,@ClientId varchar(100)                                      
,@name varchar(100)                                        
,@phone varchar(100)                                        
,@email varchar(100)                                        
,@DaysofActived INT = 2                                        
,@pageNumber int=1  --page Number                                    
,@recordPerPage int=50                                    
,@fromDate datetime =null                                    
,@toDate datetime =null                                    
,@buType varchar(100) = null                                      
--,@flag varchar(100) = null                                
,@CallerName varchar(100)=null                                 
AS                                        
BEGIN                                       
Declare @totalRows int,@DisplayFromDate datetime,@DisplayToDate datetime       
      
                                    
select @pageNumber =isnull(@pageNumber,1),
@recordPerPage =isnull(@recordPerPage,50),
@fromDate =isnull(@fromDate,Getdate()-7),
@toDate =isnull(@toDate,Getdate()),
@DisplayFromDate = isnull(GETDATE()-7,@DisplayFromDate),
@DisplayToDate=isnull(Getdate(),@DisplayToDate)                                 
                                                                  
                                  
  IF(@DaysofActived = 0 OR @DaysofActived is Null)                                          
   Begin                                           
   set @DaysofActived = 1                                          
   end                                          
   
   SET NOCOUNT ON                                                              
                                                              
/****************************Start DECLARE VARIABLES*********************************/                                                              
   Declare @UserId bigint,@Userloginidbookfor varchar(50),@SubCode INT=200,@Status BIT=1,@Message VARCHAR(MAX)='Successful',@CurrentDateTime DATETIME=GETDATE(),@StatusID VARCHAR(100),@myoffset int=0                                                         
                                                     
    select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50)                                                      
                                                     
  set @myoffset=((@recordPerPage * @pageNumber) - @recordPerPage ) + 0;                  
  print @myoffset 
/****************************End DECLARE VARIABLES*********************************/
/***************************Start Declare Table**************************************************************/     
                                                         
 Create table #Temporary (
 UserLoginId varchar(100),CorporatePlanId varchar(100),PlanName varchar(100),ClientId varchar(100),ClientName varchar(100),
 FirstName varchar(100),LastName varchar(100),
 MobileNo varchar(10),EmailId varchar(100),UserCreatedDate datetime,PlanExpiryDate datetime,                            
 PlanCode varchar(100),MemberPlanId varchar(100),MemberId varchar(100),CallerName varchar(100),
 callStatus varchar(100),callResponce varchar(100),                
 lastContactDate datetime,requestedCallingDate datetime,Remarks  varchar(100),UserName varchar(100)
 )


 /***************************Table created successfully**************************************************************/ 
                                  
insert into #Temporary (
 UserLoginId,CorporatePlanId,PlanName,ClientId,ClientName,FirstName,LastName,
 MobileNo,EmailId,UserCreatedDate,PlanExpiryDate,                            
 PlanCode,MemberPlanId,MemberId,CallerName,
 callStatus,callResponce,                
lastContactDate,requestedCallingDate,Remarks,UserName
 )                                  
select u.UserLoginId,cp.CorporatePlanId,cp.PlanName,c.ClientId,c.ClientName,u.FirstName,u.LastName,m.MobileNo,m.EmailId,
u.CreatedDate as UserCreatedDate,mp.ToDate as PlanExpiryDate,                            
isnull(cp.PlanCode,'') as PlanCode,mp.MemberPlanId,m.MemberId,IsNull(mcd.UpdatedBy,mcd.CreatedBy) as CallerName,IsNull(cs.[CallStatus],'') as callStatus,--fm.FacilityId,                            
IsNull(cs.[SubCallStatus],'') as callResponce,Isnull(mcd.UpdatedDate,mcd.CreatedDate) as [lastContactDate],

mcd.NextCallDate as requestedCallingDate,


 '' as Remarks,u.UserName--,@DisplayFromDate as DisplayFromDate,@DisplayToDate as DisplayToDate        -------------Table 1   

                                 
from UserLogin u                                        
inner join Member m                                        
on u.UserLoginId=m.UserLoginId                                        
inner join MemberPlan mp                                        
on m.MemberId=mp.MemberId                           
inner join CorporatePlan cp                                        
on mp.CorporatePlanId=cp.CorporatePlanId                                        
inner join client c                                        
on u.clientId=c.clientId                             
              
left join MemberCallDetails mcd                            
on u.UserLoginId=mcd.UserLoginId                            
and mcd.OpsMenuName='NewOnBoarding'                 
and mcd.MemCallId = (select max(MemCallId) from MemberCallDetails where OpsMenuName='NewOnBoarding' and UserLoginId=u.UserLoginId)                                          
left Join callStatus cs on                             
mcd.StatusId = cs.CallStatusId                               
                            
where m.Relation='SELF'  
and mp.CorporatePlanId in (select distinct corporateplanid from corporateplandetails where facilityid in (1419))                                
                                      
and (@name is null OR (u.FirstName +' '+u.LastName) like '%'+@name+'%')                                                   
and (@phone is null OR m.MobileNo like '%'+@phone+'%')                                        
and (@email is null OR m.EmailId like '%'+@email+'%')                                        
and (@buType is null OR c.BUType like '%'+@buType+'%')                                        
and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                            
and (@FromDate is null and @ToDate is null OR cast (u.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                                             
and (@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')))                              
and (@CallerName is null OR IsNull(mcd.UpdatedBy,mcd.CreatedBy) = @CallerName)                                       
group by u.UserLoginId,cp.CorporatePlanId,cp.PlanName,c.ClientId,c.ClientName,u.FirstName,u.LastName,m.MobileNo,m.EmailId,u.CreatedDate,mp.ToDate,                            
cp.PlanCode,mp.MemberPlanId,m.MemberId,IsNull(mcd.UpdatedBy,mcd.CreatedBy),cs.[CallStatus],cs.[SubCallStatus],Isnull(mcd.UpdatedDate,mcd.CreatedDate),mcd.NextCallDate,u.UserName                                     
order by u.CreatedDate desc                                   
  
                                  
                                    
select @totalRows = COUNT(*) OVER()                                    
from UserLogin u                                        
inner join Member m                                        
on u.UserLoginId=m.UserLoginId                                        
inner join MemberPlan mp                        
on m.MemberId=mp.MemberId               
             
inner join CorporatePlan cp                                        
on mp.CorporatePlanId=cp.CorporatePlanId                                        
inner join client c                                        
on u.clientId=c.clientId                              
                            
left join MemberCallDetails mcd                            
on u.UserLoginId=mcd.UserLoginId                            
and mcd.OpsMenuName='NewOnBoarding'                  
and mcd.MemCallId = (select max(MemCallId) from MemberCallDetails where OpsMenuName='NewOnBoarding' and UserLoginId=u.UserLoginId)                                          
left Join callStatus cs on                             
mcd.StatusId = cs.CallStatusId                            
                            
where m.Relation='SELF' and (c.ClientName not like '%demo%')  
and mp.CorporatePlanId in (select distinct corporateplanid from corporateplandetails where facilityid in (1419))                                                
and (@name is null OR (u.FirstName +' '+u.LastName) like '%'+@name+'%')                                        
and (@phone is null OR m.MobileNo like '%'+@phone+'%')                                        
and (@email is null OR m.EmailId like '%'+@email+'%')                                
and (@buType is null OR c.BUType like '%'+@buType+'%')                                        
and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                               
and (@FromDate is null and @ToDate is null OR cast (u.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))                          
and (@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')))                            
and (@CallerName is null OR IsNull(mcd.UpdatedBy,mcd.CreatedBy) = @CallerName)                            
group by u.UserLoginId,cp.CorporatePlanId,cp.PlanName,c.ClientId,c.ClientName,u.FirstName,u.LastName,m.MobileNo,m.EmailId,u.CreatedDate ,mp.ToDate,cp.PlanCode,                            
mp.MemberPlanId,m.MemberId,IsNull(mcd.UpdatedBy,mcd.CreatedBy),cs.[CallStatus],cs.[SubCallStatus],Isnull(mcd.UpdatedDate,mcd.CreatedDate),mcd.NextCallDate,u.UserName                                       
order by u.CreatedDate desc                                     
 
  /*****************Select All table*************************************************/                                                                  
                                                                     
   select   distinct * from #Temporary                     
   ORDER BY UserLoginId DESC                                                                
   offset @myoffset rows                                                                                    
   FETCH NEXT @RecordPerPage rows only  
   
   --select @totalRows As totalCount,@DisplayFromDate as DisplayFromDate,@DisplayToDate as DisplayToDate   
   
   select count( DISTINCT MemberId) as 'totalCount',@DisplayFromDate as DisplayFromDate,@DisplayToDate as DisplayToDate   from #Temporary  tmp                                                                  
                                                                                                                                                 
   SELECT @Status AS [Status],@SubCode AS SubCode,@Message AS [Message]                                                  
                                                                     
                                                                     
/*****************End Select All Table********************************************/                                      
                                
                                    
                                    
END     