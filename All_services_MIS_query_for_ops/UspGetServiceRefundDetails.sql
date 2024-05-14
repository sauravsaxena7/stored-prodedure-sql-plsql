USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspGetServiceRefundDetails]    Script Date: 4/16/2024 10:21:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [UspGetServiceRefundDetails] 101675
-- [UspGetServiceRefundDetails] 101668
ALTER Procedure [dbo].[UspGetServiceRefundDetails]
@appointmentId int
as 
begin


DECLARE @paymentId nvarchar(300)
DECLARE @transactId nvarchar(300)
DECLARE @paymentStatusid bigint
DECLARE @paymentStatus varchar(100)
DECLARE @RefundedOn datetime
DECLARE @message nvarchar(500)
DECLARE @memberpaymentdetailsId bigint
DECLARE @Status varchar(100)
DECLARE @RefundAmount decimal
DECLARE @RefundInitiatedOn datetime
DECLARE @RefundId varchar(250)
---------------------Query 1-------------------------
 select @RefundId=RazorpayRefundId,@RefundAmount=RefundAmount,@paymentStatus=RefundStatusName,
 @paymentStatusid=RefundStatusId,@RefundedOn=UpdatedDatetime,@RefundInitiatedOn=UpdatedDatetime 
 from ServiceRefundHistory 
 where AppointmentId=@appointmentId
-----------------------------------------------------

---------------------Query 2-------------------------
 select @memberpaymentdetailsId=isnull(MemberPaymentDetailsId,0)
 from MemberPlanDetails where AppointmentId=@appointmentId
-----------------------------------------------------

---------------------Query 3-------------------------
 select @paymentId=api.Paymentid,@transactId=api.TransactionId 
 from MemberPaymentDetails mpd join PaymentGatewayApiLogs api on mpd.TransactionId=api.TransactionId where mpd.MemberPaymentDetailsId=@memberpaymentdetailsId
 -----------------------------------------------------
 
IF (@paymentStatusid = 47)
BEGIN
   PRINT 1
  --SELECT 'Refund is under progress and will be process in 5-7 working days' AS Response,@paymentStatus AS PaymentStatus, 'True' AS Status, 200 AS Subcode, 'SUCCESS' AS Message
  SELECT 'Refund Amount Rs.' + CONVERT(nvarchar(30),@RefundAmount) + '/- has been Initiated on ' + Cast(format((@RefundInitiatedOn),'dd-MM-yyyy HH:mm tt') as nvarchar(250)) + ' and  will be process within 5-7 working days'
   as data,'True' as Status, 200 as Subcode, 'SUCCESS' as Message
END

ELSE IF (@paymentStatusid = 43 AND @RefundAmount IS NOT NULL)
BEGIN
print 2
print @RefundAmount
print @RefundedOn
print @paymentId
print @RefundId
  SELECT 'Amount Rs.' + CONVERT(nvarchar(30),@RefundAmount) + '/- has been refunded on ' + Cast(format((@RefundedOn),'dd-MM-yyyy HH:mm tt') as nvarchar(250)) + ' for PaymentId : ' + @paymentId + ' and RefundId : ' + @RefundId as data,'True' as Status, 200 as Subcode,'SUCCESS' as Message
END
else if(@paymentStatusid = 50)
begin
print 3
  SELECT 'Refunded not yet Initiated. please try after sometime' as data,'True' as Status, 200
  as Subcode,'SUCCESS' as Message  
end
else if(@paymentStatusid = 23)
begin
print 3
  SELECT 'Refunded has been Rejected!' as data,'True' as Status, 200
  as Subcode,'SUCCESS' as Message  
end

ELSE
BEGIN
SELECT NULL AS Response , 'False' AS Status , 500 AS Subcode,'Something Went Wrong !' AS Message
END
end
