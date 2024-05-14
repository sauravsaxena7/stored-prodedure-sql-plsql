USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[USPGETSinglePlanData_ops]    Script Date: 2/6/2024 11:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec USPGETSinglePlanData_ops null, null, null, null, null, null, null, 1,500
--exec USPGETSinglePlanData_ops null, null, null, "honurappahy@gmail.com", null, null, null, 1, 100
--exec USPGETSinglePlanData_ops "2023-03-21","2023-03-21",null, null, null, null, null, 1, 500
--exec USPGETSinglePlanData_ops  null, null, null, null, '9992652864', null, null, 1, 10   
--exec USPGETSinglePlanData_ops  null, null,'V GKrishnakumar', null, null, null, null, 1, 10 
--exec USPGETSinglePlanData_ops  null, null,null, null, null, null, 1975, 1, 100
--exec USPGETSinglePlanData_ops  null, null,null, null, null, null, 1426, 1, 100
--exec USPGETSinglePlanData_ops  null, null,null, null, null, null, null, 1, 10,null,null,null,null

ALTER PROCEDURE [dbo].[USPGETSinglePlanData_ops] 
(
 @Fromdate datetime = null, 
 @Todate datetime=null,
 @customername varchar(100)=null, 
 @customeremail varchar(100)=null, 
 @customermobile varchar(10)=null,
 @ClientId varchar(100)=null,    
 @Plan varchar(100)=null,      
 @pageNumber int=1,  
 @recordPerPage int=50,
 @Status VARCHAR(100)=NULL,--Success,Requested,Cancelled
 @PartnerId VARCHAR(100)=NULL,
 @Flag VARCHAR(10)=NULL,
 @PolicyNo VARCHAR(150)=NULL
 )

AS                                                    
BEGIN                                                    
                                                    
 Declare @totalCount int,@DisplayFromDate datetime,@DisplayToDate datetime   
 select @pageNumber =isnull(@pageNumber,1),@recordPerPage =isnull(@recordPerPage,50),

 @DisplayFromDate = isnull(GETDATE()-2,@DisplayFromDate),
 @DisplayToDate=isnull(Getdate(),@DisplayToDate)

 if @FromDate is null or @ToDate is Null
   BEGIN
      SET @FromDate =@DisplayFromDate;
	  SET @ToDate = @DisplayToDate;
   END
 
 print @ClientId

 print 'policy'
print @PolicyNo

print '@FromDate'
print CAST(@FromDate AS DATE)
PRINT CAST(@ToDate As Date)


 
CREATE TABLE #TEMP(policyno varchar(550),PolicyStartDate datetime,Customername varchar(500),Customeremail varchar(500),customermobile varchar(500),userloginid bigint,clientId BIGINT, clientname VARCHAR(100),PrimaryPolicyHolderName VARCHAR(550), memberplanid BIGINT,corporateplanid BIGINT,planname VARCHAR(500) ,PlanStartDate DATETIME,PlanExpiryDate DATETIME ,PlanStatusFlag VARCHAR(500),PlanCancelRemark VARCHAR(550),ApplicationNumber VARCHAR(500),PlanCode VARCHAR(500),TotalAmount VARCHAR(500),ProposalCreatedDate DATETIME,Status VARCHAR(500),LastUpdatedDate DATETIME,Elite_partners_ID VARCHAR(500),Elite_partners_Name VARCHAR(500),PolicyUpdatedDate DATETIME,IsWithNewPlan VARCHAR(10))


 
 print @ClientId
  
    INSERT INTO	#TEMP	                 
          select 
			   opd.PolicyNo,opd.CreatedDate,opd.Name,opd.Email,opd.Mobile,ISNULL(l.userloginid,-1),
			   c.clientId,c.clientname,opd.Name,
			   ISNULL(mp.MemberPlanId,-1),
			   cp.corporateplanid, cp.planname,
			   cp.fromdate,cp.ToDate,
			   ISNULL(mp.Isactive,'N'),ISNULL(mp.PlanCancelRemark,''),
			   opd.TransactionId,opd.PlanCode,opd.TotalAmount,opd.CreatedDate ,
			   opd.Status,opd.UpdatedDate,Isnull(op.PartnerCode,''),Isnull(op.PartnerName,''),mp.UpdatedDate,'N'
               from OPDPAYMENTDETAILS opd
             
			  left join LibertyEmpRegistration   L on CAST(opd.PolicyNo AS varchar(500))=CAST(l.PolicyNo AS varchar(500))
			  left  join MemberPlan mp on l.MemberPlanId=mp.MemberPlanId
              join corporateplan cp on cp.PlanCode=opd.PlanCode
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(150))=CAST(op.OPDPartnerDetailsId AS VARCHAR(150))
              join client c on c.clientId=cp.ClientId
              where 
			  (@ClientId is null OR c.clientId in (select * from SplitString(@ClientId,',')))    and   
			  (@customeremail is null OR opd.Email  like '%'+@customeremail+'%')   and 

			  CASE WHEN ((@Status is null or @Status='Requested' or @Status ='Success') 
			           and (@Status is null OR  opd.Status  like '%'+@Status+'%') ) then 1
					   WHEN (@Status='Cancelled' AND MP.IsActive='N' ) then 1
					   else  0
			  end=1
			  and 
			  (@PartnerId is null OR op.OPDPartnerDetailsId in (select * from SplitString(@PartnerId,','))) and
			  
			   (@PolicyNo is null OR  opd.PolicyNo  like '%'+@PolicyNo+'%') and 
			  (@customermobile is null OR opd.Mobile  like '%'+@customermobile+'%') and 
			  (@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')))  and 
			  (@customername is null OR opd.Name like '%'+@customername+'%')  and
			  (@FromDate is null and @ToDate is null OR cast (opd.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) 
			  --and

			  --l.UserLoginId in (

     --         select distinct(UserLoginId)
     --         from LibertyEmpRegistration   where memberplanid is not null
     --          group by UserLoginId 
     --         having count(customeremail)=1  
			  --) 

			  UNION

			    select 
			   opd.PolicyNo,opd.CreatedDate,opd.Name,opd.Email,opd.Mobile,ISNULL(l.userloginid,-1),
			   c.clientId,c.clientname,opd.Name,
			   ISNULL(mp.UserPlanDetailsId,-1),
			   cp.CNPlanDetailsId, cp.planname,
			   cp.fromdate,cp.ToDate,
			   ISNULL(mp.ActiveStatus,'N'),ISNULL(mp.PlanCancelRemark,''),
			   opd.TransactionId,opd.PlanCode,opd.TotalAmount,opd.CreatedDate ,
			   opd.Status,opd.UpdatedDate,Isnull(op.PartnerCode,''),Isnull(op.PartnerName,''),mp.UpdatedDate,'Y'
               from OPDPAYMENTDETAILS   opd 
			  left join LibertyEmpRegistration   l on CAST(opd.PolicyNo AS varchar(500))=CAST(l.PolicyNo AS varchar(500))
			   left join UserPlanDetails mp on l.UserPlanDetailsId=mp.UserPlanDetailsId
              join CNPlanDetails cp on cp.CNPlanDetailsId=opd.CNPlanDetailsId 
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(550))=CAST(op.OPDPartnerDetailsId AS VARCHAR(550))
              join client c on c.clientId=cp.ClientId
              where 
			  (@ClientId is null OR c.clientId in (select * from SplitString(@ClientId,',')))    and   
			  (@customeremail is null OR opd.Email  like '%'+@customeremail+'%')   and 
			  (@customermobile is null OR  opd.Mobile  like '%'+@customermobile+'%') and 
			  CASE WHEN ((@Status is null or @Status='Requested' or @Status ='Success') 
			           and (@Status is null OR  opd.Status  like '%'+@Status+'%') ) then 1
					   WHEN (@Status='Cancelled' AND MP.ActiveStatus='N' ) then 1
					   else  0
			  end=1 and
			  --(@Status is null OR  opd.Status  like '%'+@Status+'%') and 
			  (@PartnerId is null OR op.OPDPartnerDetailsId in (select * from SplitString(@PartnerId,','))) and
			  (@PolicyNo is null OR  opd.PolicyNo  like '%'+@PolicyNo+'%') and 
			  (@Plan is null OR cp.CNPlanDetailsId in(select * from SplitString(@Plan,',')))  and 
			  (@customername is null OR opd.Name like '%'+@customername+'%')  and
			  (@FromDate is null and @ToDate is null OR cast (opd.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))  --and

			  --l.UserLoginId in (

     --         select distinct(UserLoginId)
     --         from LibertyEmpRegistration   where UserPlandetailsId is not null
     --          group by UserLoginId 
     --         having count(customeremail)=1  
			  --) 
			 

 	          print @customername 
			  print @ClientId 
	
	
	
	
	 select @totalCount = COUNT(1) from #TEMP;

	          IF @Flag = 'CSV'
			     BEGIN
				    SELECT *  FROM #TEMP order by PolicyStartDate desc
				 END
			  ELSE
			     BEGIN
				     SELECT *  FROM #TEMP order by PolicyStartDate desc
			         offset @RecordPerPage * (@PageNumber-1)rows                                
                      FETCH NEXT @RecordPerPage rows only 
				 END

			  


			 select @totalCount As totalCount,@DisplayFromDate as DisplayFromDate,@DisplayToDate as DisplayToDate

			 DROP TABLE #TEMP;
			 

			 
			 
			 	    

END









