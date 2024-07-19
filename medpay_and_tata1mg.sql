USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[uspGetMedpayOrderData_OPS]    Script Date: 6/20/2024 4:24:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------SELECT top 10 * FROM APPOINTMENT WHERE appointmenttype='PHM' order by 1desc
-----exec [uspGetMedpayOrderData_OPS]   'HA28012023CBDGHI'

ALTER PROCEDURE [dbo].[uspGetMedpayOrderData_OPS]        
   @CaseNo varchar(100)           
AS           
BEGIN          
 SET NOCOUNT ON;          
  Declare @AppointmentId bigint;        
  Declare @memberId bigint;        
  DECLARE @scheduleStatus int;        
        
  BEGIN TRY        
   select @AppointmentId=AppointmentId,@memberId=MemberId,@scheduleStatus=ScheduleStatus from Appointment where CaseNo=@CaseNo;        
           
   select @CaseNo as CaseNo,'healthassure' as partner_name,'self' as payment_collection,'medpay' as delivery_partner,@AppointmentId as AppointmentId-- basic data        
        
   
   select CONCAT(FirstName,' ',LastName) as name, 
   ISNULL(FirstName,'') as FirstName, 
   ISNULL(LastName,'') as LastName,      
   MobileNo as mobile,        
   Gender as gender,        
   DATEDIFF(YEAR,cast(dob as datetime),GETDATE()) as age,        
   EmailId as email,     
   cast(dob as varchar(30)) as dob,    
   Relation    
   from member        
   where MemberId=@memberId   -----------Customer data        
        
        
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