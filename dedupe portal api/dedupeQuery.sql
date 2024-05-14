select opd.Name as CustomerName,opd.Email,opd.Mobile,opd.PlanCode,cp.PlanName,opd.TransactionId as ApplictionNumber,opd.policyno,
opd.TotalAmount,opd.CreatedDate as ProposalCreatedDate,opd.Status,opd.UpdatedDate as LastUpdatedDate,Isnull(op.PartnerCode,'') as Elite_partners_ID,Isnull(op.PartnerName,'') as Elite_partners_Name, opd.CreatedDate
from  corporatePlan cp
join OPDPAYMENTDETAILS   opd on opd.PlanCode=cp.PlanCode
left join OPDPartnerDetails  op on opd.PartnerOrderId=op.OPDPartnerDetailsId
where opd.PlanCode in ('HAOPDR00U40','HAOPDR00U41','HAOPDR00U43','HAOPDR00U44','HAOPDR00U45','ACEHG001','AceEliteAssure1','HAESS001','ACEES001','HAACEHSP001','HAACEHS001','ACEHP001','ACEHPP001','HAACEMHM001','HAACEMHM002','HAACEMHM003','HAACEMHM004','ACEkavach01','HAASI001','HAAGF001','HAAPF001','HAAPSC001','HAACEMHM001','HAACEMHM002','HAACEMHM003','HAACEMHM004','HADEMOMFM','HADEMOMHM13','HAMHM13','HAMFM')
and  opd.OPDPaymentDetailsId not in (3517,3519,3527,3542,3557,3616,3695,3709,3961,4056,4196,4434,4435,4436,4437,4442,4459,4460,4461,4462,4463,4464,4470,4206,4213,4666,4707,4708,4709,4712,4713,6303)

SELECT TOP 100 * FROM OPDPartnerDetails ORDER BY 1 DESC

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
              join corporateplan cp on cp.CorporatePlanId=mp.CorporatePlanId
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(150))=CAST(op.OPDPartnerDetailsId AS VARCHAR(150))
              join client c on c.clientId=l.ClientId
              join userlogin u on u.UserLoginId=l.UserLoginId
              where  c.clientId in(292)
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
              join CNPlanDetails cp on cp.CNPlanDetailsId=mp.CNPlanDetailsId
              left join OPDPartnerDetails  op on CAST (opd.PartnerOrderId AS varchar(550))=CAST(op.OPDPartnerDetailsId AS VARCHAR(550))
              join client c on c.clientId=l.ClientId
              join userlogin u on u.UserLoginId=l.UserLoginId
              where c.clientId in(292)

			  Select DISTINCT(OP.PartnerCode), OP.OPDPartnerDetailsId,OP.PartnerName 
from OPDPartnerDetails OP 
join CorporatePlan CP ON CP.CorporatePlanId=OP.PlanId
join Client C on C.ClientId=CP.ClientId
where OP.IsActive = 'Y' 
and CP.IsActive='Y' AND C.ClientId IN (292) and op.PartnerName is not null
			   