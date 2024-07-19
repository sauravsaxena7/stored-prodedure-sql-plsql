USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspPharmacyPaymentScheduler]    Script Date: 5/14/2024 5:48:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  AKASH KUMAR  
-- Create date: 15-Feb-2023  
-- Description: Re-Run Registration For Faild  
-- =============================================  
ALTER PROCEDURE [dbo].[uspPharmacyPaymentScheduler]   
 @TotalExecutionCount INT=0  
AS  
BEGIN  
  
   DECLARE @CurrentExecutionCount INT=0,@CurrentDate DATETIME=GETDATE()  
   DECLARE @Userloginid BIGINT,@memberid BIGINT,@memberplanID BIGINT,@RefID Varchar(50),@TransctionID Varchar(50)
/****************************End DECLARE VARIABLES*********************************/   
  
-------------------------------------------------------------------------  
-------------------------------------------------------------------------  
  
/****************************For Payment Success in medpay pharmacy*********************************/  
 BEGIN TRY  
	UPDATE MPD  
	SET MPD.RefId=PGAL.paymentId,  
	MPD.RazorPayOrderId=PGAL.PaymentOrderId,  
	MPD.Message='Appointment Booking Success from Razorpay Webhook API',  
	MPD.Status='Success',  
	MPD.UpdatedBy='RazorPay',  
	MPD.UpdatedDate=GETDATE()  
	FROM MemberPaymentDetails MPD  
	JOIN PaymentGatewayApiLogs PGAL on MPD.TransactionId=PGAL.TransactionId  
	JOIN ClientMemberDetails C on c.paymenttransid=MPD.TransactionId
	WHERE MPD.Status='Requested' and PGAL.Status='captured' AND C.Packageid=192	  

	SELECT  mpd.UserLoginId,c.memberid,mpd.MemberPlanId,mpd.RefId,mpd.TransactionId 
	INTO #Temp1 from MemberPaymentDetails MPD  
	JOIN PaymentGatewayApiLogs PGAL on MPD.TransactionId=PGAL.TransactionId  
	JOIN ClientMemberDetails c on c.paymenttransid=MPD.TransactionId
	WHERE MPD.Status='Requested' and PGAL.Status='captured' and C.Packageid<>192 
	group by mpd.UserLoginId,c.memberid,mpd.MemberPlanId,mpd.RefId,mpd.TransactionId
	
	INSERT #Temp1(UserLoginId,memberid,MemberPlanId,RefId,TransactionId)
	SELECT  mpd.UserLoginId,c.memberid,mpd.MemberPlanId,mpd.RefId,mpd.TransactionId  from MemberPaymentDetails MPD  
	JOIN PaymentGatewayApiLogs PGAL on MPD.TransactionId=PGAL.TransactionId  
	JOIN ClientAnonymousbookingDetails c on c.paymenttransid=MPD.TransactionId
	WHERE MPD.Status='Requested' and PGAL.Status='captured' and C.Packageid<>192 group by mpd.UserLoginId,c.memberid,mpd.MemberPlanId,mpd.RefId,mpd.TransactionId

	DECLARE PaymentDetailsCursor CURSOR FOR
	SELECT UserLoginId,memberid,MemberPlanId,RefId,TransactionId FROM #Temp1

	OPEN PaymentDetailsCursor;
	FETCH NEXT FROM PaymentDetailsCursor INTO @Userloginid ,@memberid ,@memberplanID ,@RefID ,@TransctionID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC UspAppointmentBookingEcom   @UserLoginId =@Userloginid, @MemberId =@memberid,@MemberPlanId = @memberplanID,@ModeOfPayment  = 'ONLINE',@PaymentStatus  = 'Success',@TransactionId  = @TransctionID,                           
		@PaymentMessage  = 'Payment Success',@RefId  = @RefID,@NeedToDirectBook ='N'  
    
		FETCH NEXT FROM PaymentDetailsCursor INTO @Userloginid ,@memberid ,@memberplanID ,@RefID ,@TransctionID;
	END



	---ADDED BY SAURAV SUMAN----
	--THIS FOR BOOKING IN NEW PLAN REFACTORING FOR ONLY 192--
	    UPDATE ut  
	    SET ut.PaymentId=PGAL.paymentId,  
	    ut.PaymentOrderId=PGAL.PaymentOrderId,  
	    ut.Message='Appointment Booking Success from Razorpay Webhook API',  
	    ut.Status='Success',  
	    ut.UpdatedBy='RazorPay',  
	    ut.UpdatedDate=GETDATE()  
	    FROM UserTransactions ut  
	    JOIN PaymentGatewayApiLogs PGAL on ut.TransactionId=PGAL.TransactionId  
	    JOIN ClientMemberDetails C on c.paymenttransid=ut.TransactionId
	    WHERE ut.Status='Requested' and PGAL.Status='captured' AND C.Packageid=192	 
	--ADDED BY SAURAV SUMAN-----

 END TRY  
 BEGIN CATCH    
       PRINT ERROR_MESSAGE()  
 END CATCH    
/****************************For Payment Success in medpay pharmacy*********************************/  
  
 
  
END  