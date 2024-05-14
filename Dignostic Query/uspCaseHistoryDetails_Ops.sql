USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[uspCaseHistoryDetails_Ops]    Script Date: 3/11/2024 2:43:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---select * from appointment where caseno='HA09072023CICFDA'    
---select * from appointmentlog where AppointmentId=282530 and ScheduleStatus=7
--exec uspCaseHistoryDetails_Ops 282530

---select * from appointment where caseno='HA10072023CICGIE'    
---select * from appointmentlog where AppointmentId=282684 and ScheduleStatus=7
--exec uspCaseHistoryDetails_Ops 103547
---------------------------------------------------   
   
ALTER PROCEDURE [dbo].[uspCaseHistoryDetails_Ops]        
 @Appointmentid BIGINT        
AS        
BEGIN 


       
 --SELECT DISTINCT Al.AppointmentLogId,A.AppointmentId, A.CaseNo, AL.ScheduleStatus, CONVERT(VARCHAR, AL.CreatedDate) AS RequestDate, S.StatusName,     
 --ISNULL(AL.Remarks,AL.StatusReason) AS Remarks,    
 --AL.CreatedBy as 'UpdatedBy',
 --isnull(CONVERT(varchar,ALD.AppointmentDateTime),AD.AppointmentDateTime) as    AppointmentDateTime  ,
 -- ISNULL(AL.Remarks,AL.StatusReason) AS StatusReson    
 --FROM Appointment A        
 --JOIN AppointmentLog AL        
 --ON A.AppointmentId = AL.AppointmentId        
 --left JOIN AppointmentLogDetails ALD        
 --ON ALD.AppointmentLogId=al.AppointmentLogId        
 --JOIN StatusMaster S        
 --ON S.StatusId = AL.ScheduleStatus        
 --JOIN AppointmentDetails AD        
 --ON AD.AppointmentId=A.AppointmentId        
 --WHERE A.AppointmentId = @Appointmentid and al.CallStatusId is null   order by AL.AppointmentLogId 

 
Create table #Temporary 
(AppointmentLogId varchar(Max),	AppointmentId varchar(Max),	CaseNo varchar(Max),ScheduleStatus varchar(Max),
RequestDate datetime,StatusName	varchar(Max),Remarks varchar(Max),	UpdatedBy	varchar(Max),AppointmentDateTime datetime,	StatusReson varchar(Max),AppointmentAssignToAdminName VARCHAR(200) null,
   AppointmentAssignToAdminDateTime DATETIME null,
   AppointmentAssignBy VARCHAR(200) NULL, ProviderId BIGINT NULL,ProviderName VARCHAR(200))
	  
 insert into #Temporary 
 (AppointmentLogId,AppointmentId,CaseNo,ScheduleStatus,RequestDate,StatusName,Remarks,UpdatedBy,AppointmentDateTime,StatusReson,AppointmentAssignToAdminName,
   AppointmentAssignToAdminDateTime ,
   AppointmentAssignBy,ProviderId,ProviderName)                                    
         
       
 SELECT DISTINCT Al.AppointmentLogId,A.AppointmentId, A.CaseNo, AL.ScheduleStatus, CONVERT(VARCHAR, AL.CreatedDate) AS RequestDate, S.StatusName,     
 ISNULL(AL.Remarks,AL.StatusReason) AS Remarks,    
 AL.CreatedBy as 'UpdatedBy',
 isnull(CONVERT(varchar,ALD.AppointmentDateTime),AD.AppointmentDateTime) as    AppointmentDateTime  ,
  ISNULL(AL.Remarks,AL.StatusReason) AS StatusReson,userAdmin.name ,AL.AppointmentAssignToAdminDateTime,
   AL.AppointmentAssignBy   ,AD.ProviderId ,pr.ProviderName
 FROM Appointment A        
 JOIN AppointmentLog AL        
 ON A.AppointmentId = AL.AppointmentId        
 left JOIN AppointmentLogDetails ALD        
 ON ALD.AppointmentLogId=al.AppointmentLogId        
 JOIN StatusMaster S        
 ON S.StatusId = AL.ScheduleStatus        
 JOIN AppointmentDetails AD        
 ON AD.AppointmentId=A.AppointmentId  
 left join [HAModuleUAT].OPS.Admin userAdmin on userAdmin.id=AL.AdminUserId
 left join [HAPortalUAT].dbo.Provider pr on pr.ProviderId=AD.ProviderId
 WHERE A.AppointmentId = @Appointmentid and al.CallStatusId is null   order by AL.AppointmentLogId 
 

declare @ScheduleStatus varchar(100)=(select ScheduleStatus from appointment where appointmentid=@Appointmentid );

 declare @countofcancelresonforCase varchar(100)=
 (select count(al.appointmentid) from appointmentlog al where al.AppointmentId=@Appointmentid  and  al.ScheduleStatus=7 );

 print 'CountofcancelresonforCase ='+ @countofcancelresonforCase;

 if @countofcancelresonforCase > 1 and @ScheduleStatus=7
 begin

    Update #Temporary                                                
    set #Temporary.Remarks = al1.remarks ,#Temporary.UpdatedBy=a1.UpdatedBy
    from Appointment a1
	Inner Join AppointmentLog al1 on a1.AppointmentId=al1.AppointmentId /*and al1.UserLoginId is not null*/ and al1.ScheduleStatus=7 
	where #Temporary.AppointmentId=al1.AppointmentId  and  #Temporary.ScheduleStatus=7

	--DELETE TOP (1)
 --   FROM   #Temporary  where #Temporary.appointmentid=@Appointmentid  and     #Temporary.ScheduleStatus=7

     
 end
if @countofcancelresonforCase = 1 and @ScheduleStatus=7
 begin
    Update #Temporary                                                
    set #Temporary.Remarks=al1.remarks  ,#Temporary.UpdatedBy=a1.UpdatedBy
    from Appointment a1
	Inner Join AppointmentLog al1 on a1.AppointmentId=al1.AppointmentId and al1.ScheduleStatus=7 
	where #Temporary.AppointmentId=a1.AppointmentId  and  #Temporary.ScheduleStatus=7
 end
 
  

select * from #Temporary order by #Temporary.AppointmentLogId ;


END 