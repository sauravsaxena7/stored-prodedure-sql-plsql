SELECT ap.caseno,ap.appointmentId,ap.appointmentType,ad.PakageId, fm.FacilityName,fm.FacilityGroup,fm.FacilityType,fm.ProcessCode FROM  Appointment ap
join AppointmentDetails ad on ap.appointmentId=ad.appointmentId 
Join FacilitiesMaster fm on fm.FacilityId=ad.PakageId
Where ap.AppointmentId=102465
ORDER BY 1 DESC


SELECT distinct AppointmentId,PakageId FROM AppointmentDetails where AppointmentId=102465

SELECT TOP 100 * FROM Appointment order by 1 desc;
SELECT * FROM Appointment WHERE AppointmentId=102370
SELECT * FROM AppointmentDetails WHERE AppointmentId=102370
SELECT ProcessCode,* FROM FacilitiesMaster Where FacilityId=10



CREATE TABLE #TEMP(APPID BIGINT)
INSERT INTO #TEMP SELECT DISTINCT AppointmentId from Appointment -- WHERE AppointmentId=102370

WHILE EXISTS (SELECT * FROM #TEMP)
BEGIN
   DECLARE @AppointmentId bigint;
   SELECT top 1  @AppointmentId =  APPID from #TEMP;

  UPDATE Appointment set AppointmentType = (SELECT ProcessCode from FacilitiesMaster 
  where FacilityId=(Select top 1 PakageId from AppointmentDetails where AppointmentId=@AppointmentId)) Where AppointmentId=@AppointmentId;
  Delete top(1) from #TEMP
END
SELECT * FROM #TEMP
DROP TABLE #TEMP