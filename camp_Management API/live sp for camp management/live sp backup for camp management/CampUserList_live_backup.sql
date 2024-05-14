USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[CampUserList]    Script Date: 1/25/2024 3:20:00 PM ******/
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
-- exec CampUserList null,null,'1922','387','aps',1,2

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
		   isnull(mem.LAStName,'') as MemberLastName

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
	      ORDER BY apd.AppointmentDateTime DESC-- offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only  
         END
		 --ClientId,clientname , PlanName, PlanID, PackageId
	ELSE IF (@Type='registration')
	        BEGIN
			  SELECT DISTINCT
			    C.ClientId,
				C.ClientName,
				Cp.PlanName,
				Cp.CorporatePlanId AS PlanId,
				Fm.FacilityId As PackageId,
				Fm.FacilityName As PackageName
			  FROM Client C WITH (NOLOCK) 
			   join corporateplan Cp WITH (NOLOCK) on Cp.ClientId=C.ClientId and Cp.IsActive = 'Y'
			   join CorporatePlanDetails Cpd WITH (NOLOCK) on Cpd.CorporatePlanId=Cp.CorporatePlanId
			   join FacilitiesMaster Fm WITH (NOLOCK) on Fm.facilityid=Cpd.FacilityId
			  WHERE Fm.FacilityType in ('PACKAGE','AHC') and Fm.ProcessCode IN ('HC','AHC')
			   and Cpd.facilityid not in (574) --not for covid
			   and (@Plan is null or Cp.CorporatePlanId in(SELECT * from SplitString(@Plan,','))) 
			   and (@ClientId is null OR c.clientId  in(SELECT * from SplitString(@ClientId,',')))
			  ORDER BY 1 DESC  --offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only  
		  END
		  --ClientId,clientname , PlanName, PlanID, PackageId, UserLoginName, MemberName, MemberID
   ELSE IF(@Type='booking')
          BEGIN
		  --  SELECT DISTINCT
			 -- C.ClientId,
			 -- C.ClientName,
			 -- Cp.PlanName,
			 -- Cp.CorporatePlanId AS PlanId,
			 -- Fm.FacilityId AS PackageId,
			 -- Fm.FacilityName As PackageName,
			 -- U.UserName AS UserLoginName,
			 -- Concat(Mem.FirstName,' ',Mem.LAStName) AS MemberName,
			 -- Mem.MemberId,
			 -- isnull(mem.FirstName,'') as MemberFirstName,
		  --    isnull(mem.LAStName,'') as MemberLastName
			 -- FROM  Client C
			 --  join UserLogin U WITH (NOLOCK) on U.ClientId=C.ClientId
			 --  join corporateplan Cp WITH (NOLOCK) on Cp.ClientId=C.ClientId and Cp.IsActive = 'Y'
			 --  join CorporatePlanDetails Cpd WITH (NOLOCK) on Cpd.CorporatePlanId=Cp.CorporatePlanId
			 --  join FacilitiesMaster Fm WITH (NOLOCK) on Fm.facilityid=Cpd.FacilityId
			 --  join Member Mem WITH (NOLOCK) on Mem.UserLoginId=U.UserLoginId and mem.IsActive = 'Y' 
			 --  join MemberPlanDetails Mpd WITH (NOLOCK) on Mpd.MemberId=Mem.MemberId
			 --WHERE Fm.FacilityType in ('PACKAGE') 
			 -- and fm.ProcessCode='HC'
			 -- and Cpd.facilityid not in (574)  
    --          --and C.clientname not like '%demo%' 
			 -- --and C.ClientName not like '%test%'
			 -- and (@Plan is null or Cp.CorporatePlanId in(SELECT * from SplitString(@Plan,',')))                              
    --          and (@ClientId is null OR C.clientId  in(SELECT * from SplitString(@ClientId,','))) 
			 -- and ((@FromDate is null and @ToDate is null) OR cast (C.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))
			 --  ORDER BY 1 DESC  offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only

			 select cp.ClientId,c.ClientName,cp.PlanName,mp.corporateplanid as PlanId,cpd.facilityid as PackageId,fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,mp.MemberId,m.firstname as MemberFirstName,m.lastname as MemberLastName
               from memberplan mp 
              join CorporatePlan cp WITH (NOLOCK) on mp.CorporatePlanId=cp.CorporatePlanId
              join CorporatePlandetails cpd WITH (NOLOCK) on cpd.CorporatePlanId=cp.CorporatePlanId
              join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityId=cpd.FacilityId
              left join member m WITH (NOLOCK) on m.memberid=mp.MemberId 
              left join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
              join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
              where mp.IsActive='Y'
              and  fm.FacilityType in ('PACKAGE','AHC') 
			  and fm.ProcessCode IN ('HC','AHC')
			  and cpd.facilityid not in (574)
			  and (@Plan is null or mp.CorporatePlanId in(SELECT * from SplitString(@Plan,',')))   
			  and (@ClientId is null OR  cp.ClientId  in(SELECT * from SplitString(@ClientId,',')))   
			  and ((@FromDate is null and @ToDate is null) OR cast (C.CreatedDate as date ) Between  cast (@FromDate as date ) and cast (@ToDate as date ))
	  
		    ORDER BY 1 DESC  --offset @RecordPerPage * (@PageNumber-1) rows FETCH NEXT @RecordPerPage rows only      
		  END
END
