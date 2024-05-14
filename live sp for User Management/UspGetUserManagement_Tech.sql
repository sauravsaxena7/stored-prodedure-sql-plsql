USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspGetUserManagement_Tech]    Script Date: 2/1/2024 4:15:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
	
	--SELECT TOP 10 ClientHrName FROM UserLogin;
-- exec[UspGetUserManagement_Tech_saurav]   null,null,null,null,null,null,1,10,null,null,null,null   
-- exec [UspGetUserManagement_Tech] null,null,null,null,null,null,1,10,null,null,null  ,null,'HAOPD-47260' 
-- exec [UspGetUserManagement_Tech] null,null,null,null,null,null,1,10,null,null,null  ,null,'38643542'
-- exec [UspGetUserManagement_Tech] null,null,null,'8434685607',null,null,1,10,null,null,null,null ,null 
-- exec [UspGetUserManagement_Tech] null,null,null,null,'uatuser02@mailinator.com',null,1,10,null,null,null,null ,null 
-- exec [UspGetUserManagement_Tech] null,null,null,'9449054816',null,null,1,10,null,null,null,null ,null 
--exec [UspGetUserManagement_Tech] null,null,null,'5550589465',null,null,1,10,null,null,null,null ,null 
--exec [UspGetUserManagement_Tech] null,null,null,'9538384558',null,null,1,10,null,null,null,null ,null ,null
                                      
ALTER PROCEDURE [dbo].[UspGetUserManagement_Tech]   
                             
 @Plan varchar(100)                                    
,@ClientId varchar(100)                                        
,@name varchar(100)                                    
,@phone varchar(100)                                    
,@email varchar(100)                                    
,@DaysofActived INT = 2                                    
,@pageNumber int=1  --page Number                                
,@recordPerPage int=10                                
,@fromDate datetime =null                                
,@toDate datetime =null                                
,@buType varchar(100) = null                                    
,@flag varchar(100) = null  --csv
,@MemberID varchar(100) = null
,@EmpNo varchar(100)=null   ---added by sayali for HAP-2121 ON 21-SEP-2023 
,@PolicyNo VARCHAR(100)=NULL



AS                                    
BEGIN                                   
Declare @totalRows int ,@DisplayFromDate datetime,@DisplayToDate datetime   
select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50),@DisplayFromDate = isnull(GETDATE(),@DisplayFromDate),@DisplayToDate=isnull(Getdate(),@DisplayToDate);

 Create table #Temporary(UserLoginId BIGINT,UserName VARCHAR(100),CorporatePlanId BIGINT,
 PlanName VARCHAR(100),ClientId BIGINT,ClientName VARCHAR(100),FirstName VARCHAR(100),LastName VARCHAR(100),
 MobileNo VARCHAR(20),EmailId VARCHAR(100),UserCreatedDate DATETIME,PlanExpiryDate DATETIME,PlanCode VARCHAR(100),
 MemberPlanId BIGINT,MemberId BIGINT,PlanType VARCHAR(100),
 planAmount VARCHAR(50),ClientHrName VARCHAR(100),ClientHrEmailId VARCHAR(100),EmpNo VARCHAR(100),PolicyNo VARCHAR(100),Status VARCHAR(10) , PolicyStatus VARCHAR(5),IsWithNewPlan VARCHAR(1));

                             
   IF(@DaysofActived = 0 OR @DaysofActived is Null)                                      
   Begin                                       
       set @DaysofActived = 1                                      
    end 
    IF  @Plan=0 
    BEGIN
	SET @Plan=null
	END 
	IF  @ClientId=0 
    BEGIN
	SET @ClientId=null
	END                                                                  


INSERT INTO #Temporary 
select distinct u.UserLoginId,
u.UserName,
cp.CorporatePlanId,
cp.PlanName,
c.ClientId,
c.ClientName,
u.FirstName,
u.LastName,
m.MobileNo,
m.EmailId,
IsNull(u.CreatedDate,'') as UserCreatedDate,
IsNull(mp.ToDate,'') as PlanExpiryDate,             
isnull(cp.PlanCode,'') as PlanCode,
mp.MemberPlanId,
m.MemberId,
cp.PlanType,
mp.planAmount,
u.ClientHrName,
u.ClientHrEmailId,
u.EmpNo,L.PolicyNo
,CASE WHEN(u.Status = 'A') THEN 'Active'
      WHEN(u.Status = 'I') THEN 'Inactive'
	  WHEN(u.Status = 'L') THEN 'Locked'
	  WHEN(u.Status = 'T') THEN 'Temporary'
	  WHEN(u.Status = 'V') THEN 'Verified'
	  ELSE 'Inactive'
      END as Status ,-------------Table 1   
 mp.IsActive,'N'
from UserLogin u                                    
inner join Member m on u.UserLoginId=m.UserLoginId                                    
inner join MemberPlan mp on m.MemberId=mp.MemberId                                                
inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId                                    
inner join client c on cp.clientId=c.clientId 
left join LibertyEmpRegistration L on L.MemberPlanId = mp.MemberPlanId
where m.Relation='SELF'
and ((@MemberID IS NULL) OR (L.MemberID=@MemberID))

and (@name is null OR u.FirstName like '%'+@name+'%' OR u.LastName like '%'+@name+'%')                                    
and (@phone is null OR m.MobileNo like '%'+@phone+'%')                                    
and (@email is null OR m.EmailId like '%'+@email+'%')                                    
and (@buType is null OR c.BUType like '%'+@buType+'%')                                      
and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                             
and (@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')) )   
and (@EmpNo is null OR u.EmpNo =@EmpNo)
and (@PolicyNo IS NULL OR L.PolicyNo=@PolicyNo)

UNION ALL

select distinct u.UserLoginId,
u.UserName,
cp.CNPlanDetailsId,
cp.PlanName,
c.ClientId,
c.ClientName,
u.FirstName,
u.LastName,
m.MobileNo,
m.EmailId,
IsNull(u.CreatedDate,'') as UserCreatedDate,
IsNull(mp.ToDate,'') as PlanExpiryDate,             
isnull(cp.PlanCode,'') as PlanCode,
mp.UserPlanDetailsId,
m.MemberId,
NULL,
mp.planAmount,
u.ClientHrName,
u.ClientHrEmailId,
u.EmpNo,L.PolicyNo
,CASE WHEN(u.Status = 'A') THEN 'Active'
      WHEN(u.Status = 'I') THEN 'Inactive'
	  WHEN(u.Status = 'L') THEN 'Locked'
	  WHEN(u.Status = 'T') THEN 'Temporary'
	  WHEN(u.Status = 'V') THEN 'Verified'
	  ELSE 'Inactive'
      END as Status ,-------------Table 1   
 mp.ActiveStatus As PolicyStatus,'Y'
from UserLogin u                                    
inner join Member m on u.UserLoginId=m.UserLoginId                                    
--inner join MemberPlan mp on m.MemberId=mp.MemberId                                                
--inner join CorporatePlan cp on mp.CorporatePlanId=cp.CorporatePlanId 
inner join UserPlanDetails mp on mp.memberId =m.memberId
inner join CNPlanDetails cp on cp.CNPlanDetailsId=mp.CNPlanDetailsId
inner join client c on cp.clientId=c.clientId 
left join LibertyEmpRegistration L on L.UserPlanDetailsId = mp.UserPlanDetailsId

where m.Relation='SELF'
and ((@MemberID IS NULL) OR (L.MemberID=@MemberID))

and (@name is null OR u.FirstName like '%'+@name+'%' OR u.LastName like '%'+@name+'%')                                    
and (@phone is null OR m.MobileNo like '%'+@phone+'%')                                    
and (@email is null OR m.EmailId like '%'+@email+'%')                                    
and (@buType is null OR c.BUType like '%'+@buType+'%')                                      
and (@ClientId is null OR c.clientId  in(select * from SplitString(@ClientId,',')))                                                             
and (@Plan is null OR cp.CNPlanDetailsId in(select * from SplitString(@Plan,',')) )   
and (@EmpNo is null OR u.EmpNo =@EmpNo)
and (@PolicyNo IS NULL OR L.PolicyNo=@PolicyNo)


select @totalRows = COUNT(1) from #Temporary

SELECT *  FROM #Temporary order by UserCreatedDate offset @RecordPerPage * (@PageNumber-1)rows                                
FETCH NEXT @RecordPerPage rows only

select @totalRows As totalCount,@DisplayFromDate as DisplayFromDate,@DisplayToDate as DisplayToDate






END