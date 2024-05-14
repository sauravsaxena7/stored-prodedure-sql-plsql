USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[GetPharmacyDashboardData]    Script Date: 2/27/2024 12:15:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
           
 --   EXEC GetPharmacyDashboardData NULL,NULL
 
ALTER PROCEDURE [dbo].[GetPharmacyDashboardData]                                         
                                        
 @FromDate datetime = null,                                          
 @ToDate datetime =null                                         
                                 
AS                                            
BEGIN 
 
 DECLARE @DisplayFromDate datetime,@DisplayToDate datetime;

 IF @FromDate is null OR @ToDate is null
    BEGIN
	  SELECT @FromDate =  GETDATE();
	  SELECT @ToDate=GETDATE();
	END

 PRINT 'lola'
  PRINT cast(@FromDate as date)

  DECLARE @TotalRequested BIGINT,@TotalRequested_Within_1_Hours BIGINT,@TotalRequested_Within_2_Hours BIGINT,@TotalRequested_OUT_OF_TAT BIGINT, @PartnerPendingCount BIGINT,@PaymentPendingCount BIGINT,@AcceptedCount BIGINT,@Invoice_Generated_count BIGINT, @PaymentCollected_Count BIGINT,@PackagePicked_count bigint,@Package_delivered_Within_Delivery_TAT BIGINT,@Package_delivered_Within_Delivery_OUT_TAT BIGINT,@NPS BIGINT;

  select @TotalRequested = count(*) from Appointment where (@FromDate is null and @ToDate is null OR cast (CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and AppointmentType='PHM' and ScheduleStatus=1

   select @TotalRequested_Within_1_Hours = count(*) from Appointment where (@FromDate is null and @ToDate is null OR cast (CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and AppointmentType='PHM' and ScheduleStatus=1 and DATEDIFF(HOUR, CreatedDate, GETDATE())<=1


   select @TotalRequested_Within_2_Hours = count(*) from Appointment where (@FromDate is null and @ToDate is null OR cast (CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and AppointmentType='PHM' and ScheduleStatus=1 and DATEDIFF(HOUR, CreatedDate, GETDATE())<=2

   select @TotalRequested_OUT_OF_TAT = count(*) from Appointment where (@FromDate is null and @ToDate is null OR cast (CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and AppointmentType='PHM' and ScheduleStatus=1 and DATEDIFF(HOUR, CreatedDate, GETDATE())>=4;


   select @PartnerPendingCount= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=29
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=29;


	 select @PaymentPendingCount= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=31
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=31;


	select @AcceptedCount= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=26
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=26;


	select @Invoice_Generated_count= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=27
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=27;

	select @PaymentCollected_Count= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=30
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=30;

	select @PackagePicked_count= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=28
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=28;

	select @Package_delivered_Within_Delivery_TAT= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=19
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=19 and  DATEDIFF(HOUR, apl.CreatedDate, GETDATE())<=4;

	select @Package_delivered_Within_Delivery_OUT_TAT= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=19
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='PHM' and apt.ScheduleStatus=19 and  DATEDIFF(HOUR, apl.CreatedDate, GETDATE())>=4;



	--rem_section start

	DECLARE @TotalRequested_rem BIGINT,@OnHold_rem BIGINT,@Review_rem BIGINT,@Approved_rem BIGINT, @Verification_Pending_rem  BIGINT,@Rejected_rem BIGINT,@Finance_pending BIGINT,@Closed_Completed_rem BIGINT,@NPS_REM BIGINT, @Avg_Resolution_Time_rem BIGINT;

	 select @TotalRequested_rem = count(*) from Appointment where (@FromDate is null and @ToDate is null OR cast (CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date )) and AppointmentType='RI' and ScheduleStatus=1

	 select @OnHold_rem= count(*) from Appointment apt 
   join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=21
   where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=21;

	 select @Review_rem= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=22
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=22;

	select @Approved_rem= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=25
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=25;

	select @Verification_Pending_rem= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=48
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=48;


	select @Rejected_rem= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=23
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=23;

	select @Finance_pending= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and apl.ScheduleStatus=-1
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and apt.ScheduleStatus=-1;

	select @Closed_Completed_rem= count(*) from Appointment apt 
      join AppointmentLog apl on apl.AppointmentId=apt.AppointmentId and 
	  (apl.ScheduleStatus=26 or apl.ScheduleStatus=14)
      where 
    (@FromDate is null and @ToDate is null OR cast (apl.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date )) and apt.AppointmentType='RI' and (apt.ScheduleStatus=26 or apt.ScheduleStatus=14);







  SELECT @TotalRequested AS TotalRquested, @TotalRequested_Within_1_Hours AS TotalRequested_Within_1_Hours, @TotalRequested_Within_2_Hours AS TotalRequested_Within_2_Hours,@TotalRequested_OUT_OF_TAT as TotalRequested_OUT_OF_TAT,@PartnerPendingCount AS PartnerPendingCount,@PaymentPendingCount AS PaymentPendingCount ,@AcceptedCount AS AcceptedCount,@Invoice_Generated_count AS Invoice_Generated_count,@PaymentCollected_Count AS PaymentCollected_Count,@PackagePicked_count AS PackagePicked_count,@Package_delivered_Within_Delivery_TAT as Package_delivered_Within_Delivery_TAT,@Package_delivered_Within_Delivery_OUT_TAT as Package_delivered_Within_Delivery_OUT_TAT,@NPS AS NPS,
  --rem part start
  @TotalRequested_rem AS TotalRquested_rem, @OnHold_rem AS OnHold_rem, @Review_rem AS Review_rem,
  @Approved_rem as Approved_rem,@Verification_Pending_rem AS Verification_Pending_rem,@Rejected_rem AS Rejected_rem ,@Finance_pending AS Finance_pending,
  @Closed_Completed_rem AS Closed_Completed_rem,@Avg_Resolution_Time_rem as Avg_Resolution_Time_rem,@NPS_REM as NPS_REM;


END