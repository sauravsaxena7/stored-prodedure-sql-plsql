USE [HAPortal]
GO
/****** Object:  StoredProcedure [dbo].[UspGetCommonReportScheduler]    Script Date: 11/30/2023 8:12:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: <05/10/2021>
-- exec UspGetCommonReportScheduler 'VideoGraphy'
-- exec UspGetCommonReportScheduler 'LICMIS'
-- exec UspGetCommonReportScheduler 'InstaTele' 
-- exec UspGetCommonReportScheduler 'IPRUMR'
-- exec UspGetCommonReportScheduler 'DCAlgo' 
-- exec UspGetCommonReportScheduler 'CORPORATE'
-- exec UspGetCommonReportScheduler 'MCHIDigi'
-- exec UspGetCommonReportScheduler 'SBIAutoMIS'
--

-- =============================================

ALTER PROCEDURE [dbo].[UspGetCommonReportScheduler]  

 --@Flag int,  
 --@ProviderChainId int = 0,  
 --@Type varchar(100) = null,  
 @reportparameter VARCHAR(MAX)  
AS  
IF (@reportparameter = 'ProviderwiseClosedCases')  
BEGIN  
 exec UspGetProviderClosingCountEmail 2, 9870, 'Provider'  
END

 IF (@reportparameter = 'GETASSUREKAVACHDATA')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ELITE Assure 1 Yr. & Health Kavach 1 Yr data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'ELITE Assure 1 Yr. & Health Kavach 1 Yr. data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETASSUREKAVACHDATA'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[uspAssurKavachdata]


END

 IF (@reportparameter = 'REQUESTEDWISEDATAMIS')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for KPI Metrics -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'KPI Metrics -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='REQUESTEDWISEDATAMIS'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[uspMISReportOPS]


END

 IF (@reportparameter = 'GETTeleConsultsDailyMonitoring')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Tele consults daily monitoring -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Tele consults daily monitoring -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETTeleConsultsDailyMonitoring'

	exec [Haproduct].[dbo].[uspGETTeleConsultsDailyMonitoring]

END


 IF (@reportparameter = 'GetDiagnosticCVFeedback')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Diagnostic service centre visit feedback -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Diagnostic centre visit feeback -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetDiagnosticCVFeedback'

	exec [Haproduct].[dbo].[usp_GetDiagnosticCVFeedback]

END


 IF (@reportparameter = 'GetDiagnosticHVFeedback')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Diagnostic service Home visit feedback -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Diagnostic Home visit feeback -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetDiagnosticHVFeedback'

	exec [Haproduct].[dbo].[usp_GetDiagnosticHVFeedback]

END

 IF (@reportparameter = 'NPSAppDataDetails')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Customer details needed in App NPS Data. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'App NPS Data MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='NPSAppDataDetails'

	exec [Haproduct].[dbo].[usp_NPSAppDataDetails]

END

 IF (@reportparameter = 'GetWhatsAppNPSfeedback')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Customer details needed in WhatsApp NPS feedback . </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 ' WhatsApp NPS feedback MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetWhatsAppNPSfeedback'

	exec [Haproduct].[dbo].[usp_GetWhatsAppNPSfeedback]

END


 IF (@reportparameter = 'GetPharmacyFeedback')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Pharmacy service feedback -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Pharmacy feeback -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetPharmacyFeedback'

	exec [Haproduct].[dbo].[usp_GetDiagnosticPharmacyFeedback]

END


 IF (@reportparameter = 'AceRiderMember')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Ace Rider Member -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Ace Rider Member -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AceRiderMember'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[uspAceRiderDetailsMember]


END


 IF (@reportparameter ='AceRiderDetails')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Ace Rider sales -data MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 ' Ace Rider sales -data Dump MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AceRiderDetails'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[uspAceRiderDetails]


END




 IF (@reportparameter = 'GETHAOPDDIGITALUSERCLAIMSDUMP')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HAOPD-DIGITAL client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- HAOPD-DIGITAL. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETHAOPDDIGITALUSERCLAIMSDUMP'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsHAOPDDigitalReportLive]


END



 IF (@reportparameter = 'GETCASHKAROCLAIMSDUMP')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for CASH KARO client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- CASH KARO. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETCASHKAROCLAIMSDUMP'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsCashKaroReportLive]


END





 IF (@reportparameter = 'GETRENEWBUYCLAIMSDUMP')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RE-NEWBUY client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- RE-NEWBUY. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETRENEWBUYCLAIMSDUMP'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsRenewBuyReportLive]


END


 IF (@reportparameter = 'GETAccentureclientClaimsDUMP')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Accenture client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- Accenture. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETAccentureclientClaimsDUMP'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsAccentureReportLive


END




 IF (@reportparameter = 'GETACEUSERCLAIMSDUMP')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ACE client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- ACE. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETACEUSERCLAIMSDUMP'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsAceReportLive


END


 IF (@reportparameter = 'GETAbhiClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ABHI-Corporate Business client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- ABHI-Corporate Business. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETAbhiClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsABHIReportLive]


END



 IF (@reportparameter = 'GETApexClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for APEX STRATEGIC CONSULTING PVT LTD client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- APEX STRATEGIC CONSULTING PVT LTD. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETApexClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsApexReportLive]


END



 IF (@reportparameter = 'GETMagmaClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Magma HDI GIC-Azbil India Pvt. Ltd client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- Magma HDI GIC-Azbil India Pvt. Ltd. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETMagmaClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsMagmaReportLive]


END


 IF (@reportparameter = 'GETHomeCreditClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Home Credit India Finance Private Limited client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- Home Credit India Finance Private Limited. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETHomeCreditClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsHomeCreditReportLive]


END



 IF (@reportparameter = 'GETMobikwikClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mobikwik client claim MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'CLAIMS MIS- Mobikwik. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETMobikwikClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].[dbo].[usp_GetUserTransactionsMobikwikReportLive]


END







 IF (@reportparameter = 'HAOPDDigitalSalesMIS')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HA OPD Digital client sales MIS Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HA OPD Digital. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HAOPDDigitalSalesMIS'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.UspFetchingHAOPDDigitalSalesMIS


END

IF (@reportparameter = 'GetPharmacyAppointmentCount')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p>Dear All, <br/><br/> Please find attachment for Pharmacy Appointment Count. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	  MailCc,MailFrom,Pass as Description,
	 'Pharmacy Appointment Count Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetPharmacyAppointmentCount'

	
	exec [Haproduct].dbo.uspGetPharmacyCountOfweek 


END


IF (@reportparameter = 'GetProviderwiseDiagnosticAppointmentCount')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p>Dear All, <br/><br/> Please find attachment for Diagnostic Appointment Count. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	  MailCc,MailFrom,Pass as Description,
	 'Diagnostic Appointment Count Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetProviderwiseDiagnosticAppointmentCount'

	
	exec [Haproduct].dbo.uspGetProviderWiseAppointmentCountOfweek


END


 IF (@reportparameter = 'GETReimbursementSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Reimbursement consolidated request raised for today, Please find the attached documents. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Reimbursement consolidated report  Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETReimbursementSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetReimbursementMis


END




 IF (@reportparameter = 'AceUltimaGrandProtect')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ace client Member detail daily MIS -Plan Ultima Grand Protect Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Member detail daily MIS - Ultima Grand Protect data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AceUltimaGrandProtect'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUltimaGrandProtectSummary


END


IF (@reportparameter = 'RenewBuySummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RenewBuy client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- RenewBuy Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RenewBuySummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserRenewBuySummary

END


--------------------5 New Client Sales Mis Data-------------------------------------------------------
IF (@reportparameter = 'GETAccentureSalesSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Accenture client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Accenture Data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETAccentureSalesSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserSalesAccentureSummary

END


IF (@reportparameter = 'GETPlatinumUltimaSurakshaMemberMIS')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Platinum Ultima Suraksha client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Platinum Ultima Suraksha. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GETPlatinumUltimaSurakshaMemberMIS'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_PlatinumUltimaSurakshaMemberMIS

END




IF (@reportparameter = 'GetUserMobikwikUserSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mobikwik client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Mobikwik Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserMobikwikUserSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserMobikwikSummary

END



IF (@reportparameter = 'GetUserMagmaUserSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Magma client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Magma Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserMagmaUserSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserMagmaSummary

END



IF (@reportparameter = 'GetUserHomeCreditUserSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HomeCredit client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HomeCredit Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserHomeCreditUserSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserHomeCreditSummary

END


IF (@reportparameter = 'GetUserAPEXUserSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for APEX client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- APEX Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserAPEXUserSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserAPEXSummary

END

IF (@reportparameter = 'GetUserTATAAIGSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for TATA AIG client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- TATA AIG Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTATAAIGSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTATAAIGSummary

END

IF (@reportparameter = 'StarfinIndiaSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Starfin India client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Starfin India Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='StarfinIndiaSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserStarfinIndiaSummary

END


IF (@reportparameter = 'GetUserABHIUserSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ABHI client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- ABHI Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserABHIUserSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserABHISummary

END
-------------New Summary---------------------------

IF (@reportparameter = 'LoyaltyBonusSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Loyalty Bonus client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Loyalty Bonus Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='LoyaltyBonusSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserLoyaltyBonusSummary

END

IF (@reportparameter = 'OkayCallCentreSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for OkayCall client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- OkayCall Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='OkayCallCentreSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserOkayCallCentreSummary
	   
END


IF (@reportparameter = 'GetUserSaiAdarshSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Sai Adarsh client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Sai Adarsh Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserSaiAdarshSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserSaiAdarshSummary

END

IF (@reportparameter = 'GetUserRAHINIINSURANCESummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RAHINI INSURANCE client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- RAHINI INSURANCE Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserRAHINIINSURANCESummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserRAHINIINSURANCESummary


END

IF (@reportparameter = 'GetUserNathMultistateSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Nath Multistate client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Nath Multistate Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserNathMultistateSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserNathMultistateSummary



END


IF (@reportparameter = 'GetUserInsureMOSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Insure MO client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Insure MO Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserInsureMOSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserInsureMOSummary


END

IF (@reportparameter = 'GetUserHDFCErgoSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HDFC Ergo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HDFC Ergo Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserHDFCErgoSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserHDFCErgoSummary



END



IF (@reportparameter = 'GetUserFinovacapitalSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Finova capital client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Finova capital Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserFinovacapitalSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserFinovacapitalSummary


END




IF (@reportparameter = 'GetUserCCADMultiSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for CCAD Multi client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- CCAD Multi Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserCCADMultiSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserCCADMultiSummary



END

IF (@reportparameter = 'GetUserCapriGlobalSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Capri Global client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Capri Global Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserCapriGlobalSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserCapriGlobalSummary

END


IF (@reportparameter = 'GetUserAVANSEFINANCIALSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for AVANSE FINANCIAL client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- AVANSE FINANCIAL Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserAVANSEFINANCIALSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserAVANSEFINANCIALSummary


END


IF (@reportparameter = 'HealthCareSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Health Care client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Health Care Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HealthCareSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserHealthCareSummary


END



IF (@reportparameter = 'PASRetailsSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for PAS Retails client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- PAS Retails Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PASRetailsSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserPASRetailsSummary


END

IF (@reportparameter = 'PolicyBossSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Policy Boss client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Policy Boss Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PolicyBossSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserPolicyBossSummary


END
IF (@reportparameter = 'ShriMahatmaBasveshwarSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Shri Mahatma Basveshwar client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Shri Mahatma Basveshwar Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ShriMahatmaBasveshwarSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserShriMahatmaBasveshwarSummary


END
IF (@reportparameter = 'ShivPratapMultiStateSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Shiv Pratap MultiState client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Shiv Pratap MultiState Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ShivPratapMultiStateSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserShivPratapMultiStateSummary


END
IF (@reportparameter = 'DeendayalSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Deendayal client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Deendayal Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='DeendayalSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserDeendayalSummary


END
IF (@reportparameter = 'LaturMultistateSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Latur Multistate client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Latur Multistate Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='LaturMultistateSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserLaturMultistateSummary


END
IF (@reportparameter = 'RashtrasantTukadojiSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Rashtrasant Tukadoji client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Rashtrasant Tukadoji Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RashtrasantTukadojiSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserRashtrasantTukadojiSummary


END

IF (@reportparameter = 'KODOLIURBANSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for KODOLI URBAN client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- KODOLI URBAN Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='KODOLIURBANSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserKODOLIURBANSummary 


END

IF (@reportparameter = 'ShreeSiddhivinayakSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Shree Siddhivinayak client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Shree Siddhivinayak Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ShreeSiddhivinayakSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserShreeSiddhivinayakSummary


END

IF (@reportparameter = 'BhagyalaxmiMultistateSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Bhagyalaxmi Multistate client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Bhagyalaxmi Multistate Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='BhagyalaxmiMultistateSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserBhagyalaxmiMultistateSummary


END



----------------New Claims--------------------
IF (@reportparameter = 'ProtiumClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Protium client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Protium client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ProtiumClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsProtiumReportLive


END

IF (@reportparameter = 'GetUserTransactionsStarfinIndia')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Star fin India client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Star fin India client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsStarfinIndia'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsStarfinIndia_ReportLive


END

IF (@reportparameter = 'GetUserTransactionsSaiAdarsh')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Sai Adarsh client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Sai Adarsh client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsSaiAdarsh'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsSaiAdarsh_ReportLive


END


IF (@reportparameter = 'OkayCallCentreClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Okay Call Centre client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Okay Call Centre client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='OkayCallCentreClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsOkayCallCentreReportLive


END

IF (@reportparameter = 'SIDDHIVINAYAKClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for SIDDHIVINAYAK client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- SIDDHIVINAYAK client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='SIDDHIVINAYAKClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsSIDDHIVINAYAKReportLive



END

IF (@reportparameter = 'SHREESIDDHIVINAYAKClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for SHREE SIDDHIVINAYAK client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- SHREE SIDDHIVINAYAK client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='SHREESIDDHIVINAYAKClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsSHREESIDDHIVINAYAKReportLive



END


IF (@reportparameter = 'MAHATMAClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for MAHATMA client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- MAHATMA client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MAHATMAClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsMAHATMAReportLive



END


IF (@reportparameter = 'MAHATMANIYAMITClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for MAHATMA NIYAMIT client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- MAHATMA NIYAMIT client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MAHATMANIYAMITClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsMAHATMANIYAMITReportLive



END


IF (@reportparameter = 'HealthCareClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Health Care client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Health Care client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HealthCareClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsHealthCareReportLive


END


IF (@reportparameter = 'PASRETAILSClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for PAS RETAILS client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- PAS RETAILS client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PASRETAILSClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsPASRETAILSReportLive


END


IF (@reportparameter = 'LoyaltyBonusClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Loyalty Bonus client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Loyalty Bonus client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='LoyaltyBonusClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsLoyaltyBonusReportLive


END


IF (@reportparameter = 'PolicyBossClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Policy Boss client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Policy Boss client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PolicyBossClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsPolicyBossReportLive


END


IF (@reportparameter = 'SHIVPRATAPNAGARIClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for SHIV PRATAP NAGARI client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- SHIV PRATAP NAGARI client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='SHIVPRATAPNAGARIClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsSHIVPRATAPNAGARIReportLive


END


IF (@reportparameter = 'DEENDAYALNAGARIClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for DEENDAYAL NAGARI client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- DEENDAYAL NAGARI client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='DEENDAYALNAGARIClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsDEENDAYALNAGARIReportLive


END


IF (@reportparameter = 'LATURClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for LATUR client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- LATUR client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='LATURClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsLATURReportLive

END


IF (@reportparameter = 'RashtrasantTukadojiClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Rashtrasant Tukadoji client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Rashtrasant Tukadoji client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RashtrasantTukadojiClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsRashtrasantTukadojiReportLive


END


IF (@reportparameter = 'KODOLIURBANClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for KODOLI URBAN client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- KODOLI URBAN client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='KODOLIURBANClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsKODOLIURBANReportLive


END


IF (@reportparameter = 'BhagyalaxmiClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Bhagyalaxmi client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Bhagyalaxmi client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='BhagyalaxmiClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsBhagyalaxmiReportLive


END

IF (@reportparameter = 'GetUserTransactionsRAHINIINSURANCE')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RAHINI INSURANCE client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- RAHINI INSURANCE client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsRAHINIINSURANCE'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsBhagyalaxmiReportLive


END

IF (@reportparameter = 'GetUserTransactionsHDFCErgo')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HDFC Ergo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- HDFC Ergo client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsHDFCErgo'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsHDFCErgo_ReportLive


END

-----------------

/***********************added by atul 28-06-2023************************************/

IF (@reportparameter = 'HAOPDDigitalSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HAOPD-Digital client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HAOPD-Digital client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HAOPDDigitalSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserHAOPD-DigitalSummary]

END


IF (@reportparameter = 'MagmaSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Magma client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Magma client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MagmaSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserMagmaSummary]
END


IF (@reportparameter = 'AuxiloSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Auxilo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Auxilo client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AuxiloSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserAuxiloSummary]
END


IF (@reportparameter = 'MswipeSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mswipe client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Mswipe client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MswipeSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserMswipeSummary]
END

IF (@reportparameter = 'ProtiumSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Protium client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Protium client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ProtiumSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserProtiumSummary]
END

IF (@reportparameter = 'RepublicSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Republic services client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Republic services client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RepublicSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserRepblicSummary]
END


IF (@reportparameter = 'ColorCodeSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ColorCode client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- ColorCode client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ColorCodeSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserColorCodeSummary]
END


IF (@reportparameter = 'SvastiSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Svasti Microfinance client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Svasti Microfinance client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='SvastiSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserSvastiSummary]
END


IF (@reportparameter = 'HDBSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HDB Financial Services client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HDB Financial Services client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HDBSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserHDBSummary]
END



IF (@reportparameter = 'PayworldSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Payworld client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Payworld client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PayworldSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserPAYWORLDSummary]
END

IF (@reportparameter = 'GIBLSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for GIBL client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- GIBL client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GIBLSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserGIBLSummary]
END


IF (@reportparameter = 'EBIXSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for EBIX client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- EBIX client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='EBIXSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserEBIXSummary]
END


IF (@reportparameter = 'NEURONLIFESCIENCESummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for NEURON LIFESCIENCE client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- NEURON LIFESCIENCE client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='NEURONLIFESCIENCESummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserNEURONLIFESCIENCESummary]
END


IF (@reportparameter = 'FastHealthSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for FAST HEALTH client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- FAST HEALTH client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='FastHealthSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserFastHealthSummary]
END

IF (@reportparameter = 'NineRootSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Nineroot Technologies Pvt Limited client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Nineroot Technologies Pvt Limited client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='NineRootSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserNineRootSummary]
END

IF (@reportparameter = 'CareHealthSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Care Health Insurance ltd client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Care Health Insurance ltd client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='CareHealthSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserCareHealthSummary]
END


IF (@reportparameter = 'TurtlemintSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Turtlemint client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Turtlemint client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='TurtlemintSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserTurtlemintSummary]
END

	 IF (@reportparameter = 'CashkaroSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Cash-Karo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Cash-Karo client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='CashkaroSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserCashkaroSummary]
END


 IF (@reportparameter = 'AceSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Ace client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Ace client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AceSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserACESummary]
END


IF (@reportparameter = 'ApexSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for APEX client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- APEX client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ApexSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserAPEXSummary

END



IF (@reportparameter = 'ABHISummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ABHI client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- ABHI client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ABHISummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserABHISummary

END

IF (@reportparameter = 'HomeCreditSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HomeCredit client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- HomeCredit data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HomeCreditSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserHomeCreditSummary

END


IF (@reportparameter = 'MobikwikSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mobikwik client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- Mobikwik Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MobikwikSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserMobikwikSummary

END


IF (@reportparameter = 'AccentureSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find the attachment for Accenture client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Accenture client Onboarding & Booking Details report data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AccentureSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserAccentureSummary

END


IF (@reportparameter = 'IndiaGoldSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for India Gold client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- India Gold client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='IndiaGoldSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserIndiaGoldSummary]
END


IF (@reportparameter = 'RenewSummary')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RenewBuy client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Sales MIS- RenewBuy client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RenewSummary'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.[usp_GetUserRenewBuySummary]
END


IF (@reportparameter = 'HAOPDDigitalClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HAOPD-Digital client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- HAOPD-Digital client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HAOPDDigitalClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsHAOPDDigitalReportLive

END


IF (@reportparameter = 'MagmaClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Magma client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Magma client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MagmaClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsMagmaReportLive

END

IF (@reportparameter = 'AuxiloClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Auxilo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Auxilo client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AuxiloClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsAuxiloReportLive

END

IF (@reportparameter = 'MswipeClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mswipe client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Mswipe client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='MswipeClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsMswipeReportLive

END


IF (@reportparameter = 'RepublicClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Republic services client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Republic services client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RepublicClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsRepublicReportLive

END

IF (@reportparameter = 'ColorCodeClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ColorCode client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- ColorCode client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ColorCodeClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsColorCodeReportLive

END

IF (@reportparameter = 'SvastiClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Svasti Microfinance client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Svasti Microfinance client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='SvastiClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsSvastiReportLive

END

IF (@reportparameter = 'HDBClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HDB Financial Services client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- HDB Financial Services client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='HDBClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsHDBReportLive
END

IF (@reportparameter = 'PayworldClaims')
BEGIN
		SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Payworld client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Payworld client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='PayworldClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsPayworldReportLive
END

IF (@reportparameter = 'GIBLClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for GIBL client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- GIBL client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GIBLClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsGIBLReportLive

END

IF (@reportparameter = 'EBIXClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for EBIX client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- EBIX client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='EBIXClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsEBIXReportLive

END

IF (@reportparameter = 'NEURONLIFESCIENCEClaims')

BEGIN	
        SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for NEURON LIFESCIENCE client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- NEURON LIFESCIENCE client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='NEURONLIFESCIENCEClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsNEURONLIFESCIENCEReportLive

END


IF (@reportparameter = 'FastHealthClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for FAST HEALTH client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- FAST HEALTH client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='FastHealthClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsFastHealthReportLive

END


IF (@reportparameter = 'NineRootClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Nineroot Technologies Pvt Limited client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Nineroot Technologies Pvt Limited client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler

	 where ReportType='NineRootClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsNineRootReportLive

END


IF (@reportparameter = 'CareHealthClaims')
BEGIN
		SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Care Health Insurance ltd client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Care Health Insurance ltd client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='CareHealthClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsCAREHealthReportLive

END

IF (@reportparameter = 'GetUserTransactionsInsureMO')
BEGIN
		SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for InsureMO client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- InsureMO client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsInsureMO'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsInsureMO_ReportLive


END



IF (@reportparameter = 'TurtlemintClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Turtlemint client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Turtlemint client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='TurtlemintClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsTurtlemintReportLive

END



IF (@reportparameter = 'CashkaroClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Cash-Karo client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Cash-Karo client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='CashkaroClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsCashKaroReportLive

END



IF (@reportparameter = 'AceClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Ace client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Ace client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AceClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsAceReportLive
END



IF (@reportparameter = 'MobikwikClaims')
BEGIN
        SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for Mobikwik client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- Mobikwik Health Wellness Plans data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler

	 where ReportType='MobikwikClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsMobikwikReportLive

END



IF (@reportparameter = 'AcentureClaims')
BEGIN
        SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find the attachment for Accenture client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims Accenture client Onboarding & Booking Details report data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='AcentureClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsAccentureReportLive

END




IF (@reportparameter = 'ApexClaims')
BEGIN
         SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for APEX client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- APEX client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ApexClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsApexReportLive

END

IF (@reportparameter = 'GetUserTransactionsTATAAIG')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for TATA AIG client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- TATA AIG client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsTATAAIG'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsTATAAIG_ReportLive


END

IF (@reportparameter = 'GetUserTransactionsCCADMulti')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for CCAD Multi client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- CCAD Multi client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetUserTransactionsCCADMulti'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsCCADMulti_ReportLive


END


IF (@reportparameter = 'ABHIClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for ABHI client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- ABHI client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='ABHIClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsABHIReportLive

END



IF (@reportparameter = 'HomeCreditClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for HomeCredit client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- HomeCredit client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler

	 where ReportType='HomeCreditClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsHomeCreditReportLive

END



IF (@reportparameter = 'IndiaGoldClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for India Gold client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- India Gold client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='IndiaGoldClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsIndiaGoldReportLive

END



IF (@reportparameter = 'RenewClaims')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find attachment for RenewBuy client Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Claims MIS- RenewBuy client data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='RenewClaims'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserTransactionsRenewBuyReportLive

END





/***************************End Atul Code*************************************************/
-----------------------------------------------------------------------------



IF (@reportparameter = 'OnBoardingCashkaro')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find the attachment for Cashkaro client sales Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Cashkaro client sales report data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='OnBoardingCashkaro'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserOnboardedCashkaroSales

END

IF (@reportparameter = 'OnBoarding')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:19px;">Dear All, <br/><br/> Please find the attachment for All client onboarded incremental Report. </p><br/><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'All client onboarded incremental data. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='OnBoarding'

	--SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	exec [Haproduct].dbo.usp_GetUserOnboardedSummary

END


IF (@reportparameter = 'TEST')
BEGIN
	SELECT TOP 1 '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent,'sajiel.kutti@healthassure.in' MailTo,
	'hemant.chavan@healthassure.in' MailCc,'servicepartner@healthassure.in' MailFrom,'Max@2023' as Description,
	 'Test Mail from HealthAssure. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler WHERE ReportType = 'TEST'

	SELECT 'Test1' AS Tab1 ,'Test2' AS Tab2,'Test3' AS Tab3
	--exec [SBILifeRegionalMIS] 60,NULL,NULl,1,24

END


IF (@reportparameter = 'SCHEDULERAPPRESTART')
BEGIN
	
	SELECT TOP 1 '<br /><b>Hello team,</b><br /><p><b> Because of some reason Task Scheduler Application is suddenly stopped and restarted. Please check once.. </b></p>'  as TemplateContent, MailTo AS MailTo,
	MailCC AS MailCc, MailFrom AS MailFrom, Pass as Description,
	 'Scheduler Application Restarted. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler WHERE ReportType = 'SCHEDULERAPPRESTART'

END


IF (@reportparameter = 'MDRA')  
BEGIN  
 exec UspMDRAReport
END

IF (@reportparameter = 'NivaDash')  
BEGIN  
 exec UspNivaBupaDashboard
END

IF (@reportparameter = 'NivaMIS')  
BEGIN  
 exec UspNivaBupaMIS
END


IF(@reportparameter = 'NivaBupaNPS')
BEGIN

	EXEC UspNivaBupaNPS
END

IF (@reportparameter='DCAlgo')
BEGIN
	EXEC UspGetDCAlgoData
END

ELSE IF(@reportparameter='KOTAK_TAT')
BEGIN
declare @clientid bigint, @ReportSchedulerID bigint,@Fromdate datetime, @Interval bigint, @Enddate datetime
set @Fromdate = DATEADD(month, -3, GETDATE())
set @Enddate = convert(date,getdate())
 
select '<br /><br /><table ><p style = "font-size:20px;"> Please find attached MIS Report. </p>'  as TemplateContent, MailTo, MailCc, MailFrom, Pass as Description,
'KOTAK_TAT ' + CONVERT(VARCHAR(11),@Fromdate,113) + ' to ' + CONVERT(VARCHAR(11),@Enddate,113)  as Subject,* from ReportScheduler 
where  ReportType = 'KOTAKTAT'
print @ReportSchedulerID

exec uspKotakLifeInsuranceProposerMIS @Fromdate, @Enddate, 49, -1, 'R' , @ReportSchedulerID
END

IF(@reportparameter='SBIAutoMISCount')
BEGIN
select * from ReportScheduler where ReportType = 'AUTOMIS'and ReportTime='10:15:00.0000000' --between Convert(Time(0), GETDATE()) and Convert(Time(0), DATEADD(MINUTE,15, getdate()))
END


IF (@reportparameter = 'AUTOCLOSEDCNT')  
BEGIN  
 exec UspGetReportAutoCloseDetails
END

IF (@reportparameter = 'CignaAUTOMIS')
BEGIN
	--Commented by saurabh on 10/07/23 for HPCR-349
	--EXEC UspManipalCignaAutoMIS 
	print 0
END

--Addedby saurabh on 23/06/23
--This is both Prime & Non-Prime MIS
IF (@reportparameter = 'CIGNANONPRIMEMIS')
BEGIN
	EXEC uspCignaAHCNonPrimeTrigger 

END
--ended

--Added By Hemant Chavan on Date 28-11-2022

IF (@reportparameter = 'BAGICSTATUS')
BEGIN
	EXEC BajajDigitalCasesReport 
END

IF (@reportparameter = 'SBITelanganaMIS')
BEGIN
	EXEC SBITelanganaMIS 
END

IF (@reportparameter = 'MCHIWeekWiseData')
BEGIN
	exec USPGetMCHIPPHCDigitizedCases 'WeekWiseData' 
END

IF (@reportparameter = 'MCHIMonthWiseData')
BEGIN
	exec USPGetMCHIPPHCDigitizedCases 'MonthWiseData' 
END
IF (@reportparameter = 'AutoInstaTele')
BEGIN
	EXEC AutomateInstaTeleReport 
END
IF (@reportparameter = 'CustomRelianceMIS')
BEGIN
	EXEC CustomRelianceMIS 
END
IF (@reportparameter = 'CignaTeleDashbord')
BEGIN
	EXEC [dbo].[CignaTeleDashbord] 
END

--Added By Hemant Chavan on Date 28-11-2022

IF (@reportparameter = 'IPRUPHOTO')
BEGIN
	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	MailCc, MailFrom, Pass as Description,
	'IPRU Report. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'IPRUMR'

	select a.PolicyRefNo,case when SendFlag ='Y' then 'No' else 'Yes' end SendFlag,convert(varchar,FlagUpdatedDateTime,103) SendFdate,b.Remark  from Appointment a
	left join IpruTempreportdata b on a.AppointmentId = b.AppointmentId
	where a.ClientId = 32 and AppointmentStatusId = 17 and convert(date,a.UpdatedDateTime,103)=convert(date,getdate(),103) and SendFlag is not null
	
END
IF (@reportparameter = 'TeleDigiKT')
BEGIN
	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	MailCc, MailFrom, Pass as Description,
	'Kotak Digitization Report. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'TeleDigiKT'

	exec uspTeleDigitization 49
END

IF (@reportparameter = 'InstaTele')
BEGIN
	EXEC UspInstaTele	
END

IF (@reportparameter = 'VideoGraphy')
BEGIN
	EXEC UspVideographyReport
END

IF (@reportparameter = 'IPRUMIS')
BEGIN
	EXEC  uspIPRUAutoMailProposerMIS
END


IF (@reportparameter = 'VGSUMMARY')
BEGIN
	EXEC UspVideographyMgnSummary
END

IF (@reportparameter = 'SBILIFEDASH')
BEGIN
	EXEC UspSBILifeOverallMISDashboard
END

IF (@reportparameter = 'SBIAutoMIS')  
BEGIN 

select @clientid = rs.ClientId, @ReportSchedulerID = rs.ReportSchedulerID,  @Interval = rs.ReportInterval from ReportScheduler rs
left join ReportSchedulerLog rsl on rs.ReportSchedulerID = rsl.ReportSchedulerID
and rsl.ReportDatetime >= DATEADD(HOUR,-4,GETDATE())
and rsl.ReportDatetime < dateadd(day,1,convert(date,getdate()) ) and rsl.EmailStatus = 'Y'
where  rs.ReportType='AUTOMIS' and rsl.ReportSchedulerID is  null
order by rs.ReportSchedulerID

exec SBILifeRegionalMIS @clientid,NULL,NULL,4,@ReportSchedulerID
END 

IF (@reportparameter = 'DRPRODUCT')
BEGIN
	EXEC uspTeleDoctorProductivityDataAutoMIS
END

IF (@reportparameter = 'CLOSECASE')
BEGIN
	declare @strtDate varchar(20); 
	declare @EdDate varchar(20);
	set @strtDate = CONVERT(varchar,GETDATE()-1,103)
	
	set @EdDate = CONVERT(varchar,GETDATE(),103)
	
	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'PPHC closed cases '+ CONVERT(VARCHAR(11),GETDATE()-1,113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'CLOSECASE'

	EXEC [dbo].[uspProposerGenericMIS] @strtDate, @EdDate, 0, 17, 'S',12
END

IF (@reportparameter = 'TATAWALOG')
BEGIN

	EXEC [dbo].[TATAWhatsAppLogData]
END
IF (@reportparameter = 'ManipalAHC')
BEGIN
	
	--SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent,
	----'achyutanand.khuntia@healthassure.in' MailTo,
	--'sujit.pillai@healthassure.in' MailTo,
	-- 'satish.prabhu@healthassure.in,sarang.nair@healthassure.in' MailCc,'Report@healthassure.in' MailFrom, 'Health@1234' as Description,
	--'Daily Cases Details . Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Daily Cases Details . Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'ManipalAHC'

	EXEC [dbo].[uspManipalCignaAHC] 
END

IF (@reportparameter = 'LICMIS')
BEGIN
	--EXEC [dbo].[LICTargetMIS] 
	EXEC [dbo].[LICBusinessTracker]
END

IF (@reportparameter = 'LICOUTLIERMIS')
BEGIN
	Select Top 1
	ReportSchedulerID,
	ClientId,
	ReportType,
	MailTo,
	MailCC,
	MailFrom,
	Pass
	From ReportScheduler
	where ReportType = 'LICOUTLIERMIS' AND IsActive = 'Y'
END

IF (@reportparameter = 'FUTUREHEALTHMIS')
BEGIN
	declare @starDate varchar(20); 
	declare @enDate varchar(20);
	set @starDate = dateadd(day, -30, getdate())
	set @enDate = GETDATE()
	

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Future Generali India Health Insurance MIS report '+ CONVERT(VARCHAR(11),GETDATE(),113)+'  '+ LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) as Subject,* from ReportScheduler 
	WHERE ReportType = 'FUTUREHEALTHMIS'

	EXEC [dbo].[uspTeleProposerMIS] 72, @starDate, @enDate
	
END

IF (@reportparameter = 'FGHITATMIS')
BEGIN
	EXEC FutureGeneraliMISForTATDetails;
END

IF (@reportparameter = 'NIVABUPAMIS')
BEGIN
	Select Top 1
	ReportSchedulerID,
	ClientId,
	ReportType,
	'sujit.pillai@healthassure.in,sajiel.kutti@healthassure.in' MailTo,
	'pritam.shegde@healthassure.in' MailCC,
	MailFrom,
	Pass
	From ReportScheduler
	where ReportType = 'NIVABUPAMIS' AND IsActive = 'Y'
END

IF (@reportparameter = 'HDFCTeleMIS')
BEGIN
	Select Top 1
	ReportSchedulerID,
	ClientId,
	ReportType,
	'hemant.chavan@healthassure.in' MailTo,
	'sajiel.kutti@healthassure.in' MailCC,
	MailFrom,
	Pass
	From ReportScheduler
	where ReportType = 'HDFCTeleMIS' AND IsActive = 'Y'
END

IF (@reportparameter = 'RETAIL')
BEGIN
	
	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Retail Closed cases – '+ CONVERT(VARCHAR(11),GETDATE()-1,113)+'  '+ LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) as Subject,* from ReportScheduler 
	WHERE ReportType = 'RETAIL'

	exec HAProduct.[dbo].[uspgetMISReport_Closecase] 'RETAIL'
	
END

IF (@reportparameter = 'CORPORATE')
BEGIN
     
    DECLARE @Yesterday varchar(30),@Today varchar(30)
	SET @Yesterday = CONVERT(varchar(10), GETDATE()-1, 120)
    SET @Today = CONVERT(varchar(10), GETDATE(), 120)
	declare @strtDate5 varchar(20); 
	declare @EdDate5 varchar(20);
	set @strtDate5 = CONVERT(datetime, @Yesterday + ' 12:00:00', 120)
	set @EdDate5 = CONVERT(datetime, @Yesterday + ' 23:30:00', 120)

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Corporate Closed cases – '+ CONVERT(VARCHAR(11),GETDATE()-1,113)+'  '+ LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) as Subject,* from ReportScheduler 
	WHERE ReportType = 'CORPORATE'

	exec HAProduct.[dbo].[uspgetMISReport_Product_backup 28-12-22] 0, @strtDate5, @EdDate5,0,'1',774899,-1
	
END

IF (@reportparameter = 'MagmaTeleMIS')
BEGIN
	EXEC uspMagmaTeleMIS 
END

IF (@reportparameter = 'KOTAKTELEMIS')
BEGIN
	EXEC [dbo].[TeleMIS_CaseStatusCount] 49,'KOTAKTELEMIS' 
END

IF (@reportparameter = 'ABSLITELEMIS')
BEGIN
	EXEC [dbo].[TeleMIS_CaseStatusCount] 26,'ABSLITELEMIS' 
END

IF (@reportparameter = 'SUNDAY')
BEGIN
	EXEC [SundayCallingCHSBC]
END

IF (@reportparameter = 'MAGMACLOSE')
BEGIN

     SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Magma Closed Cases Tele (05:30 PM-10:00 AM)'+ CONVERT(VARCHAR(11),GETDATE()-1,113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'MAGMACLOSE'

	 exec [uspTeleProposerMIS_MagmaClosedCase] 56,'MTEN'
END

IF (@reportparameter = 'MAGMACLOSEA')
BEGIN

     SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Magma Closed Cases Tele (10:00 AM-02:00 PM)'+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'MAGMACLOSEA'

	 exec [uspTeleProposerMIS_MagmaClosedCase] 56,'ATWO'
END

IF (@reportparameter = 'MAGMACLOSEE')
BEGIN

     SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Magma Closed Cases Tele (02:00 PM-05:30 PM)'+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'MAGMACLOSEE'

	 exec [uspTeleProposerMIS_MagmaClosedCase] 56,'EFIVEHALF'
END

IF (@reportparameter = 'MAGMACLOSEN')
BEGIN

     SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Magma Closed Cases Tele (12:00 AM-10:00 PM)'+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'MAGMACLOSEN'

	 exec [uspTeleProposerMIS_MagmaClosedCase] 56,'NTEN'
END

-- ADDED BY RAJ GUPTA

IF (@reportparameter = 'GEOTAGDETAILS')
BEGIN
	EXEC uspGetGeoTagData
END

IF (@reportparameter = 'COMBITELEMIS')
BEGIN
	declare @starDate1 varchar(20); 
	declare @enDate1 varchar(20);
	set @starDate1 = dateadd(day, -60, getdate())
	set @enDate1 = GETDATE()
	

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'HDFC ERGO COMBI PRODUCT Tele MIS report (09:00PM) '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'COMBITELEMIS'

	EXEC [dbo].[uspHDFCTeleProposerMIS] 54, @starDate1, @enDate1,null
	
END

IF (@reportparameter = 'HDFCTWO')
BEGIN
	declare @starDate2 varchar(20); 
	declare @enDate2 varchar(20);
	set @starDate2 = dateadd(day, -60, getdate())
	set @enDate2 = GETDATE()
	

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'HDFC ERGO Genereal Insurance Tele MIS report (02:00PM) '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'HDFCTWO'

	EXEC [dbo].[uspHDFCTeleProposerMIS] 9, @starDate2, @enDate2,'two'
	
END

IF (@reportparameter = 'HDFCNINE')
BEGIN
	declare @starDate3 varchar(20); 
	declare @enDate3 varchar(20);
	set @starDate3 = dateadd(day, -60, getdate())
	set @enDate3 = GETDATE()
	

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'HDFC ERGO Genereal Insurance Tele MIS report (09:50PM) '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,* from ReportScheduler 
	WHERE ReportType = 'HDFCNINE'

	EXEC [dbo].[uspHDFCTeleProposerMIS] 9, @starDate3, @enDate3,'ninefif'
	
END

IF (@reportparameter = 'CANARATWOHR')
BEGIN
	declare @beginDate varchar(20); 
	declare @endDate1 varchar(20);
	--set @beginDate = DATEADD(Hour, -2, GETDATE())
	--set @endDate1 = GETDATE()
	set @beginDate = dateadd(day, -90, getdate())
	set @endDate1 = GETDATE()
	

	SELECT '<br /><br /><table ><p style = "font-size:20px;"> Please find attached Report. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'Canara HSBC Life Insurance Company Limited MIS report '+ CONVERT(VARCHAR(11),GETDATE(),113)+'  '+ LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) as Subject,* from ReportScheduler 
	WHERE ReportType = 'CANARATWOHR'

	EXEC CanaraAutoMISTWOHours 74,@beginDate,@endDate1,92,'',''
	
END
-- Added By Raj On 01/03/2023
IF (@reportparameter = 'PROVIDERMISEMAILTEMPLATE')  
BEGIN  
 exec [dbo].[uspProviderMISBulkEmail] 29,'Royal Sundaram General Insurance Co Ltd - MSP'
END

IF (@reportparameter = 'GetDedupeDataOfPolicyData')
BEGIN
	SELECT TOP 1 
	'<br /><br /><table >Dear All, <br/><br/><p> Please find attachment for Deduplication MIS Report. </p><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Deduplication Policies MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetDedupeDataOfPolicyData'

	
	exec [Haproduct].[dbo].[USPGETDedupeDataOfPolicyDailyData] 'GetDedupeDataOfPolicyData';


END

IF (@reportparameter = 'GetSinglePolicyData')
BEGIN
	SELECT TOP 1 
	'<br /><br /><table >Dear All, <br/><br/><p> Please find attachment for Single Policy MIS Report. </p><br/> Thanks & Regards,<br/> Healthassure Team.'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Single Policy MIS-. Date: '+ CONVERT(VARCHAR(11),GETDATE(),113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType='GetSinglePolicyData'

	
	exec [Haproduct].[dbo].[USPGETDeDuplictionAndSinglePlanData] 'GetSinglePolicyData';


END

-- Added By Samadhan On 29/03/2023
IF (@reportparameter = 'TagicLogFile')  
BEGIN  
 SELECT '<br /><br /><table >Dear All, <br/><br/><p style = "font-size:20px;"> Please find attached Request-Responce Files. </p>'  as TemplateContent, MailTo,
	 MailCc, MailFrom, Pass as Description,
	'TATA AIG - Request-Response Log File - ' + CONVERT(VARCHAR(11),GETDATE(),113)  as Subject,* from ReportScheduler 
	WHERE ReportType = 'TagicLogFile'
END

IF (@reportparameter = 'IBUDAILYREPORT')
BEGIN
	Select Top 1
	ReportSchedulerID,
	ReportType,
	MailTo,
	MailCC,
	MailFrom,
	Pass,
	'IBU Automation Report - MTD' as Subject
	From ReportScheduler
	where ReportType = 'IBUDAILYREPORT' AND IsActive = 'Y'
END

IF (@reportparameter = 'PPMCHR')
BEGIN
	
	exec UspPPMCHealthReport


END
IF (@reportparameter = 'IBUProviderRejectNoActionReport')
BEGIN
	Select Top 1
	ReportSchedulerID,
	ReportType,
	MailTo,
	MailCC,
	MailFrom,
	Pass,
	'IBU Provider Reject & NoAction Report - MTD' as Subject,
	'Hi, <br/> Please find attached report. <br/><br/>Regards,<br/>HealthAssure' as MailBody
	From ReportScheduler
	where ReportType = 'IBUProviderRejectNoActionReport' AND IsActive = 'Y'
END
--Added by sayali for HPCR-360 on 11aug2023


IF (@reportparameter = 'QCMISReport')
BEGIN
	SELECT TOP 1 
	'Hi, <br/><br/> Please find the attached QC MIS data for Report on Hold, QC Completed and closed cases from yesterday.
     <br/><br/>Regards,<br/>HealthAssure'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'QC MIS for '+ CONVERT(VARCHAR(11),GETDATE()-1,113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType= 'QCMISReport'

	
	exec [dbo].[uspQCMISReport] ;

END



--Added by Rohan
IF (@reportparameter = 'MCHIDigi')
BEGIN
	
	exec [dbo].[UspMCHIDigitizationMIS] ;

END

IF (@reportparameter = 'CHSBCDigitalReportData')
BEGIN
	
	exec [dbo].[uspGetCHSBCDigitalValueMISEveryDay] ;

END

IF (@reportparameter = 'KLICloseMIS') --Added by Sajiel on 23-10-2023
BEGIN

	DECLARE @Fdt varchar(10)= FORMAT(DATEADD(DAY,-1,GETDATE()),'dd/MM/yyyy'), 
			@Tdt varchar(10) = FORMAT(DATEADD(DAY,-1,GETDATE()),'dd/MM/yyyy')

	exec  [uspCLosedCasesTestWise] 49, @Fdt, @Tdt ; 

END

IF (@reportparameter = 'ABHITeleMIS') --Added by Sajiel on 16-11-2023
BEGIN

	EXEC [UspDataConversionMisABHI];

END

IF (@reportparameter = 'CIGNAFAILPASS')
BEGIN
	SELECT TOP 1 
	'Hi Team, <br/><br/> Please find the attached data. <br/>'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'MCHI - Digital values Passed/Failed Report '+ CONVERT(VARCHAR(11),GETDATE()-1,113) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType= 'CIGNAFAILPASS'
 
	
	exec [dbo].[uspCignaDigitizationFailPassData] ;
 
END

--ADDED BY SAURAV SUMAN DATE 27-11-2023 START---
IF (@reportparameter = 'TODAY_DOCTOR_CREATION_REPORT')
BEGIN
	SELECT TOP 1 
	'Hi, <br/><br/> Notification for doctor  of new onboarding Please Find Attachement Or Data Below.
<br/><br/>Regards,<br/>HealthAssure'  as TemplateContent, MailTo,
	MailCc,MailFrom,Pass as Description,
	 'Doctor Report For Date '+ cast(cast(getdate()-1 as datetime) AS VARCHAR(30)) as Subject,ReportSchedulerID,ReportType from ReportScheduler
	 where ReportType= 'TODAY_DOCTOR_CREATION_REPORT'
 
	
	exec [HAModule].[tele_consultaion].[Todays_Creation_Count_Of_Doctor] ;
 
END
--END BY SAURAV SUMAN DATE 27-11-2023 END---

-- Aditya 
IF (@reportparameter = 'NBAHCNPSSurveyReportData')
BEGIN
	exec [dbo].[uspGetNBAHCSurveyLinkMISdetails] ;
 
END
