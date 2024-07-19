USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspgetPharmacyMISReport]    Script Date: 5/24/2024 11:48:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

          
          
-- =============================================          
-- Author:  Niteesh        
-- Create date: 04-01-2023          
-- exec uspgetPharmacyMISReport '2021-08-29','2024-05-24',null,null,null,null,'N'              
-- =============================================      
        
ALTER PROCEDURE [dbo].[uspgetPharmacyMISReport]        
(      
 @FromDate datetime = null,                               
 @ToDate datetime =null,                       
 @Plan varchar(100)=null,                                                    
 @ClientId varchar(100)=null,                                                                                                                                                          
 @AppointmentStatus varchar(100) = null,  
 @buType varchar(100)=null, 
 @IsShowMaskData VARCHAR(20)=NULL
)        
AS        
BEGIN        
      
 create table #Temp        
 (        
  ClientName varchar(500),   
  CaseNo varchar(200),      
  CustomerName varchar(500),      
  MemberName varchar(500),      
  Relation varchar(50),      
  EmpNo varchar(1000),      
  EmailId varchar(1000),      
  EmpContactNo VARCHAR(100),      
  Facilityname varchar(100),      
  Providername varchar(200),      
  AppointmentDatetime DateTime,      
  RequestedDate DateTime,      
  ClosedDate DateTime,      
  [Status] varchar(100),  
  [statusname] varchar(100)  ,--sayali  
  PendingDatetime Datetime,      
  PartnerPendingDateTime Datetime,      
  InvoiceGeneratedDatetime Datetime,      
  PaymentPendingDatetime Datetime,      
  PaymentCollectedDatetime Datetime,      
  PackagepickedDatetime Datetime,      
  DeliveredDatetime Datetime,      
  CallLogHistory varchar(500),      
  CreatedBy varchar(200),      
  UpdatedBy varchar(200),      
  TranId varchar(500),      
  BuyFlag char,      
  DCCity varchar(100),      
  MetroNonMetro varchar(500),      
  StatusDate date,      
  AppointmentConfirmationTAT varchar(100),      
  Gender varchar(10),      
  CustRqstDt date,      
  ConfirmDate Date,      
  AppointmentAddress varchar(500),  
  SplitOrder nvarchar(10),
  PartnerOrderid   nvarchar(MAX),     --sayali    
  SplitOrderStatus Nvarchar(100),
  IsMarginClient char,      
  Remark varchar(MAX)   
 ,CancelReason nvarchar(MAX)  
 ,DeliveredTimestamp Datetime 
 ,AppointmentId varchar(Max)  --sayali 
 ,RefundId VARCHAR(200) ,RefundRemark varchar(300),RefundAmount Varchar(100)  ,RefundDoneBy varchar(300)

 )        
      
     Insert Into #Temp(ClientName,
	 CaseNo,CustomerName,MemberName,Relation,EmpNo,EmailId,EmpContactNo,Facilityname,ProviderName,AppointmentDatetime,RequestedDate,[Status],[statusname],CreatedBy,UpdatedBy,TranId,BuyFlag,DCCity,Gender,AppointmentAddress,SplitOrder,PartnerOrderid,SplitOrderStatus,CancelReason,DeliveredTimestamp
	 ,AppointmentId--sayali
	 ,RefundId, RefundRemark, RefundAmount --saurav
	 )     

     Select distinct C.ClientName,
	 A.CaseNo,CONCAT(U.FirstName,' ',U.LastName),CONCAT(M.FirstName,' ',M.LastName),M.Relation,U.EmpNo,
	 --M.EmailId,
	 IIF(@IsShowMaskData='N',[dbo].[GetMaskedEmail](M.EmailId),M.EmailId),
	 --U.MobileNo,
	 IIF(@IsShowMaskData='N',[dbo].[GetMaskedSimpleAlphaNumberData](U.MobileNo), U.MobileNo),
	 
	 'Pharmacy',   
     PPM.ProviderName as ProviderName  ,  
     AD.AppointmentDateTime,A.CreatedDate,A.ScheduleStatus,st.statusname,A.CreatedBy,A.UpdatedBy,ISNULL(MpayD.TransactionId,''),'Y',MPCD.City,M.Gender,CONCAT(MPCD.Address,' ',MPCD.Landmark,' ',MPCD.City,'-',MPCD.Pincode,' ',MPCD.State)  
     ,ISNULL(ASD.IsSplitOrder,'N'),IIF(ISNULL(ASD.IsSplitOrder,'N')='Y',ASD.SplitOrderId, Isnull(A.Partner_orderid,'')) as PartnerOrderid,ASD.SplitOrderStatus
     ,ISNULL(AL.Remarks,'') as CancelReason    
     ,mpos_d.TimeStamp as DeliveredTimestamp 
	, A.AppointmentId--added by sayali
	,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,CAST(srh.RefundAmount as varchar(300))

  from Appointment A 
  left join ServiceRefundHistory srh with(nolock) on A.AppointmentId=srh.Appointmentid
  Inner Join UserLogin U on U.UserLoginId=A.UserLoginId      
  Inner join Member M on M.MemberId=A.MemberId      
  Inner Join Client C on C.ClientId = U.ClientId      
  Inner Join AppointmentDetails AD on A.AppointmentId=AD.AppointmentId
  left join AppointmentLog AL on AL.AppointmentId = A.AppointmentId and AL.ScheduleStatus=7 and  al.Remarks not like '%demo%' and al.Remarks not like '%test%'       
  Inner join MemberPlanDetails MPD on MPD.AppointmentId=A.AppointmentId      
  Inner Join MedpayOrderContactDetails MPCD on MPCD.AppointmentId=A.AppointmentId      
  Inner join StatusMaster st with (nolock) on A.ScheduleStatus=st.StatusId    
  left join MedpayPharmacyOrderStatus mpos on mpos.OrderId=A.CaseNo and mpos.OrderStatus='invoice_generated'
  left join MedpayPharmacyOrderStatus mpos_d on mpos_d.OrderId=A.CaseNo and mpos_d.OrderStatus='package_delivered' and mpos_d.timestamp not in ('1900-01-01 00:00:00.000')
  inner join PharmacyProviderMaster PPM on PPM.ProviderId = mpos.ProviderId 
  Left Join MemberPaymentDetails MpayD On MpayD.MemberPaymentDetailsId=MPD.MemberPaymentDetailsId 
  Left Join AppointmentSkuDetails ASD on ASD.AppointmentId =A.AppointmentId     
  where A.AppointmentType='PHM'    
  and (@FromDate is null and @ToDate is null OR cast (A.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))      
  and (@Plan is null or MPD.CorporatePlanId in(select * from SplitString(@Plan,',')))     
  and (@ClientId is null OR C.clientId  in(select * from SplitString(@ClientId,',')))     
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')       
  and (@buType is null OR c.BUType like '%'+@buType+'%')  

  union all

  Select distinct C.ClientName,
	 A.CaseNo,CONCAT(U.FirstName,' ',U.LastName),CONCAT(M.FirstName,' ',M.LastName),M.Relation,U.EmpNo,M.EmailId,U.MobileNo,'Pharmacy',   
     PPM.ProviderName as ProviderName  ,  
     AD.AppointmentDateTime,A.CreatedDate,A.ScheduleStatus,st.statusname,A.CreatedBy,A.UpdatedBy,ISNULL(MPD.TransactionId,''),'Y',MPCD.City,M.Gender,CONCAT(MPCD.Address,' ',MPCD.Landmark,' ',MPCD.City,'-',MPCD.Pincode,' ',MPCD.State)  
     ,ISNULL(ASD.IsSplitOrder,'N'),IIF(ISNULL(ASD.IsSplitOrder,'N')='Y',ASD.SplitOrderId, Isnull(A.Partner_orderid,'')) as PartnerOrderid,ASD.SplitOrderStatus
     ,ISNULL(AL.Remarks,'') as CancelReason    
     ,mpos_d.TimeStamp as DeliveredTimestamp 
	, A.AppointmentId--added by sayali
	,ISNULL(srh.RazorpayRefundId,'')
  ,ISNULL(null,'')
  ,CAST(srh.RefundAmount as varchar(300))

  from Appointment A 
  left join ServiceRefundHistory srh with(nolock) on A.AppointmentId=srh.Appointmentid
  Inner Join UserLogin U on U.UserLoginId=A.UserLoginId      
  Inner join Member M on M.MemberId=A.MemberId      
  Inner Join Client C on C.ClientId = U.ClientId      
  Inner Join AppointmentDetails AD on A.AppointmentId=AD.AppointmentId
  left join AppointmentLog AL on AL.AppointmentId = A.AppointmentId and AL.ScheduleStatus=7 and  al.Remarks not like '%demo%' and al.Remarks not like '%test%'       
  Inner join MemberBucketBalance MPD on MPD.AppointmentId=A.AppointmentId      
  Inner Join MedpayOrderContactDetails MPCD on MPCD.AppointmentId=A.AppointmentId      
  Inner join StatusMaster st with (nolock) on A.ScheduleStatus=st.StatusId    
  left join MedpayPharmacyOrderStatus mpos on mpos.OrderId=A.CaseNo and mpos.OrderStatus='invoice_generated'
  left join MedpayPharmacyOrderStatus mpos_d on mpos_d.OrderId=A.CaseNo and mpos_d.OrderStatus='package_delivered' and mpos_d.timestamp not in ('1900-01-01 00:00:00.000')
  inner join PharmacyProviderMaster PPM on PPM.ProviderId = mpos.ProviderId 
  Left Join   UserTransactions ut on ut.TransactionId=MPD.TransactionId
  Left Join AppointmentSkuDetails ASD on ASD.AppointmentId =A.AppointmentId    
  Inner Join UserPlanDetails upd on upd.UserPlanDetailsId= MPD.UserPlanDetailsId
  where A.AppointmentType='PHM'    
  and (@FromDate is null and @ToDate is null OR cast (A.CreatedDate as date )Between  cast (@FromDate as date ) and cast (@ToDate as date ))      
  and (@Plan is null or upd.CNPlanDetailsId in(select * from SplitString(@Plan,',')))     
  and (@ClientId is null OR C.clientId  in(select * from SplitString(@ClientId,',')))     
  and (@AppointmentStatus is null OR st.StatusName like '%'+@AppointmentStatus+'%')       
  and (@buType is null OR c.BUType like '%'+@buType+'%')  

  
    
  update #Temp    
  set PendingDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='pending'    
    
  update #Temp    
  set PartnerPendingDateTime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='Partner_Pending'    
    
  update #Temp    
  set InvoiceGeneratedDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='invoice_generated'    
    
  update #Temp    
  set PaymentPendingDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='Payment Pending'    
    
   update #Temp    
  set PaymentCollectedDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='payment_collected'    
    
   update #Temp    
  set PackagepickedDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='package_picked'    
    
   update #Temp    
  set DeliveredDatetime = MPOS.TimeStamp    
  from  #Temp T    
  Inner join medpaypharmacyorderstatus MPOS on MPOS.OrderId=T.CaseNo and OrderStatus='package_delivered'  
  
  ------------------cancel reason--(added by sayali)--------------------------------------------- 


   ---------------------Refund Logic start------------------------------
select max(AppointmentLogId) as maxlogid 
into #maxlogid
from appointmentlog where StatusReason in ('Initiate Refund','Refund Rejected') and AppointmentId in (select AppointmentId from #Temp)
group by AppointmentId 

--select * from #maxlogid;

create table #Refunddata (AppointmentLogId int,	AppointmentId int, Remarks varchar(500),UserLoginId	 int,CreatedBy varchar(100),StatusReason varchar(100))
insert into #Refunddata
select m.maxlogid,al.AppointmentId,al.Remarks,al.UserLoginId,al.CreatedBy,al.StatusReason
from #maxlogid m  join appointmentlog al on m.maxlogid=al.appointmentlogid

--select * from #Refunddata;

update T
set T.RefundRemark= R.Remarks,T.RefundDoneBy=R.CreatedBy
from #Temp T left join #Refunddata R on T.AppointmentId=R.AppointmentId
where  T.AppointmentId=R.AppointmentId
---------------------Refund Logic end------------------------------

-----------closeddate logic------------
select max(AppointmentLogId) as maxlogid
into #maxlogidclosed
from appointmentlog where ScheduleStatus=19 and AppointmentId in (select AppointmentId from #Temp)
group by AppointmentId 

select a.AppointmentId,a.Createddate,a.schedulestatus into #aldata from AppointmentLog a
where a.AppointmentLogId in (select maxlogid from #maxlogidclosed)

update T
set T.ClosedDate=R.CreatedDate
from #Temp T left join #aldata R on T.AppointmentId=R.AppointmentId
where  T.AppointmentId=R.AppointmentId

---------------------------------------

	
 	
 declare @countofcancelRemarksforCase varchar(100)=
 (select count(al.remarks)  from appointmentlog al join  #Temp  t on al.AppointmentId=t.AppointmentId 
 where al.ScheduleStatus=7 and al.AppointmentId =t.AppointmentId and al.CallStatus is null);

 print 'count of cancelRemarks ='+@countofcancelRemarksforCase

if  @countofcancelRemarksforCase > 1
 begin

    Update #Temp                                               
    set #Temp.CancelReason=
    (select top 1  al1.remarks 
    from Appointment a1
	Inner Join AppointmentLog al1 on a1.AppointmentId=al1.AppointmentId  
	where #Temp.AppointmentId=al1.AppointmentId and al1.ScheduleStatus=7 and al1.CallStatus is null and al1.UserLoginId is not null)
     
 end
 if @countofcancelRemarksforCase = 1
 begin
    Update #Temp                                           
    set #Temp.CancelReason=
    (select top 1  al1.remarks 
    from #Temp t
	Inner Join AppointmentLog al1 on t.AppointmentId=al1.AppointmentId  and al1.ScheduleStatus=7
	where  #Temp.AppointmentId=al1.AppointmentId   )
 end



                                                    
 -----------------------------------------------------------------         
    
  --Select * from #Temp

  -------------------------------------------------------------------  

  update #Temp set #Temp.CancelReason='Cancelled By Tata 1mg' where Status=7 and CancelReason is null and Providername='Tata 1mg'; 
   ----------------------------------------------------------------- 
   

    
  Select * from #Temp----table 1

  select distinct T.CaseNo as CaseNo,T.AppointmentId,ASD.Skuid as SkuId ,ASD.Name as SkuName,ISNULL(ASD.FinalMrp,Mrp) as DiscountedPrice,ASD.SkuPrice as Price,ISNULL(ASD.Final_Pack_quantity,ASD.Initial_Pack_quantity) as FinalQty
  ,(CAST(ISNULL(ASD.finalMrp,ASD.Mrp) as float)*ISNULL(ASD.Final_Pack_quantity,ASD.Initial_Pack_quantity)) as GmvListPrice
  ,(CAST(ASD.SkuPrice as float)*ISNULL(ASD.Final_Pack_quantity,ASD.Initial_Pack_quantity)) as GmvPrice,Rx_required as Rx_Required,mpid.Tgst as VasCharges
  from AppointmentSkuDetails ASD
  join #Temp T on T.AppointmentId = ASD.AppointmentId
  join MedpayPharmacyOrderStatus mpos on T.CaseNo=mpos.OrderId
  join MedpayPharmacyInvoiceDetails mpid on mpos.InvoiceId=mpid.InvoiceId
  where ASD.IsActive='true'



        
END 
