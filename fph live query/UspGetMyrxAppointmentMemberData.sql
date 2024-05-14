USE [HAProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[UspGetMyrxAppointmentMemberData]    Script Date: 2/14/2024 10:15:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec UspGetMyrxAppointmentMemberData 'HA13022024BADBJC'
Alter Proc [dbo].[UspGetMyrxAppointmentMemberData]
(
   @CaseNo nvarchar(500)
)
As 
Begin
    Select MyRxAppointmentId,MyRxMemberId,M.MemberId,CONCAT(M.FirstName,' ',M.LastName) as MemberName,M.EmailId,M.MobileNo,200 as subCode
	from HaMyRxAppointmentDetails HM
	inner join Member M on M.MemberId=HM.MemberId
	where CaseNo=@CaseNo
End