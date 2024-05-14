USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[CampUserList]    Script Date: 2/2/2024 6:54:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Saurav Suman>  
-- Create date: <31-03-2023>  
-- Description: <Create For Inserting Baank Details into table name UIR_BankDetails>  
-- =============================================   

-- exec CampUserList null,null,'761','292','registration',5000,1
-- exec CampUserList null,null,'625','280','aps' ,1,0
-- exec CampUserList null,null,'1922','387','booking',1,2
-- exec CampUserList null,null,'728','453','aps',1,2

-- exec CampUserList null,null,'870','449','registration',1,2

---exec CampUserList null,null,'971','449','booking',1,2

--select ToDate, IsActive,* from CorporatePlan where IsActive='Y' and ToDate > getDate()


ALTER PROCEDURE [dbo].[CampUserList](                            
 @FromDate datetime = getDate,                              
 @ToDate datetime =getDate,                              
 @Plan varchar(100)='',                                                      
 @ClientId varchar(100)='',                                
 @Type varchar(100)='',
 @RecordPerPage INT =5000,
 @PageNumber INT=1,
 @statusname varchar(100)=NULL
)


AS                                
BEGIN                                
SET NOCOUNT ON

Declare @statusid int=(select StatusId from statusmaster where statusname=@statusname AND ISACTIVE='Y');

-- ClientId,clientname , PlanName, PlanID, UserLoginName, MemberID ,MemberName, PackageId, ProviderId, AppointmentVisitType, UserAddress, UserPincode
-- AppointmentDate, AppointmentTime
    IF (@Type='aps') --Appointment  Status Update
       BEGIN

	   CREATE TABLE #Temp(ClientId BIGINT,ClientName VARCHAR(50),planname VARCHAR(50),
	        UserLoginName VARCHAR(50),MemberId BIGINT, MemberName VARCHAR(50),
	        PlanId BIGINT,PackageId BIGINT,ProviderId BIGINT,AppointmentVisitType VARCHAR(50),
		    UserAddress VARCHAR(150),UserPincode VARCHAR(50),AppointmentDateTime DATETIME,ScheduleStatus VARCHAR(50),
		   CaseNo VARCHAR(50),StatusName VARCHAR(50),MemberFirstName VARCHAR(50),MemberLastName VARCHAR(50),IsWithNewPlan VARCHAR(1));

		   INSERT INTO #Temp
		   SELECT DISTINCT
	       apt.ClientId,
	       c.ClientName,
	       cp.planname,
	       u.UserName AS UserLoginName,
		   mem.MemberId,
		   Concat(mem.FirstName,' ',mem.LAStName) AS MemberName,
	       cp.CorporatePlanId AS PlanId,
	       apd.pakageid AS PackageId,
	       apd.providerid AS ProviderId,
		   apt.VisitType AS  AppointmentVisitType,
		   Concat(mem.Address1,' ',mem.Address2) AS UserAddress,
		   mem.Pincode AS UserPincode,
	       apd.AppointmentDateTime,
		   apt.ScheduleStatus,
		   apt.CaseNo,
		   Sm.StatusName,
		   isnull(mem.FirstName,'') as MemberFirstName,
		   isnull(mem.LAStName,'') as MemberLastName,'N'

	      FROM Appointment apt WITH (NOLOCK) 
		    join StatusMaster Sm WITH (NOLOCK) on Sm.StatusId=apt.ScheduleStatus 
	        join UserLogin u WITH (NOLOCK) on u.UserLoginId=apt.UserLoginId
	        join client c WITH (NOLOCK) on c.ClientId=apt.ClientId
	        join Member mem WITH (NOLOCK) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'  
	        join AppointmentDetails apd WITH (NOLOCK) on apd.AppointmentId=apt.AppointmentId and apd.PakageId not in (0) 
	        join memberplandetails mpd WITH (NOLOCK) on mpd.AppointmentId=apt.AppointmentId 
	        join corporateplan cp WITH (NOLOCK) on cp.CorporatePlanId=mpd.CorporatePlanId and Cp.IsActive = 'Y'
	      WHERE ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date )) 
            and (@Plan is null or cp.CorporatePlanId in(SELECT * from SplitString(@Plan,',')))                              
            and (@ClientId is null OR c.clientId  in(SELECT * from SplitString(@ClientId,',')))  
	        and apt.AppointmentType in ('HC','AHC')   
			and (@statusname is null OR apt.ScheduleStatus in (@statusid ) )   
	     --  ORDER BY apd.AppointmentDateTime DESC-- offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only 
		  UNION ALL

		   SELECT DISTINCT
	       apt.ClientId,
	       c.ClientName,
		   CNP.planName,
	       
	       u.UserName AS UserLoginName,
		   mem.MemberId,
		   Concat(mem.FirstName,' ',mem.LAStName) AS MemberName,
	       CNP.CNPlanDetailsId ,
	       apd.pakageid AS PackageId,
	       apd.providerid AS ProviderId,
		   apt.VisitType AS  AppointmentVisitType,
		   Concat(mem.Address1,' ',mem.Address2) AS UserAddress,
		   mem.Pincode AS UserPincode,
	       apd.AppointmentDateTime,
		   apt.ScheduleStatus,
		   apt.CaseNo,
		   Sm.StatusName,
		   isnull(mem.FirstName,'') as MemberFirstName,
		   isnull(mem.LAStName,'') as MemberLastName,'Y'

	      FROM Appointment apt WITH (NOLOCK) 
		    join StatusMaster Sm WITH (NOLOCK) on Sm.StatusId=apt.ScheduleStatus 
	        join UserLogin u WITH (NOLOCK) on u.UserLoginId=apt.UserLoginId
	        join client c WITH (NOLOCK) on c.ClientId=apt.ClientId
	        join Member mem WITH (NOLOCK) on apt.MemberId=mem.MemberId  and mem.IsActive = 'Y'  
	        join AppointmentDetails apd WITH (NOLOCK) on apd.AppointmentId=apt.AppointmentId and apd.PakageId not in (0) 
	        JOIN MemberBucketBalance mbb WITH (NOLOCK) on mbb.AppointmentId=apt.AppointmentId 
			JOIN UserPlanDetails Up with (nolock) on Up.UserPlanDetailsId=mbb.UserPlanDetailsId and Up.ActiveStatus='Y'
			JOIN CNPlanDetails CNP WITH (NOLOCK) on CNP.CNPlanDetailsId=Up.CNPlanDetailsId and CNP.ActiveStatus='Y'

	      WHERE ((@FromDate is null and @ToDate is null) OR cast (apt.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date )) 
            and (@Plan is null or (SELECT CNPlanDetailsId From UserPlanDetails where UserPlanDetailsId=mbb.UserPlanDetailsId) in(SELECT * from SplitString(@Plan,',')))                              
            and (@ClientId is null OR c.clientId  in(SELECT * from SplitString(@ClientId,',')))  
	        and apt.AppointmentType in ('HC','AHC')   
			and (@statusname is null OR apt.ScheduleStatus in (@statusid ) )   
	      

		  SELECT * FROM #Temp ORDER BY AppointmentDateTime DESC
		  
		  
		  DROP TABLE #Temp
         END
		 --ClientId,clientname , PlanName, PlanID, PackageId
	ELSE IF (@Type='registration')
	        BEGIN
			 CREATE TABLE #Tempo(ClientId BIGINT,ClientName VARCHAR(150),PlanName VARCHAR(150),
			 PlanId BIGINT,PackageId BIGINT,PackageName VARCHAR(150),CNPLanBucketId BIGINT ,CNPlanBucketName VARCHAR(150),IsWithNewPlan VARCHAR(1));

			 INSERT INTO #Tempo
			 SELECT DISTINCT
			    C.ClientId,
				C.ClientName,
				Cp.PlanName,
				Cp.CorporatePlanId AS PlanId,
				Fm.FacilityId As PackageId,
				Fm.FacilityName As PackageName,-1,'','N'
			  FROM Client C WITH (NOLOCK) 
			   join corporateplan Cp WITH (NOLOCK) on Cp.ClientId=C.ClientId and Cp.IsActive = 'Y'
			   join CorporatePlanDetails Cpd WITH (NOLOCK) on Cpd.CorporatePlanId=Cp.CorporatePlanId
			   join FacilitiesMaster Fm WITH (NOLOCK) on Fm.facilityid=Cpd.FacilityId
			  WHERE Fm.FacilityType in ('PACKAGE','AHC') and Fm.ProcessCode IN ('HC','AHC')
			   and Cpd.facilityid not in (574) --not for covid
			   and (@Plan is null or Cp.CorporatePlanId in(SELECT * from SplitString(@Plan,','))) 
			   and (@ClientId is null OR c.clientId  in(SELECT * from SplitString(@ClientId,',')))

			   UNION ALL

			   SELECT DISTINCT
			    C.ClientId,
				C.ClientName,
				Cp.PlanName,
				Cp.CNPlanDetailsId AS PlanId,
				Fm.FacilityId As PackageId,
				Fm.FacilityName As PackageName, 
				CNPBD.CNPLanBucketId,
				CNPB.BucketName,'Y'
			  FROM Client C WITH (NOLOCK) 
			   join CNPlanDetails Cp WITH (NOLOCK) on Cp.ClientId=C.ClientId and Cp.ActiveStatus = 'Y'
			   join CNPLanBucket CNPB WITH (NOLOCK) on CNPB.CNPlanDetailsId=Cp.CNPlanDetailsId
			   join CNPLanBucketsDetails CNPBD WITH(NOLOCK) ON CNPBD.CNPLanBucketId=CNPB.CNPLanBucketId and CNPBD.FacilityId!=0

			   join FacilitiesMaster Fm WITH (NOLOCK) on Fm.facilityid=CNPBD.FacilityId
			  WHERE Fm.FacilityType in ('PACKAGE','AHC') and Fm.ProcessCode IN ('HC','AHC') and CNPB.PLanBucketType='CREDIT'
			   and CNPBD.FacilityId not in (574) --not for covid
			   and (@Plan is null or Cp.CNPlanDetailsId in(SELECT * from SplitString(@Plan,','))) 
			   and (@ClientId is null OR c.clientId  in(SELECT *  from SplitString(@ClientId,',')))

			   UNION 

			    SELECT DISTINCT
			    C.ClientId,
				C.ClientName,
				Cp.PlanName,
				Cp.CNPlanDetailsId AS PlanId,
				Fm.FacilityId As PackageId,
				Fm.FacilityName As PackageName,CNPBD.CNPLanBucketId,CNPB.BucketName,'Y'
			  FROM Client C WITH (NOLOCK) 
			   join CNPlanDetails Cp WITH (NOLOCK) on Cp.ClientId=C.ClientId and Cp.ActiveStatus = 'Y'
			   join CNPLanBucket CNPB WITH (NOLOCK) on CNPB.CNPlanDetailsId=Cp.CNPlanDetailsId
			   join CNPLanBucketsDetails CNPBD WITH(NOLOCK) ON CNPBD.CNPLanBucketId=CNPB.CNPLanBucketId and CNPBD.FacilityId=0

			   join FacilitiesMaster Fm WITH (NOLOCK) on Fm.FacilityGroup=CNPBD.FacilityGroup and Fm.FacilityType=CNPBD.FacilityType
			  WHERE Fm.FacilityType in ('PACKAGE','AHC') and Fm.ProcessCode IN ('HC','AHC') and CNPB.PLanBucketType='CREDIT'
			   and CNPBD.FacilityId not in (574) --not for covid
			   and (@Plan is null or Cp.CNPlanDetailsId in(SELECT * from SplitString(@Plan,','))) 
			   and (@ClientId is null OR c.clientId  in(SELECT *  from SplitString(@ClientId,',')))
			  
			  
			  SELECT * FROM #Tempo ORDER BY 1 DESC
		  
		  
		  DROP TABLE #Tempo
		  END
		  --ClientId,clientname , PlanName, PlanID, PackageId, UserLoginName, MemberName, MemberID
   ELSE IF(@Type='booking')
          BEGIN

		  CREATE TABLE #Tempp(MemberId BIGINT,ClientId BIGINT,ClientName VARCHAR(150),PlanName VARCHAR(150),
			 PlanId BIGINT,PackageName VARCHAR(150),
			 UserLoginName VARCHAR(150),MemberName VARCHAR(150),PackageId BIGINT,
			 MemberFirstName VARCHAR(150), 
			 MemberLastName VARCHAR(150), CNPLanBucketId BIGINT ,CNPlanBucketName VARCHAR(150), IsWithNewPlan VARCHAR(10),Relation VARCHAR(50));

			 INSERT INTO #Tempp
			select 
			 mpm.MemberId,
			 cp.ClientId,
			 c.ClientName,
			 cp.PlanName,
			 mp.corporateplanid as PlanId,
			 fm.FacilityName as PackageName,
              u.username as UserLoginName,
			  concat(m.FirstName,' ',m.LastName) as MemberName,
			  cpd.facilityid as PackageId,
			  m.firstname as MemberFirstName,
			  m.lastname as MemberLastName,
			  -1,
			  '',
			  'N',m.Relation
               from 
			   MemberPlanMapping mpm
			   join memberplan mp on mpm.memberId=mp.memberId
              join CorporatePlan cp WITH (NOLOCK) on mp.CorporatePlanId=cp.CorporatePlanId
              join CorporatePlandetails cpd WITH (NOLOCK) on cpd.CorporatePlanId=cp.CorporatePlanId
              join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityId=cpd.FacilityId
               join member m WITH (NOLOCK) on m.memberid=mpm.MemberId 
               join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
              join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
              where mp.IsActive='Y'
              and  fm.FacilityType in ('PACKAGE','AHC') 
			  and fm.ProcessCode IN ('HC','AHC')
			  and cpd.facilityid not in (574)
			  and (@Plan is null or mp.CorporatePlanId in(SELECT * from SplitString(@Plan,',')))   
			  and (@ClientId is null OR  cp.ClientId  in(SELECT * from SplitString(@ClientId,',')))   
			  and ((@FromDate is null and @ToDate is null) OR cast (C.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))

			  UNION ALL

			 
select m.MemberId , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y',m.Relation
FROM MemberPlanMapping MPM  
join UserPlanDetails mp on mp.UserPlanDetailsId=mpm.UserPlanDetailsId
               join CNPlanDetails cp WITH (NOLOCK) on mp.CNPlanDetailsId=cp.CNPlanDetailsId
               join CNPLanBucket cpd WITH (NOLOCK) on cpd.CNPlanDetailsId=cp.CNPlanDetailsId
			   join CNPLanBucketsDetails CNPBD WITH (NOLOCK) on CNPBD.CNPLanBucketId=cpd.CNPLanBucketId and CNPBD.FacilityId!=0
                join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityId=CNPBD.FacilityId 
				join Member m on MPM.MemberId=m.MemberId
               join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
               join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
              where mp.ActiveStatus='Y'
              and  fm.FacilityType in ('PACKAGE','AHC') 
			  and fm.ProcessCode IN ('HC','AHC')
			  and cpd.PLanBucketType='CREDIT'
			  and (@Plan is null or mp.CNPlanDetailsId in(SELECT * from SplitString(@Plan,',')))   
			  and (@ClientId is null OR  cp.ClientId  in(SELECT * from SplitString(@ClientId,',')))   
			  and ((@FromDate is null and @ToDate is null) OR cast (C.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))

			  union

			  select m.MemberId , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y',m.Relation
FROM MemberPlanMapping MPM  
join UserPlanDetails mp on mp.UserPlanDetailsId=mpm.UserPlanDetailsId
               join CNPlanDetails cp WITH (NOLOCK) on mp.CNPlanDetailsId=cp.CNPlanDetailsId
               join CNPLanBucket cpd WITH (NOLOCK) on cpd.CNPlanDetailsId=cp.CNPlanDetailsId
			   join CNPLanBucketsDetails CNPBD WITH (NOLOCK) on CNPBD.CNPLanBucketId=cpd.CNPLanBucketId and CNPBD.FacilityId=0
                join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityGroup=CNPBD.FacilityGroup   and Fm.FacilityType=CNPBD.FacilityType
				join Member m on MPM.MemberId=m.MemberId
               join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
               join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
              where mp.ActiveStatus='Y'
              and  fm.FacilityType in ('PACKAGE','AHC') 
			  and fm.ProcessCode IN ('HC','AHC')
			  and cpd.PLanBucketType='CREDIT'
			  and (@Plan is null or mp.CNPlanDetailsId in(SELECT * from SplitString(@Plan,',')))   
			  and (@ClientId is null OR  cp.ClientId  in(SELECT * from SplitString(@ClientId,',')))   
			  and ((@FromDate is null and @ToDate is null) OR cast (C.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ));


		     SELECT * FROM #Tempp ORDER BY 1 DESC
		  
		  
		  DROP TABLE #Tempp  --offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only      
		  END
END
