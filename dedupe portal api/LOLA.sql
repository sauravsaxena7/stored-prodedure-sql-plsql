--select * from OPDPAYMENTDETAILS where policyNo='OPD-HAOPDR00U40-54611'
--select * from OPDPAYMENTDETAILS WHERE PolicyNo='OPD-HAOPDR00U40-54616'
--SELECT * FROM CorporatePlan where PlanCode='HAOPDR00U40'
DECLARE @FromDate date='2024-02-06';
DECLARE @ToDate date='2024-02-08';
DECLARE @ClientId VARCHAR(200) ='292'
DECLARE @PolicyNo VARCHAR(150)='OPD-HAOPDR00U40-54616'
select 
			   opd.PolicyNo,l.CreatedDate,opd.Name,opd.Email,opd.Mobile,l.userloginid,
			   l.clientId,c.clientname,concat(u.firstname,'',u.lastname),mp.MemberPlanId,
               mp.corporateplanid, cp.planname,mp.fromdate,mp.ToDate,mp.Isactive,
			   mp.PlanCancelRemark,
			   opd.TransactionId,opd.PlanCode,opd.TotalAmount,opd.CreatedDate ,
			   opd.Status,opd.UpdatedDate,Isnull(op.PartnerCode,''),Isnull(op.PartnerName,''),'N'
               from OPDPAYMENTDETAILS opd
             
			  left join LibertyEmpRegistration   L on CAST(opd.PolicyNo AS varchar(500))=CAST(l.PolicyNo AS varchar(500))
			   join MemberPlan mp on l.MemberPlanId=mp.MemberPlanId
              join corporateplan cp on cp.PlanCode=opd.PlanCode
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(150))=CAST(op.OPDPartnerDetailsId AS VARCHAR(150))
              join client c on c.clientId=l.ClientId
              join userlogin u on u.UserLoginId=l.UserLoginId
              where 
			  (@ClientId is null OR l.clientId in (select * from SplitString(@ClientId,',')))    and   
			  --(@customeremail is null OR opd.Email  like '%'+@customeremail+'%')   and 
			  --(@Status is null OR  opd.Status  like '%'+@Status+'%') and 
			  --(@PartnerId is null OR op.OPDPartnerDetailsId in (select * from SplitString(@PartnerId,','))) and
			  
			   (@PolicyNo is null OR  opd.PolicyNo  like '%'+@PolicyNo+'%') and 
			  --(@customermobile is null OR opd.Mobile  like '%'+@customermobile+'%') and 
			  --(@Plan is null OR cp.CorporatePlanId in(select * from SplitString(@Plan,',')))  and 
			  --(@customername is null OR concat(u.firstname,'',u.lastname) like '%'+@customername+'%')  and
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
			   opd.PolicyNo,l.CreatedDate,opd.Name,opd.Email,opd.Mobile,l.userloginid,
			   l.clientId,c.clientname,concat(u.firstname,'',u.lastname),mp.UserPlanDetailsId,
               mp.CNPlanDetailsId, cp.planname,mp.fromdate,mp.ToDate,mp.ActiveStatus,
			   mp.PlanCancelRemark,
			   opd.TransactionId,opd.PlanCode,opd.TotalAmount,opd.CreatedDate ,
			   opd.Status,opd.UpdatedDate,Isnull(op.PartnerCode,''),Isnull(op.PartnerName,''),'Y'
               from OPDPAYMENTDETAILS   opd 
			  left join LibertyEmpRegistration   l on CAST(opd.PolicyNo AS varchar(500))=CAST(l.PolicyNo AS varchar(500))
			   join UserPlanDetails mp on l.UserPlanDetailsId=mp.UserPlanDetailsId
              join CNPlanDetails cp on cp.PlanCode=opd.PlanCode 
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(550))=CAST(op.OPDPartnerDetailsId AS VARCHAR(550))
              join client c on c.clientId=l.ClientId
              join userlogin u on u.UserLoginId=l.UserLoginId
              where 
			  (@ClientId is null OR l.clientId in (select * from SplitString(@ClientId,',')))    and   
			 -- (@customeremail is null OR opd.Email  like '%'+@customeremail+'%')   and 
			  --(@customermobile is null OR  opd.Mobile  like '%'+@customermobile+'%') and 
			  --(@Status is null OR  opd.Status  like '%'+@Status+'%') and 
			 -- (@PartnerId is null OR op.OPDPartnerDetailsId in (select * from SplitString(@PartnerId,','))) and
			  (@PolicyNo is null OR  opd.PolicyNo  like '%'+@PolicyNo+'%') and 
			  --(@Plan is null OR cp.CNPlanDetailsId in(select * from SplitString(@Plan,',')))  and 
			  --(@customername is null OR concat(u.firstname,'',u.lastname) like '%'+@customername+'%')  and
			  (@FromDate is null and @ToDate is null OR cast (opd.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))  --and

			  --l.UserLoginId in (

     --         select distinct(UserLoginId)
     --         from LibertyEmpRegistration   where UserPlandetailsId is not null
     --          group by UserLoginId 
     --         having count(customeremail)=1  
			  --) 



			  select 
			   opd.PolicyNo
			   from OPDPAYMENTDETAILS   opd 
              where 
			  --('292' is null OR l.clientId in (select * from SplitString('292',',')))    and 
			  (@PolicyNo is null OR  opd.PolicyNo  like '%'+@PolicyNo+'%')
			   ('OPD-HAOPDR00U40-54611' is null OR  opd.PolicyNo  ='OPD-HAOPDR00U40-54611')