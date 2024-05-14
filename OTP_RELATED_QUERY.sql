select * from sys.tables WHERE name like '%otp%'
SELECT TOP 10 * FROM tele_consultaion.LoginOTP order by 1 desc;


SELECT * from tele_consultaion.Consultation WHERE caseno='HA02012024BACAJG'


-- SELECT * from tele_consultaion.Admin where phone ='8271113231'
 --Update tele_consultaion.Admin  set phone='8271113231'  where id=2

 Select * from [HAProductsUAT]..Appointment where caseNo='HA02012024BACAJG' 


 SELECT * FROM UserLogin where UserLoginId=534805
 Select * from Member where UserLoginId=534805
 SELECT * FROM UserPlanDetails where memberId = 531476

 select * from sys.columns WHERE name like '%HAPrice%'


 SELECT DISTINCT		
       o.name AS Object_Name,		
       o.type_desc		
FROM sys.sql_modules m		
       INNER JOIN		
       sys.objects o		
         ON m.object_id = o.object_id		
		 WHERE m.definition Like '%HAPrice%' ESCAPE '\'


		 SELECT * FROM Appointment where CaseNo='HA05012024BACCEI'

		 SELECt * from StatusMaster;

		 SELECT * from tele_consultaion.Consultation where caseno='HA05012024BACCEI'

		 Update tele_consultaion.Consultation set status=4 where caseno='HA05012024BACCEI'


		 SELECT * FROM tele_consultaion.ConsultationStatus