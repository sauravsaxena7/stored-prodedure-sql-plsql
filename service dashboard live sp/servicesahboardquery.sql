select * from Appointment 
    where  
	clientid<>0 
	and AppointmentType='HC' 
	and ScheduleStatus in (1) 
	and CreatedDate between CreatedDate and DATEADD(HOUR,-1,CreatedDate)

	SELECT DATEADD(hour,-1, '2019/04/05');
	 SELECT cast('2023-07-08' as Date) AS datetimee

	 --cast(CreatedDate as Date) AS reqDate,
	 --and  cast(CreatedDate as Date)  between  cast('2023-07-08' as Date) and  cast('2023-07-08' as Date)

	select top 10 cast(CreatedDate as Date) AS reqDate,  * from Appointment where  clientid<>0 and AppointmentType='HC'
	and ScheduleStatus in (1)
	and  cast(CreatedDate as Date)  between  cast('2023-12-08' as Date) and  cast('2023-12-08' as Date)
	order by 1 desc