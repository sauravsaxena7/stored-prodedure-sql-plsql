
 
SELECT *  FROM UserLogin  Where UserloginId=7552 and UserPlanDetailsId=650


SELECT top 10 * FROM Client;

SELECT * FROM Member where MemberId=4782
SELECT * FROM LibertyEmpRegistration Where UserloginId=7552
SELECT * FROM Client Where ClientId = 454
SELECT   * FROM UserPlanDetails where UserPlanDetailsId=650
SELECT    * FROM CNPlanDetails where CNPlanDetailsId=788 and Plancode='Nan24'


Select * from Client where clientId=119
 SELECT   * FROM UserPlanDetails where ClientId=119
 select * from UserLogin where ClientId=119


 SELECT *  FROM UserLogin  Where UserloginId=7552
select * from UserLogin where UserloginId=524601
SELECT * FROM Member where UserLoginId=524601

select * From UserPlanDetails where MemberId in(531484
,531483
,521171) and ActiveStatus='Y';









SELECT * FROM UserPlanDetails where userPlanDetailsId=656

SELECT * FROM CNPlanDetails where CNPlanDetailsId=874

select * from Appointment where caseNo = 'HA03012024BACBEA'

SELECT * FROM Member where MemberId=521140
SELECT * FROM UserLogin where UserLoginId=524578

select ProcessCode,* from FacilitiesMaster where FacilityGroup='Fitness'

SELECT * FROM FacilitiesMaster where FacilityId=798

Select * from StatusMaster where statusId=2

SELECT * FROM AppointmentDetails where appointmentId=102140


SELECT * FROM  Member where UserLoginId=524601 and Relation='SELF' 

SELECT * FROM UserPlanDetails where UserPlanDetailsId=677;

SELECT * from  UserPlanDetails where UserPlanDetailsId=678;

SELECT * from  UserPlanDetails where UserPlanDetailsId=679;



SELECT * FROM  Member where UserLoginId=524601

SELECT TOP 10 * FROM MemberPlan order by 1 desc

SELECT * FROM UserPlanDetails where UserPlanDetailsId=677;
SELECT * from  UserPlanDetails where UserPlanDetailsId=678;
SELECT * from  UserPlanDetails where UserPlanDetailsId=679;
SELECT * FROM  Member where UserLoginId=524601

SELECT * FROM ProviderVerification


CREATE TABLE ProviderVerification(ID INT IDENTITY(1,1),ProviderName VARCHAR(50),ProviderLoginId VARCHAR(50),Password VARCHAR(50),CreatedBy VARCHAR(50),CreatedDate DATETIME)
INSERT INTO ProviderVerification SELECT 'HealthAssure pvt ltd',	'HealthAssure',	'HAassure@123',	'Akash Shah',GETDATE();


ALTER Table MemberCallDetails add UserPlanDetailsId BIGINT

	
	 




