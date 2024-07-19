USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspGetReimbursementMISReport]    Script Date: 5/23/2024 7:26:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- Created by  Pruthviraj kengar
-- exec [dbo].[uspGetReimbursementMISReport] '2024-04-01','2024-04-17',null,null,null,'N'

ALTER proc [dbo].[uspGetReimbursementMISReport]  
(  
   @FromDate datetime=null,  
   @ToDate datetime=null,
   @ClientType varchar(200)=null,  
   @ClientName varchar(500)=null,  
   @Status varchar(200)=null  ,
   @IsShowMaskData VARCHAR(20)=NULL
)  
AS  
BEGIN  
    IF(@FromDate is null AND @ToDate is null)  
 BEGIN  
     set @FromDate=CAST(DATEADD(DAY,-1,GETDATE()) as date);  
     set @ToDate =CAST(GETDATE() as date);  
 END  
 ELSE  
 BEGIN  
      set @FromDate=CAST(@FromDate as date);  
  set @ToDate =CAST(@ToDate as date);  
 END  
     
 Declare @DefaultValue varchar(200) = 'NA';  
 Declare @DefaultDateTime datetime =null;  
   ---  latest changes done by pruthviraj kengar 22032024
    create table #tmp
    (
    AppointmentId bigint,
    CaseNo varchar(250),
    ClientName varchar(250),
    VisitType varchar(250),
    CustomerName varchar(250),
    MemberName varchar(250),
    Relation varchar(250),
    PolicyNumber varchar(250),
    EmailId varchar(250),
    ContactNo varchar(250),
    FacilityName varchar(250),
    FacilityGroupName varchar(250),
    ProviderName varchar(250),
    Type varchar(250),
    RequestedDate varchar(250),
    ApprovedOrRejectedDate varchar(250),
    CompletedDate varchar(250),
    Status varchar(250),
    PaymentMode varchar(250),
    AccountName varchar(250),
    AccountNumber varchar(250),
    AccountType varchar(250),
    IfscCode varchar(250),
    BankName varchar(250),
    BranchName varchar(250),
    UpiId varchar(250),
    ApprovedAmount varchar(250),
    CreatedBy varchar(250),
    UpdatedBy varchar(250),
    ParentCaseNo varchar(250),	
    ParentCaseAddress varchar(250),
    UpdatedDate varchar(250),	
    FinanceApprovedBy varchar(250),
    FinanceApprovedDate varchar(250),	
    Reason varchar(250),
    PlanName varchar(250),PlanCode varchar(250),Gender varchar(250),DOB varchar(250),ClaimedAmount varchar(250),Rejection varchar(500),PlanStart varchar(255),PlanEnds varchar(255),UTRNO varchar(250)
    )
	insert into #tmp(AppointmentId,CaseNo,ClientName,VisitType,CustomerName,MemberName,Relation,PolicyNumber,EmailId,ContactNo,FacilityName,FacilityGroupName,ProviderName,Type,RequestedDate,ApprovedOrRejectedDate,CompletedDate,Status,PaymentMode,AccountName,AccountNumber,AccountType,IfscCode,BankName,BranchName,UpiId,ApprovedAmount,CreatedBy,UpdatedBy,ParentCaseNo,ParentCaseAddress,UpdatedDate,FinanceApprovedBy,FinanceApprovedDate,Reason,PlanName,PlanCode,Gender,DOB,ClaimedAmount,Rejection,PlanStart,PlanEnds,UTRNO)
  select distinct A.AppointmentId, A.CaseNo,C.ClientName,A.VisitType,
  CONCAT(U.FirstName,' ',U.LastName) as CustomerName,
  CONCAT(M.FirstName,' ',M.LastName) as MemberName,M.Relation,ISNULL(L.PolicyNo,'') as PolicyNumber,
  --M.EmailId,
  --M.MobileNo as ContactNo 
  IIF(@IsShowMaskData='Y',M.EmailId,[dbo].[GetMaskedEmail](M.EmailId)),
  IIF(@IsShowMaskData='Y',M.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](M.MobileNo)) as ContactNo ,
   F.FacilityName,FG.FacilityGroupName, A.AppointmentCenterName as ProviderName,'Reimbursement' as Type,
   cast(cast(A.Createddate as date) as varchar) as RequestedDate,
   cast(cast(@DefaultDateTime  as date) as varchar) as ApprovedOrRejectedDate
   ,cast(cast(@DefaultDateTime  as date) as varchar)  as CompletedDate,S.StatusName as Status  
  ,RI.PaymentTransferType as PaymentMode,
  RI.AccountName,
 -- RI.AccountNumber,
  IIF(@IsShowMaskData='Y', RI.AccountNumber,[dbo].[GetMaskedAllCharExceptLast_4_Digit](RI.AccountNumber)),
  RI.AccountType,
  --RI.IFSCCode as IfscCode,
  RI.IFSCCode as IfscCode ,
  RI.Bank as BankName,Branch as BranchName,
  -- UPIHandle as UpiId,
  IIF(@IsShowMaskData='Y', UPIHandle,   [dbo].[GetDynamicLentgthCharacters]( LEN(UPIHandle)-LEN(SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)),'*' ) +  SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)  ) as  UpiId,
 
  @DefaultValue as ApprovedAmount  
  ,RI.CreatedBy,RI.UpdatedBy,@DefaultValue as ParentCaseNo,
  A.AppointmentAddress as ParentCaseAddress,cast(cast(A.UpdatedDate as date) as varchar) as UpdatedDate ,
  @DefaultValue as FinanceApprovedBy,cast(cast(@DefaultDateTime  as date) as varchar) as FinanceApprovedDate,
  @DefaultValue as Reason  
  ,CP.PlanName,CP.PlanCode, (case when M.Gender='M' then 'Male' When M.Gender='F' then 'Female' end) as gender,cast(m.DOB as varchar) as DOB,Ad.FacilityAmount,null, cast(cast(MP.FromDate as date)as varchar) as PlanStart,
   cast(cast(MP.ToDate as date) as varchar) as PlanEnds,null
   from  Appointment A  
   join  ReimbursementMemberPlanDetails RI  on A.AppointmentId = RI.AppointmentId 
   left join reimbursementlogs RL on RL.AppointmentID = RI.AppointmentId  
   left join AppointmentDetails ad on ad.AppointmentId= A.AppointmentId
   join StatusMaster S  on A.ScheduleStatus = S.StatusId  
   join UserLogin U on U.UserLoginId = A.UserLoginId  
   join Member M on M.UserLoginId = U.UserLoginId  and M.Relation='Self'
   join MemberPlan mp on mp.MemberId=m.MemberId and m.Relation='Self'  
   join Client C on C.ClientId = A.ClientId  
   join CorporatePlan CP on CP.CorporatePlanId = RI.CorporatePlanId 
   join LibertyEmpRegistration L on L.UserLoginId=A.UserLoginId and L.PlanCode=cp.PlanCode
   left join FacilitiesMaster F on F.FacilityId = RI.FacilityId  
   left join FacilityGroupCombinaton FG on FG.FacilityGroupCombinatonId = RI.FacilityGroupCombinationId  
   where A.CreatedDate BETWEEN @FromDate and @ToDate  
   AND (ISNULL(@ClientType,'')='' OR @ClientType=C.BUSubType)  
   AND (ISNULL(@ClientName,'')='' OR @ClientName=C.ClientName)  
   AND (ISNULL(@Status,'')='' OR @Status=A.ScheduleStatus)  
   union all
    select distinct A.AppointmentId, A.CaseNo,C.ClientName,A.VisitType,CONCAT(U.FirstName,' ',U.LastName) as CustomerName,
	CONCAT(M.FirstName,' ',M.LastName) as MemberName,M.Relation,ISNULL(L.PolicyNo,'') as PolicyNumber,
	--M.EmailId,
	--M.MobileNo as ContactNo 
	 IIF(@IsShowMaskData='Y',M.EmailId,[dbo].[GetMaskedEmail](M.EmailId)),
      IIF(@IsShowMaskData='Y',M.MobileNo,[dbo].[GetMaskedSimpleAlphaNumberData](M.MobileNo)) as ContactNo  ,
   F.FacilityName,F.FacilityGroup, A.AppointmentCenterName as ProviderName,'Reimbursement' as Type,cast(cast(@DefaultDateTime as date) as varchar) as RequestedDate,cast(cast(@DefaultDateTime  as date) as varchar) as ApprovedOrRejectedDate,cast(cast(@DefaultDateTime  as date) as varchar)  as CompletedDate,S.StatusName as Status  
  ,RI.PaymentTransferType as PaymentMode,RI.AccountName,
  --RI.AccountNumber,
  IIF(@IsShowMaskData='Y', RI.AccountNumber,[dbo].[GetMaskedAllCharExceptLast_4_Digit](RI.AccountNumber)),
  RI.AccountType,
  RI.IFSCCode as IfscCode, 
  
  RI.Bank as BankName,Branch as BranchName,
  --UPIHandle as UpiId,
  --IIF(@IsShowMaskData='Y', UPIHandle, SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)) as UpiId,
   IIF(@IsShowMaskData='Y', UPIHandle,   [dbo].[GetDynamicLentgthCharacters]( LEN(UPIHandle)-LEN(SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)),'*' ) +  SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)  ) as  UpiId,
  @DefaultValue as ApprovedAmount  
  ,RI.CreatedBy,RI.UpdatedBy,@DefaultValue as ParentCaseNo,A.AppointmentAddress as ParentCaseAddress,cast(cast(A.UpdatedDate as date) as varchar) as UpdatedDate ,@DefaultValue as FinanceApprovedBy,cast(cast(@DefaultDateTime  as date) as varchar) as  FinanceApprovedDate,@DefaultValue as Reason  
  ,CP.PlanName,CP.PlanCode, (case when M.Gender='M' then 'Male' When M.Gender='F' then 'Female' end) as gender,cast(m.DOB as varchar) as DOB,RI.TxnAmount,null, cast(cast(MP.FromDate as datetime)as varchar) as PlanStart,
   cast(cast(MP.ToDate as datetime) as varchar) as PlanEnds,null
   from  Appointment A  
   join  ReimbursementMemberPlanDetails RI  on A.AppointmentId = RI.AppointmentId 
   left join reimbursementlogs RL on RL.AppointmentID = RI.AppointmentId  
   left join AppointmentDetails ad on ad.AppointmentId= A.AppointmentId
   join StatusMaster S  on A.ScheduleStatus = S.StatusId  
   join UserLogin U on U.UserLoginId = A.UserLoginId  
   join Member M on M.UserLoginId = U.UserLoginId  and M.Relation='Self'
   join UserPlanDetails mp on mp.MemberId=m.MemberId and m.Relation='Self'  
   join Client C on C.ClientId = A.ClientId  
   join CNPlanDetails CP on CP.CNPlanDetailsId = MP.CNPlanDetailsId 
   join LibertyEmpRegistration L on L.UserLoginId=A.UserLoginId and L.PlanCode=cp.PlanCode
   left join FacilitiesMaster F on F.FacilityId = RI.FacilityId  
   left join FacilityGroupCombinaton FG on FG.FacilityGroupCombinatonId = RI.FacilityGroupCombinationId  
   where A.CreatedDate BETWEEN @FromDate and @ToDate  
   AND (ISNULL(@ClientType,'')='' OR @ClientType=C.BUSubType)  
   AND (ISNULL(@ClientName,'')='' OR @ClientName=C.ClientName)  
   AND (ISNULL(@Status,'')='' OR @Status=A.ScheduleStatus)  

   update T  
   set RequestedDate= (select top 1 AL.CreatedDate  
   from AppointmentLog AL   
   where AL.ScheduleStatus in(1,48) AND AL.AppointmentId=T.AppointmentId)  
   from #tmp T  
    
   update T  
   set ApprovedOrRejectedDate = (select top 1 AL.CreatedDate  
   from AppointmentLog AL   
   where AL.ScheduleStatus in(23,25) AND AL.AppointmentId=T.AppointmentId)  
   from #tmp T  
  
   update T  
   set CompletedDate = (select top 1 AL.CreatedDate  
   from AppointmentLog AL      
   where AL.ScheduleStatus=24 AND AL.AppointmentId=T.AppointmentId)  
   from #tmp T  
   
   update T  
   set ApprovedAmount= ISNULL((select top 1 CAST(RL.ReimbursementAmt as varchar)  
   from reimbursementlogs RL   
   where RL.StatusID=25 AND RL.AppointmentID=T.AppointmentId),@DefaultValue)   
   from #tmp T  
   
   update T
   set Rejection = (select top 1 AL.Remarks
   from AppointmentLog AL    
   where AL.ScheduleStatus=23 AND AL.AppointmentId=T.AppointmentId)
   from #tmp T

   update T  
   set FinanceApprovedBy= ISNULL(CAST(AL.CreatedBy as varchar),@DefaultValue),  
   FinanceApprovedDate = AL.CreatedDate  
   from AppointmentLog AL   
   join #tmp T on T.AppointmentId=AL.AppointmentId  
   where AL.ScheduleStatus=24  
    
   Update T  
   set ParentCaseNo = ISNULL((select CaseNo from Appointment where AppointmentId=(select ISNULL(ParentAppointmentId,0) from Appointment where AppointmentId=T.AppointmentId)),@DefaultValue)  
   from #tmp T  

   update T
   set UTRNO = (select top 1 AL.Remarks
   from AppointmentLog AL    
   where AL.ScheduleStatus=24 AND AL.AppointmentId=T.AppointmentId)
   from #tmp T

  ;WITH cte AS (                                            
   SELECT *, ROW_NUMBER() OVER (                                            
            PARTITION BY                                             
              CaseNo                                       
            ORDER BY                                             
             CaseNo                                        
        ) row_num                                            
     FROM #tmp                                            
   )                                            
   DELETE FROM cte                                            
   WHERE row_num > 1;          

   select * from #tmp  
   drop table #tmp
END







