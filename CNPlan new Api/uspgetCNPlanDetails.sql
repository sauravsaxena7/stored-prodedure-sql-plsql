USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspgetCNPlanDetails]    Script Date: 2/12/2024 1:55:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM CNPlanDetails where CNPlanDetailsId=56
--RegistrationValidationFormula=NULL
--== Created By Pruthviraj Kengar	
--== date 13-07-23 --To get plan details in ops portal
----= exec uspgetCNPlanDetails 56
ALTER proc [dbo].[uspgetCNPlanDetails]
@planId bigint
as
begin	
if exists(select * from CNPlanDetails where CNPlanDetailsId=@planId)
begin
declare @IsInsuranceB char='N',@TypeOfCoverage varchar(200)='Self'
if exists( select * from CNPLanInsuranceBenefit where cnplandetailsid=@planid)
begin
set @IsInsuranceB='Y'
end
if exists(select * from CNPlanRelation where CNPlanDetailsId= @planId)
begin
set @TypeOfCoverage='Family'
end
---Get plan master
declare @WelcomeHtml nvarchar(max)='';
select @WelcomeHtml=isnull(TemplateContent,'') from CommunicationTemplate where CNPlanDetailsId=@planId
select cnp.ClientId,cl.clientName,cnp.NumberOfEmployees,cnp.WaitingPeriod,cnp.CNPlanDetailsId,cnp.PlanName,cnp.PlanCode,cnp.PlanAmount,cnp.FromDate,cnp.ToDate,cnp.AgeFrom,cnp.AgeTo,cnp.LoginBy,cnp.InvoiceType,cnp.Gender,cnp.PlanDurationInMonths,isnull(cnp.MidTermValidity,0) as MidTermValidity,cnp.MaxRelationAllowed,cnp.PlanTnC,
( case when Isnull(cnp.WelcomeEmailToBeSent,'N')='Y' then 'Y' when isnull(cnp.TransactionEmailToBeSent,'N')='Y' then 'Y' else 'N' end) as IsEmail,isnull(cnp.WelcomeEmailToBeSent,'N') as WelcomeEmailToBeSent,ISNULL(cnp.TransactionEmailToBeSent,'N') as TransactionEmailToBeSent, @IsInsuranceB as IsInsuranceBenifit ,@TypeOfCoverage as TypeOfCoverage,isnull(cnp.WelcomeSMSToBeSent,'N')as WelcomeSMSToBeSent,isnull(cnp.TransactionSMSToBeSent,'N') as TransactionSMSToBeSent,isnull(cnp.WelcomeWhatsappToBeSent,'N') as WelcomeWhatsappToBeSent,ISNULL(cnp.TransactionWhatsappToBeSent,'N') as TransactionWhatsappToBeSent,  
( case when Isnull(cnp.WelcomeSMSToBeSent,'N')='Y' then 'Y' when isnull(cnp.TransactionSMSToBeSent,'N')='Y' then 'Y' else 'N' end) as IsSMS,( case when Isnull(cnp.WelcomeWhatsappToBeSent,'N')='Y' then 'Y' when isnull(cnp.TransactionWhatsappToBeSent,'N')='Y' then 'Y' else 'N' end) as IsWhtasApp ,Isnull(cnp.COIToBeSent,'N') as COIToBeSent  ,@WelcomeHtml as WelcomeEmailerHTML,ISNULL(cnp.RegistrationValidationFormula,'') AS  RegistrationValidationFormula from CNPlanDetails cnp join Client cl on cnp.clientid=cl.clientid where cnp.CNPlanDetailsId=@planid
select  r.relationid,r.Relation,r.MasterRelationGroup from CNPlanRelation cnr join RelationMaster r on r.relationid in(select * from string_split(cnr.relationids,',')) where cnr.cnplandetailsid=@planId
select cnr.RelationAllowed,cnr.AgeFrom ,cnr.AgeTo ,cnr.MasterRelationGroupId from CNPlanDetails cnp join CNPlanRelation cnr on cnp.CNPlanDetailsId=cnr.CNPlanDetailsId where cnr.CNPlanDetailsId=@planId

select ins.CNPLanInsuranceBenefitId,ins.Benefit,ins.SumInsuredAmount,ins.InsurerName,(case when ins.NomineeRequired=1 then 'Y' else 'N' end) as NomineeRequired,isnull(ins.BenefitImage,'') as BenifitImage,ib.InsuranceBenefitId from CNPLanInsuranceBenefit ins join InsuranceBenefit ib on ins.Benefit=ib.BenefitName where CNPlanDetailsId=@planId
--rule engine waiting rule
select string_agg(cnb.CNPLanBucketId,',') as CNPlanBucketIds,string_agg(cnb.BucketName,',') as BucketNames,isnull(cnr.WaitingPeriod,0) as WaitingPeriod,cnr.WaitingPeriodType from CNPLanBucketRuleEngine cnr left join CNPLanBucket cnb on cnr.CNPLanBucketId=cnb.CNPLanBucketId where cnr.CNPlanDetailsId=@planId and cnr.WaitingPeriod is not null group by cnr.WaitingPeriod,cnr.WaitingPeriodType
--end
--rule engine Transaction rule
select   string_agg(cnb.CNPLanBucketId,',') as CNPlanBucketIds,string_agg(cnb.BucketName,',') as BucketNames,isnull(cnr.NumberofTransactionLimit,0) as NumberofTransactionTimePeriod ,isnull(cnr.NumberofTransactionTimePeriod,'') as NumberofTransactionLimit ,isnull(cnr.NumberofTransactionTimePeriodType,'') as NumberofTransactionTimePeriodType from CNPLanBucketRuleEngine cnr left join CNPLanBucket cnb on cnr.CNPLanBucketId=cnb.CNPLanBucketId where cnr.CNPlanDetailsId=@planId and cnr.NumberofTransactionLimit is not null group by cnr.NumberofTransactionLimit,cnr.NumberofTransactionTimePeriod,cnr.NumberofTransactionTimePeriodType 
--end
--Transaction No rule starts
select string_agg(cnb.CNPLanBucketId,',') as CNPlanBucketIds,string_agg(cnb.BucketName,',') as BucketNames,isnull(cnr.PerTransactionLimit,0) as PerTransactionLimit,isnull(cnr.UseAsVoucher,'N')as UseAsVoucher from CNPLanBucketRuleEngine cnr left join CNPLanBucket cnb on cnr.CNPLanBucketId=cnb.CNPLanBucketId where cnr.CNPlanDetailsId=@planId and cnr.PerTransactionLimit is not null group by cnr.PerTransactionLimit,cnr.UseAsVoucher 
--end
--Amount Capping for give time starts
select string_agg(cnb.CNPLanBucketId,',') as CNPlanBucketIds,string_agg(cnb.BucketName,',') as BucketNames,isnull(cnr.AmountCappinginAGiventTimePeriod,0) as AmountCappinginAGiventTimePeriod,isnull(cnr.AmountCappinginAGiventTimePeriodType,'') as AmountCappinginAGiventTimePeriodType,isnull(cnr.AmountCappinginAGiventTimePeriodAmount,0) as AmountCappinginAGiventTimePeriodAmount from CNPLanBucketRuleEngine cnr left join CNPLanBucket cnb on cnr.CNPLanBucketId=cnb.CNPLanBucketId where cnr.CNPlanDetailsId=@planId and cnr.AmountCappinginAGiventTimePeriod is not null group by cnr.AmountCappinginAGiventTimePeriod,cnr.AmountCappinginAGiventTimePeriodType,cnr.AmountCappinginAGiventTimePeriodAmount
--end

select cnp.CNPlanVariationsId,cnp.PlanBucketId,isnull(cnp.DefineOfVariationInPercentage,0) DefineOfVariationInPercentage ,isnull(cnb.BucketName,'') as BucketName from CNPlanVariations cnp join Cnplanbucket cnb on cnp.PlanBucketId=cnb.CNPLanBucketId where cnp.CNPlanDetailsId=@planId

select CNPlanTermsOfUseId,case IsPrescriptionMandatory when 1 then 'Y' else 'N' end as IsPrescriptionMandatory ,case IsVerifyPageOnMobileApp when 1 then 'Y' else 'N' end as IsVerifyPageOnMobileApp, case IsPharmacyDiscount when 1 then 'Y' else 'N' end as IsPharmacyDiscount,isnull(PharmacyDiscPercentage,0) as PharmacyDiscPercentage,isnull(PharmacyOrderLimit,0) as PharmacyOrderLimit,isnull(PharmacyMaxDiscountLimit,0) as PharmacyMaxDiscountLimit,isnull(PharmaDiscDurationInDays,0)as PharmaDiscDurationInDays,isnull(BucketFormula,'')as BucketFormula,isnull(ProviderGrade,'N')as ProviderGrade,isnull(AmountTobeShown,'')as AmountTobeShown,isnull(AmountTobeDeducted,'') as AmountTobeDeducted,isnull(PreConditionedEventFormula,'N') as PreConditionedEventFormula from CNPlanTermsOfUse where CNPlanDetailsId=@planId

---Plan Commercials data ------
select CommercialText,FilePath from CNPlanCommercialDetails where CNplandetailsid=@Planid
--end
-- Pre Conditioned Events
select pce.ToUseBucketId,cnb.BucketName as BucketUse,pce.UserNeedsToUseBucketId,cnb1.BucketName as BucketNeeduse,MaxTimeAllowedInDays,ROW_NUMBER()over(order by pce.ToUseBucketId) as Row from CNBucketPreConditionedEvent pce join CNPLanBucket cnb on cnb.CNPlanBucketId=pce.ToUseBucketId join CNPLanBucket cnb1 on pce.UserNeedsToUseBucketId=cnb1.CNPlanbucketid where pce.CNPlanDetailsId=@planId
-- 
end
end


--select string_agg(cnb.CNPLanBucketId,',') as CNPlanBucketIds,string_agg(cnb.BucketName,',') as BucketNames,isnull(cnr.WaitingPeriod,0) as WaitingPeriod,cnr.WaitingPeriodType from CNPLanBucketRuleEngine cnr left join CNPLanBucket cnb on cnr.CNPLanBucketId=cnb.CNPLanBucketId where cnr.CNPlanDetailsId=9 group by cnr.WaitingPeriod,cnr.WaitingPeriodType


