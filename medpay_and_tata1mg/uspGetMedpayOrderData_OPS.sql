USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspGetMedpayOrderData_OPS]    Script Date: 6/20/2024 6:15:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- exec [uspGetMedpayOrderData_OPS] 'HA30012024BACIFI'
ALTER PROCEDURE [dbo].[uspGetMedpayOrderData_OPS]      
   @CaseNo varchar(100)         
AS         
BEGIN        
 SET NOCOUNT ON;        
  Declare @AppointmentId bigint;      
  Declare @memberId bigint;      
  DECLARE @scheduleStatus int;      
  declare @PerTransactionId int=null;
  declare @UserPlanDetailsId bigint;
  declare @memberPlanBucketId bigint;
  Declare @AmountCappingGivenTimePeroid int=null;
  declare @TimePeroid int =null;
  declare @TimePeroidType varchar(100)=null
  declare @UseAsVaucher char = null;
  declare @CNPlanBucketId bigint;
  declare @CappingLimit bigint=0;
  declare @RemainingCapping int=0;
  Declare @TotalPharmacyUsed int=0;
  declare @TotalTransation int=0;
  declare @TotalCreditTran int = null;
  declare @UserLoginId bigint;
  declare @Days int ;
  declare @CurrentDate date =CONVERT(DATE, GETDATE());
  declare @IsAllowBooking char='N';
  set @CurrentDate=CONVERT(NVARCHAR(20), @CurrentDate, 120);
  declare @TotalRemaining int=0;
  Declare @BucketType varchar(100);---- by PK
  BEGIN TRY      
     select @AppointmentId=AppointmentId,@MemberId=memberId, @UserLoginId=UserLoginId, @scheduleStatus=ScheduleStatus, @UserPlanDetailsId= isnull(UserPlanDetailsId,0),@memberPlanBucketId=Isnull(MemberPlanBucketID,0) from Appointment where CaseNo=@CaseNo;      
	 select @BucketType=PLanBucketType from MemberPLanBucket where MemberPLanBucketId=@memberPlanBucketId
    ----- Start by Pruthviraj 25012024
   if @UserPlanDetailsId != 0
   begin 
   print @UserPlanDetailsId
      select @CNPlanBucketId=CNPlanBucketId from MemberPlanBucket where MemberPlanBucketId=@memberPlanBucketId
	  if exists(select * from  MemberPLanBucketsDetails where MemberPlanBucketId=@memberPlanBucketId and FacilityId=192)
	  begin
	    select @CappingLimit=CappingLimit from MemberPLanBucketsDetails where MemberPlanBucketId=@memberPlanBucketId and FacilityId=192
	  end
	  if exists(select * from CNPLanBucketRuleEngine where CNPLanBucketId=@CNPlanBucketId and PerTransactionLimit is not null and PerTransactionLimit != 0)
      begin
        select @PerTransactionId=isnull(PerTransactionLimit,0) from CNPLanBucketRuleEngine where CNPLanBucketId=@CNPlanBucketId
      end
	  if exists(select * from CNPLanBucketRuleEngine where CNPLanBucketId=@CNPlanBucketId and AmountCappinginAGiventTimePeriodAmount is not null and AmountCappinginAGiventTimePeriod != 0)
      begin
        select @AmountCappingGivenTimePeroid=isnull(AmountCappinginAGiventTimePeriodAmount,0),@TimePeroid=AmountCappinginAGiventTimePeriod,@TimePeroidType=AmountCappinginAGiventTimePeriodType from CNPLanBucketRuleEngine where CNPLanBucketId=@CNPlanBucketId
      set @IsAllowBooking='Y';
	  end
	  if @AmountCappingGivenTimePeroid > 0
	  BEGIN
	       set @Days=(case when @TimePeroidType ='Days' then 1 when @TimePeroidType='Weekly' then 7 when @TimePeroidType='Yearly' then 365 end)
		   set @Days=@Days*@TimePeroid;
		   print '@BucketTYpe'
		   print @BucketTYpe
		   if @BucketTYpe = 'PAYPERUSE'
		   begin
		   print 'Payper'
		   if exists(select * from  UserTransactions where BucketId=@memberPlanBucketId and PartialAmount is null and Status='Success' and createddate >= DATEADD(DAY, -@Days, GETDATE()) )
		     select @TotalTransation=sum(isnull(TotalAmount,0)) from UserTransactions where BucketId=@memberPlanBucketId and PartialAmount is null and Status='Success' and createddate >= DATEADD(DAY, -@Days, GETDATE());
		   end
		   else
		   begin
		     select @TotalTransation=sum(isnull(TransactionAmount,0)) from MemberBucketBalance m join Appointment apt on m.AppointmentId=apt.AppointmentId where m.MemberPLanBucketId=@memberPlanBucketId and m.Appointmentid is not null and m.WalletTransactionType='DEBIT' and m.createddate >= DATEADD(DAY, -@Days, GETDATE()) and apt.ScheduleStatus=19;
		     select @TotalCreditTran=sum(isnull(TransactionAmount,0)) from MemberBucketBalance where MemberPLanBucketId=@memberPlanBucketId and Appointmentid is not null and WalletTransactionType='CREDIT' and createddate >= DATEADD(DAY, -@Days, GETDATE());		   
		     set @TotalTransation=isnull(@TotalTransation,0)-isnull(@TotalCreditTran,0);
		   end
		   if @AmountCappingGivenTimePeroid>@TotalTransation
		   begin
			set @TotalRemaining=@AmountCappingGivenTimePeroid-@TotalTransation
		   end
		   else if @AmountCappingGivenTimePeroid<@TotalTransation and @AmountCappingGivenTimePeroid<@PerTransactionId
		   begin
		   print 'N1'
		  
			set @TotalRemaining=@AmountCappingGivenTimePeroid-@TotalTransation
		   end
		   else
		   begin
		   print 'N2'
		    print @TotalTransation
		    print @AmountCappingGivenTimePeroid
			set @TotalRemaining=@AmountCappingGivenTimePeroid-@TotalTransation
			print @TotalRemaining
		   end
		 end 
		
   end
   ---- ENd by Pruthviraj 25012024 
   select @CaseNo as CaseNo,'healthassure' as partner_name,'self' as payment_collection,'medpay' as delivery_partner,isnull(@PerTransactionId ,0)as PerTransactionLimitAmt,@IsAllowBooking as IsAllowBooking ,isnull(@TotalRemaining,0) as TotalRemaining -- basic data  
   select CONCAT(FirstName,'',LastName) as name,   
   ISNULL(FirstName,'') as FirstName, 
   ISNULL(LastName,'') as LastName,      
   MobileNo as mobile,      
   Gender as gender,      
   DATEDIFF(YEAR,cast(dob as datetime),GETDATE()) as age,      
   EmailId as email,   
   cast(dob as varchar(30)) as dob,  
   Relation  
   from member      
   where MemberId=@memberId   ----------- Customer data       
    
   select Address,State,City,Pincode,Landmark,'' as coOrdinates      
   from MedpayOrderContactDetails      
   where AppointmentId=@AppointmentId   ---------------Address Data      
      
   select Skuid,Name,ISNULL(Final_Pack_quantity,Initial_Pack_quantity) as quantity,ISNULL(FinalMrp,Mrp) as Mrp
   from AppointmentSkuDetails ASD      
   inner join Appointment A on A.AppointmentId=ASD.AppointmentId   
   where A.AppointmentId=@AppointmentId and ASD.IsActive='True';-------- Medicine Cart data      
        
   select ISNULL(ReportSavePath,'') from ReportAppointment where AppointmentId=@AppointmentId 
   
   --select ReportAppointmentId,DocType,ISNULL(ReportSavePath,'') as ReportSavePath from ReportAppointment where AppointmentId=74338
   --select 200 as statusCode,'Success' as message      
  END TRY      
  BEGIN CATCH      
      select 400 as statusCode,ERROR_MESSAGE() as message;      
  END CATCH      
END