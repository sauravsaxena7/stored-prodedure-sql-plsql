USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspClientTotalDetailsPartner]    Script Date: 5/9/2024 3:32:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Atul Sharma>
-- Create date: <02/11/2022>
-- Description:    <Fetch user Onboarded Report>


-- exec uspClientTotalDetails  125,2,null,'2020-04-01','2024-03-01',null
-- exec uspClientTotalDetailsPartner  'ELITEDAPL01'

-- =============================================
ALTER PROCEDURE [dbo].[uspClientTotalDetailsPartner]

 
 @PartnerCode varchar(max),
 @UserTypeRoleId int = 0,
 @GENDER CHAR(1)=NULL,
 @DateFromRange DATETIME=null,
 @DateToRange DATETIME=null,
 @UserType varchar(50)=null--,
-- @DownloadFlag varchar(10)=null

AS
BEGIN

    SET NOCOUNT ON;

 

/****************************Start DECLARE VARIABLES*********************************/
   
  --  CREATE TABLE #Temp(OPDPartnerDetailsId Int, PolicyNo varchar(100), Status varchar(100))
	 
  --  Create Table #Temp3(Cancelled INT,Success INT,Pending INT, Requested Int)
   
	CREATE TABLE #Temp(PolicyNo varchar(100), OPDPartnerDetailsId Int,  Status varchar(100), IsActive char(1), ActiveStatus char(1), Amount decimal ,createdDate datetime)


/****************************End DECLARE VARIABLES*********************************/


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
/*********************************************[START] Fetch user Plan data******************************************/
    
/*********************************************INSERT TEMP Table Logic*****************************************************************/
 --    INSERT INTO #Temp(OPDPartnerDetailsId ,PolicyNo, Status )
 --    select opd.OPDPartnerDetailsId,pd.PolicyNo,pd.Status from OPDPartnerDetails opd
	--join OPDPaymentDetails pd on pd.PartnerOrderId= cast(opd.OPDPartnerDetailsId as varchar)
	--where opd.PartnerCode=@PartnerCode
--INSERT INTO #Temp(OPDPartnerDetailsId ,PolicyNo, Status, IsActive, ActiveStatus )
--select opd.OPDPartnerDetailsId,pd.PolicyNo,pd.Status,mp.IsActive,upd.ActiveStatus 
--from MemberCallDetails mcd 
--join MemberCallLog mcl on mcd.MemCallId=mcl.MemCallId
--join CallStatus cs on cs.CallStatusId=mcl.StatusId
--join Member m on m.MemberId=mcd.MemberId
--left join LibertyEmpRegistration lb on lb.HAMemberId=m.MemberId
--left join MemberPlan mp on mp.MemberPlanId=lb.MemberPlanId
--left join UserPlanDetails upd on upd.MemberId=m.MemberId
--left join corporateplan cp on cp.PlanCode=lb.PlanCode
--left join CNPlanDetails cn on cn.PlanCode=lb.PlanCode
--join OPDPaymentDetails pd on pd.MemberId=lb.MemberID
--join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId 
--where opd.PartnerCode=@PartnerCode

INSERT INTO #Temp(PolicyNo, OPDPartnerDetailsId , Status, IsActive, ActiveStatus,Amount,createdDate )
select distinct pd.PolicyNo,opd.OPDPartnerDetailsId, pd.Status,mp.IsActive,upd.ActiveStatus,pd.Amount ,pd.CreatedDate
from OPDPaymentDetails pd
join OPDPartnerDetails opd on cast(opd.OPDPartnerDetailsId as varchar)=pd.PartnerOrderId
left join LibertyEmpRegistration lb on lb.PolicyNo=pd.PolicyNo
left join Member m on m.MemberId=lb.HAMemberId
left join MemberPlan mp on mp.MemberId=m.MemberId
left join UserPlanDetails upd on upd.MemberId=m.MemberId
left join corporateplan cp on cp.PlanCode=lb.PlanCode
left join CNPlanDetails cn on cn.PlanCode=lb.PlanCode
where opd.PartnerCode in (select * from STRING_SPLIT(@PartnerCode, ',')) and ISNULL(mp.IsActive,'')<>'R' and ISNULL(upd.ActiveStatus,'')<>'R'
and pd.Email not like '%demo%' and pd.Email not like '%Test%' and pd.Email not like '%dummy%'
and pd.Email not like '%mailinator%' and pd.Email not like '%mainator%' 
and pd.name not like '%demo%' and pd.name not like '%Test%' and pd.name not like '%dummy%'
	

/********************************************End TEMP Table logic*********************************************************************/
---------------------------------------------------------------------------------------------------------------------------------------
/*******************************************INSERT TEMP3 table Logic******************************************************************/
 

	--INSERT INTO #Temp3(TotalIssuedPolicy ,Pending ,Success , Cancelled , Requested)
	--values(
 --    (select count(PolicyNo) from #Temp),
	-- (0),
	--((select count(PolicyNo) from #Temp where (status in ('Success') and ISNULL(IsActive,'')<>'N' and IsActive is not null ) and (status in ('Success') and ISNULL(ActiveStatus,'')<>'N' and ActiveStatus is not null))),
	--((select count(PolicyNo) from #Temp where (status in ('Success') and ISNULL(IsActive,'N')='N') and (status in ('Success') and ISNULL(ActiveStatus,'N')='N'))),	
	--(select count(PolicyNo) from #Temp where Status='Requested'))


/******************************************END TEMP3 Table Logic***********************************************************************/

 
  Select (select count(PolicyNo) from #Temp ) As TotalIssuedPolicy
          ,0 AS  Pending,
		 ((select count(PolicyNo) from #Temp where (status in ('Success') and ISNULL(IsActive,'')<>'N' and IsActive is not null) and (status in ('Success') and ISNULL(ActiveStatus,'')<>'N'  )) ) AS Success,
		 ((select count(PolicyNo) from #Temp where (status in ('Success') and ISNULL(IsActive,'N')='N') and (status in ('Success') and ISNULL(ActiveStatus,'N')='N'))) AS Cancelled,
		 (select count(PolicyNo) from #Temp where Status='Requested') AS Requested

		 Select (select sum(Amount) from #Temp ) As TotalIssuedPolicyPremium
          ,0 AS  PendingPremium,
		 ((select sum(Amount) from #Temp where (status in ('Success') and ISNULL(IsActive,'')<>'N' and IsActive is not null) and (status in ('Success') and ISNULL(ActiveStatus,'')<>'N'  )) ) AS SuccessPremium,
		 ((select sum(Amount) from #Temp where (status in ('Success') and ISNULL(IsActive,'N')='N') and (status in ('Success') and ISNULL(ActiveStatus,'N')='N'))) AS CancelledPremium,
		 (select sum(Amount) from #Temp where Status='Requested') AS RequestedPremium

		 SELECT 
		           (select ISNULL(sum(Amount),0) from #Temp WHERE CAST(createdDate AS DATE) BETWEEN CAST( GETDATE() AS Date ) AND CAST( GETDATE() AS Date ) ) As TotalIssuedPolicyPremiumFTD,

				  0 AS  PendingPremiumFTD ,

		           ((select ISNULL(sum(Amount),0) from #Temp where (status in ('Success') and ISNULL(IsActive,'')<>'N' and IsActive is not null ) and (status in ('Success') and ISNULL(ActiveStatus,'')<>'N') and CAST(createdDate AS DATE) BETWEEN CAST( GETDATE() AS Date ) AND CAST( GETDATE() AS Date )) ) AS SuccessPremiumFTD,


				    ((select ISNULL(sum(Amount),0) from #Temp where (status in ('Success') and ISNULL(IsActive,'N')='N') and (status in ('Success') and ISNULL(ActiveStatus,'N')='N' and CAST(createdDate AS DATE) BETWEEN CAST( GETDATE() AS Date ) AND CAST( GETDATE() AS Date )))) AS CancelledPremiumFTD,

					 (select  ISNULL(sum(Amount),0) from #Temp where Status='Requested' and CAST(createdDate AS DATE) BETWEEN CAST( GETDATE() AS Date ) AND CAST( GETDATE() AS Date ) ) AS RequestedPremiumFTD
		  
		  
 


/******************End select table***********************************************************************************************************************/


 END