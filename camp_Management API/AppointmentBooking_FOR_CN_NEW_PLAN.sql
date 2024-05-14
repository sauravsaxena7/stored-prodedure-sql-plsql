USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[AppointmentBooking_FOR_CN_NEW_PLAN]    Script Date: 1/14/2024 3:47:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--AUTHOR:-SAURAV SUMAN

ALTER PROCEDURE [dbo].[AppointmentBooking_FOR_CN_NEW_PLAN] 
    @UserLoginId BIGINT,                               
	@MemberId BIGINT,			
	@UserPlanDetailsId BIGINT = NULL,  
	@MemberPlanBucketId BIGINT=NULL,
 	@ProviderId BIGINT=0,                                
	@FacilityIds VARCHAR(200)='',  
	@AppointmentDate DATE = NULL,                                
	@AppointmentTime TIME(3) = NULL,                                
	@PremiumFlag CHAR(1) = 'N',                               
	@VisitType CHAR(10) = 'CV',                                                                                              
	@Address VARCHAR(5000) = '',                          
	@DoctorId BIGINT = NULL,                             
	@FemaleAttendantReqd CHAR(1) = NULL,                                
	@MobileNo VARCHAR(50) = NULL,                                
	@DOB DATE = NULL
	
	
AS
BEGIN
   PRINT 'LOLA'
END