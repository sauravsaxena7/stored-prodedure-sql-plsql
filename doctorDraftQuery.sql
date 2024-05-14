select  * from tele_consultaion.Doctor 
where DoctorDraft='Y' and CreatedDate between cast(getdate() as Date) and cast(getdate()+1 as Date) 
order by 1 desc

SELECT top 10 * FROM tele_consultaion.Doctor where price_updateddate is not null order by 1 desc


--SELECT top 1 * FROM  order by 1 desc 



select cast(getdate()-1 as Date)

--Alter Table tele_consultaion.Doctor Add MRP varchar(100)

--select * from tele_consultaion.DoctorSpecialty where DoctorId=318;
--
delete tele_consultaion.Doctor where DoctorId in(318);
delete tele_consultaion.DoctorCasetype where DoctorId in(331,329);
delete tele_consultaion.DoctorLanguage where DoctorId in(331,329);
delete tele_consultaion.DoctorQualification where DoctorId in(331,329);
delete tele_consultaion.DoctorSpecialty where DoctorId in(340);

SELECT * FROM [tele_consultaion].[DoctorLanguage] where doctorId=331 and deleted=0;
SELECT * FROM tele_consultaion.[DoctorLanguage] where doctorId=314 and deleted=0;

SELECT * FROM tele_consultaion.DoctorCasetype where doctorId=332 and deleted=0;
SELECT * FROM tele_consultaion.DoctorSpecialty where doctorId=340 and deleted=0;

SELECT * FROM tele_consultaion.Specialty where SpecialtyId=15

SELECT * FROM tele_consultaion.Gender WHERE genderId=1


SELECT  * FROM [tele_consultaion].[DoctorLanguage] where doctorId=42 and Deleted=0
SELECT  * FROM [tele_consultaion].DoctorCasetype where doctorId=42 and Deleted=0
SELECT  * FROM [tele_consultaion].DoctorQualification where doctorId=42 and Deleted=0
SELECT  * FROM [tele_consultaion].DoctorSpecialty where doctorId=42 and Deleted=0



SELECT TOP 3 * FROM [tele_consultaion].Doctor  order by DoctorId desc

UPDATE tele_consultaion.Doctor SET experince='' where experince='undefined' 


select top 3 * from tele_consultaion.Doctor order by 1 desc 


declare @datee datetime = CONVERT(datetime,'1983-03-09');
update tele_consultaion.Doctor SET deleted=0 where DoctorId=368;

update tele_consultaion.Doctor SET deleted=0 where DoctorId=366;







select * from [tele_consultaion].DoctorSpecialty ds    
inner join [tele_consultaion].DoctorQualification dq on dq.DoctorId=ds.doctorId    
inner join [tele_consultaion].Qualification q ON q.QualificationId=dq.qualificationId    
where dq.doctorId= 4  and dq.Deleted = 0


select * from [HaportalUAT].[dbo].[Provider] where providerId=12347

 

SELECT * FROM tele_consultaion.[Admin] where id=43

SELECT * FROM HAportal..provider where providerid=7546

--update tele_consultaion.[Admin] set companyId=136 where id=43

--update [tele_consultaion].[Company] set providerId=null where companyId=40

select * from [tele_consultaion].[Company] where providerId=7546

SELECT * FROM [tele_consultaion].[Company] where companyName like '%Kandy UAT Lab%'

SELECT HAPortal.


select * from [tele_consultaion].Doctor where companyId=1 and deleted=1 and  (DoctorDraft<>'Y' or DoctorDraft is null) and DoctorId not in (365
,364
,362
,361
,360
,359
,358
,356
,355
,354
,350
,345
,341
,338
,314
,312
,311
,310
,309
,308
,302
,301
,300
,299
,298
,297
,152
,151
,150
,149
,147
,146
,145
,144
,143
,142
,141
,140
,139
,138
,137
,136
,135
,134
,133
,132
,131
,130
,129
,128
,127
,126
,125
,124
,123
,122
,121
,120
,119
,118
,117
,116
,115
,113
,112
,111
,110
,109
,108
,107
,106
,105
,104
,103
,101
,100
,98
,97
,95
,94
,93
,92
,91
,90
,89
,88
,87
,86
,84
,83
,82
,81
,80
,79
,78
,77
,76
,75
,74
,73
,72
,71
,70
,69
,68
,67
,66
,65
,64
,63
,62
,61
,59
,58
,56
,55
,54
,53
,52
,51
,50
,49
,48
,47
,46
,45
,43
,41
,40
,39
,38
,37
,36
,35
,34
,33
,32
,31
,30
,29
,28
,27
,25
,24
,22
,21
,20
,19
,18
,17
,16
,15
,14
,13
,12
,11
,10
,9
,8
,4
,1)

select * from [tele_consultaion].Gender;


DECLARE @DateOfBirth date = '12/4/2023 12:00:00 AM'
DECLARE @today varchar(50) = CAST( cast(getdate() as Date) AS varchar(50))
   DECLARE @commingDob varchar(50) = CAST( cast(@DateOfBirth as Date) AS varchar(50))
   if @today=@commingDob
      BEGIN
	     SET @DateOfBirth = CAST('1700-09-17 11:25:37.077' AS DATE)
	  END
PRINT @commingDob
PRINT @today
PRINT @DateOfBirth