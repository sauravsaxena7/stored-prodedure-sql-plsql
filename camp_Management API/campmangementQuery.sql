SELECT top 10 * FROM MemberBucketBalance where AppointmentId is not null order by 1 desc

SELECT * FROM Member where MemberId = 531493

SELECT * FROM UserPlanDetails where UserPlanDetailsId=689
--clienid,planid 453,	728

SELECT * FROM CNPlanDetails Where CNPlanDetailsId=728

SELECT * FROM CNPLanBucket Where CNPlanDetailsId=728
--CNplanBucketId=21342

SELECT TOP 10 * FROM CorporatePlanDetails

SELECT TOP 10 * FROM MemberBucketBalance order by 1 desc

SELECT * FROM CNPLanBucketsDetails where CNplanBucketId=21342

SELECT TOP 10 * FROM CNPlanDetails order by 1 desc;



---CNPLANDETAILS->CNPLANBUCKET->CNPLANBucketDetails->FacilityMaster
SELECT TOP 10 * FROM FacilitiesMaster order BY 1 desc

SELECT * FROM CNPlanDetails where CNPLanDetailsId=976
SELECT * FROM CNPlanRelation where CNPLanDetailsId=976
SELECT * FROM CNPlanBucket where CNPLanDetailsId=976
SELECT * FROM CNPLanBucketsDetails where CNPlanBucketId=21862
SELECT * FROM CNPlanBucketRelation where  CNPLanBucketRelationId in (11373)
SELECT * FROM RelationMaster Where relation='SELF'

--UserPlanDetailsId=859
--MemberPlanBucketId=864
--MemberId=531736
SELECT * FROM UserLogin where UserLoginId=535002
SELECT * FROM Member where MemberId=531735
SELECT * from UserPlanDetails where UserPlanDetailsid=859 and MemberId=531735

SELECT * FROM MemberBucketBalance where UserPlanDetailsid=859 and MemberPlanBucketId=864 order by 1 desc

SELECT TOP 10 * FROM MemberBucketBalance ORDER BY 1 DESC

SELECT * FROM RelationMaster where relation='SON'

DECLARE @relationIdsStr varchar(MAX);
DECLARE @relationNameStrs varchar(MAX);
SELECT @relationIdsStr= STRING_AGG(RelationIds, ',')  From CNPlanRelation WHERE CNPlanDetailsId=971;
SELECT @relationNameStrs= STRING_AGG(Relation, ',')  From RelationMaster
                  WHERE RelationId in (select * from SplitString(@relationIdsStr,','));
PRINT 'relationid '+ @relationIdsStr
PRINT 'relationname '+ @relationNameStrs
DECLARE @relation bigint;
SET @relation=7;
IF CHARINDEX(CAST(@relation AS VARCHAR(10)),@relationIdsStr)>0
 BEGIN
    PRINT 'TRUE'
 END
ELSE
 BEGIN
   PRINT 'FALSE'
 END


 SELECT * FROM CNPLanBucket WHERE CNPlanDetailsId=971
 SELECT * FROM CNPlanBucketsDetails WHERE CNPlanBucketId=21857;
 SELECT * FROM CNPlanBucketRelation WHERE CNPlanBucket

SELECT TOP 10 * FROM MemberPlanBucket order by 1 desc;
SELECT * FROM MemberPlanBucket Where UserPlanDetailsId=825 and CNPlanBucketId=21856
SELECT TOP 10 * FROM MemberBucketBalance  order by 1 desc

DECLARE @ActualCreditPoinOnMemberLevel bigint;
DECLARE @CNPlanBucketRelationIds Varchar(MAX);
SET @CNPlanBucketRelationIds='11368,11369'


--lets we check for husband=1
SELECT @ActualCreditPoinOnMemberLevel = CappingLimit FROM CNPLanBucketRelation where CNPLanBucketRelationId IN (select * from SplitString(@CNPlanBucketRelationIds,',')) and RelationId=1
                                  

PRINT @ActualCreditPoinOnMemberLevel





SELECT TOP 100 * FROM  LibertyEmpRegistration Where ClientId=389 order by 1 desc


SELECT TOP 10 * FROM MemberBucketBalance ORDER BY 1 DESC

SELECT * FROM UserPlanDetails where CNPlanDetailsId=971
Update UserPlanDetails SET MaxRelationAllowed=2  WHERE UserPlanDetailsId=826
SELECT * FROM Member where UserLoginId=534947 
DELETE Member Where MemberId=531660


SELECT TOP 10 * FROM UserLogin order by 1 desc 

SELECT * FROM Member where UserLoginId=534950

SELECT TOP 10 * FROM MemberBucketBalance order by 1 desc

SELECT TOP 10 * From MemberPlanMapping order by 1 desc


select m.MemberId , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y' , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y'
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
			  and CNPBD.facilityid not in (574)
			  and CP.CNPlanDetailsId=971 and cp.ClientId=449

SELECT TOP 10 * FROM UserLogin order by 1 desc


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
			  'N'
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




select 
			 m.MemberId,cp.ClientId,c.ClientName,cp.PlanName,mp.corporateplanid as PlanId,fm.FacilityName as PackageName, u.username as UserLoginName,
			  concat(m.FirstName,' ',m.LastName) as MemberName,
			  cpd.facilityid as PackageId,
			  m.firstname as MemberFirstName,
			  m.lastname as MemberLastName,
			  -1,
			  '',
			  'N'
               from 
			   MemberPlanMapping mpm
			   join memberplan mp on mpm.memberId=mp.memberId
              join CorporatePlan cp WITH (NOLOCK) on mp.CorporatePlanId=cp.CorporatePlanId
              join CorporatePlandetails cpd WITH (NOLOCK) on cpd.CorporatePlanId=cp.CorporatePlanId
              join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityId=cpd.FacilityId
               join member m WITH (NOLOCK) on m.memberid=mpm.MemberId 
               join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
              join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
			  UNION ALL
select m.MemberId , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y' , cp.ClientId,c.ClientName,cp.PlanName,mp.CNPlanDetailsId as PlanId,
			  fm.FacilityName as PackageName,
              u.username as UserLoginName,concat(m.FirstName,' ',m.LastName) as MemberName,fm.facilityid as PackageId,m.firstname as MemberFirstName,m.lastname as MemberLastName,CNPBD.CNPLanBucketId, cpd.BucketName,'Y'
FROM MemberPlanMapping MPM  
join UserPlanDetails mp on mp.UserPlanDetailsId=mpm.UserPlanDetailsId
               join CNPlanDetails cp WITH (NOLOCK) on mp.CNPlanDetailsId=cp.CNPlanDetailsId
               join CNPLanBucket cpd WITH (NOLOCK) on cpd.CNPlanDetailsId=cp.CNPlanDetailsId
			   join CNPLanBucketsDetails CNPBD WITH (NOLOCK) on CNPBD.CNPLanBucketId=cpd.CNPLanBucketId and CNPBD.FacilityId!=0
                join FacilitiesMaster fm WITH (NOLOCK) on fm.FacilityId=CNPBD.FacilityId 
				join Member m on MPM.MemberId=m.MemberId
               join userlogin u WITH (NOLOCK) on u.UserLoginId=m.UserLoginId 
               join client c WITH (NOLOCK) on c.ClientId=cp.ClientId
             

select * from UserLogin Where UserName='Bbself_01@gmail.com'

SELECT * FROM Member where UserLoginId=534960


select * From Appointment WHERE MemberId=531688

SELECT * from Appointment where caseNo=' '
--836
--837

SELECT  * FROM MemberBucketBalance Where MemberPLanBucketId=836 and UserPlanDetailsId=837 order by 1 desc 
--
 Update Appointment SET ScheduleStatus=1 where AppointmentId in (102524,
102525,
102526)

DELETE MemberBucketBalance where BucketBalanceId=1962


SELECT top 10 * FROM MemberBucketBalance where AppointmentId is not null order by 1 desc

SELECT * FROM Member where MemberId = 531493

SELECT * FROM UserPlanDetails where UserPlanDetailsId=689
--clienid,planid 453,	728

SELECT * FROM CNPlanDetails Where CNPlanDetailsId=728

SELECT * FROM CNPLanBucket Where CNPlanDetailsId=728
--CNplanBucketId=21342

SELECT TOP 10 * FROM CorporatePlanDetails

SELECT TOP 10 * FROM MemberBucketBalance order by 1 desc

SELECT * FROM CNPLanBucketsDetails where CNplanBucketId=21342

SELECT TOP 10 * FROM CNPlanDetails order by 1 desc;

SELECT * from UserLogin where userlogin=''

SELECT * From CNPLanBucketsDetails where CNPLanBucketId=21868

SELECT * FROM CNPLanBucketRelation where CNPLanBucketRelationId in (11382,11381,11380)