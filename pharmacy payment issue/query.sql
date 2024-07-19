select top 1 * from PaymentGatewayApiLogs order by 1 desc
SELECT top 1  * FROM MemberPaymentDetails order by 1 desc

SELECT TOP 1 * FROM UserTransactions order by 1 desc

   
	SELECT ut.PaymentId,
	ut.PaymentOrderId,  
	ut.Message,  
	ut.Status as userTransactionStaus,  
	ut.UpdatedBy,  
	ut.UpdatedDate ,
	ut.TransactionId,
	PGAL.Status as PaymentStatus
	FROM UserTransactions ut  
	JOIN PaymentGatewayApiLogs PGAL on ut.TransactionId=PGAL.TransactionId  
	JOIN ClientMemberDetails C on c.paymenttransid=ut.TransactionId
	WHERE ut.Status='Requested' and PGAL.Status='captured' AND C.Packageid=192	 