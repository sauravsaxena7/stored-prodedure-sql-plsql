select * from Appointment where caseno='HA07042024DHHAEH'
select * from ServiceRefundHistory where AppointmentId=377453
select * from ServiceRefundHistory where AppointmentId=377047
,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,ISNULL(srh.RefundAmount,'')
--  ,RefundId VARCHAR(200) ,RefundRemark varchar(300),RefundAmount Varchar(100)  ,RefundDoneBy varchar(300)     
--RefundId, RefundRemark, RefundAmount  
--left join ServiceRefundHistory srh with(nolock) on apt.AppointmentId=srh.Appointmentid
--uspgetPharmacyMISReport

select * from OPDPaymentDetails where transactionId='HA5554720240227162413'

,CAST(srh.RefundAmount as varchar(300))



select * from LibertyEmpRegistration where policyNo='OPD-HAOPDR00U41-55547'

select * from MemberPlan where memberplanid=6731030