
SELECT top 100 * FROM ReportDigitizationData where TestId=3 order by 1 desc


Select FacilityName from FacilitiesMaster  where facilityName='cbc'

select * from [HAModule].ops.Admin order by 1 desc

select SUBSTRING(Mobile,1,3) + 
     'xxxxx' + 
     SUBSTRING(Mobile,LEN(Mobile) - 2, LEN(Mobile)),* from OPDPaymentDetails Where policyNo='OPD-HAOPDR00U40-58203'

DECLARE @String VARCHAR(100) = 'abcdef@gmail.com'
PRINT REVERSE(LEFT(RIGHT(REVERSE(@String) , CHARINDEX('@', @String) +1), 1))

SELECT  LEFT(@String, 1) + '*****@' 
+ REVERSE(LEFT(RIGHT(REVERSE(@String) , CHARINDEX('@', @String) +1), 1))
+ '******'
+ RIGHT(@String, 5)

'com.liamg@a'

DECLARE @AlphaNumericData VARCHAR(100)='OOOOOOOOOO1234'

PRINT 'xxxxx' + 
     SUBSTRING(@AlphaNumericData,LEN(@AlphaNumericData) - 3, LEN(@AlphaNumericData));

print REVERSE(Left( RIGHT(REVERSE(@String) , CHARINDEX('@', @String)+1),1))
 select * from [HAModuleUAT].ops.AdminRole order by 1 desc
 select * from [HAModuleUAT].ops.Admin where id=1

 


 -----------------------INSERT INTO [HAModuleUAT].ops.AdminRole (RoleName) values ('ShowMaskData')

 --print [dbo].[GetMaskedSimpleAlphaNumberData] ('lola123')
 --print [dbo].[GetMaskedAllCharExceptLast_4_Digit] ('lola123')
 --print [dbo].[GetMaskedEmail] ('lola@yahoo.in')
 --print [dbo].[ChkValidEmail]('lola@gmail.com')

 --Usp_GetAdminRole

 IIF(@IsShowMaskData='Y', UPIHandle,   [dbo].[GetDynamicLentgthCharacters]( LEN(UPIHandle)-LEN(SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)),'*' ) +  SUBSTRING(UPIHandle,CHARINDEX('@',UPIHandle) ,10)  ) as  UpiId,