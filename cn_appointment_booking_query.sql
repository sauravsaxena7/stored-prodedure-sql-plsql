SELECT TOP 10 * FROM CNPLanDetails ORDER BY 1 DESC

SELECT TOP 10 * FROM CNPLanBucket WHERE CNPlanDetailsId=728 order by 1 desc
SELECT TOP 10 * FROM CNPLanBucketsDetails where CNPlanBucketId in(21684,
21683)  order by 1 desc

SELECT TOP 10 * FROM MemberPlanBucket ORDER BY 1 DESC

SELECT TOP 10 * FROM MemberPlanBucketsDetails WHERE CNPLanBucketRelationId IS NOT NULL ORDER BY 1 DESC

102344

SELECT top 10 * FROM UserLogin order by 1 desc

SELECT TOP 10 * FROM UserPlanDetails order by 1 desc

SELECT TOP 10 * FROM CNPLanBucketRelation ORDER BY 1 DESC

select * from FacilityGroupCombinaton

SELECT * FROM FacilitiesMaster


DECLARE @SumOfTrasctionCredit BIGINT = 

DECLARE @RelationName varchar(100);
		 SELECT *  from Member Where MemberId=100;


SELECT * from CNPLanBucketRelation WHERE CNPLanBucketRelationId IN (select * from SplitString(@ClientId,',')) AND RelationId=8

SELECT * FROM RelationMaster

--in(select * from SplitString(@ClientId,','))

SELECT RelationId From RelationMaster Where Relation ='SON'

 SELECT FacilityId  From MemberPlanBucketsDetails MPBD
 JOIN MemberPlanBucket MPB on MPB.MemberPLanBucketId=MPBD.MemberPLanBucketId
 WHERE MPB.UserPlanDetailsId=769 and MPBD.FacilityGroup='lola'  and MPBD.MemberPLanBucketId=711

  SELECT TOP 10 * FROM MemberBucketBalance order by 1 desc

 SELECT top 10 * FROM Appointment order by 1 desc;

 SELECT * FROM Client where ClientId=458
 SELECT * FROM CNPLandetails where CNPlanDetailsId=896

 SELECT * FROM UserLogin where UserLoginId=534908
 SELECT * FROM Member Where UserLoginID=534908

 SElect * from UserPlanDetails where MemberId=531614

  INSERT INTO UserPlanDetails([MemberId],[ClientId],[CNPlanDetailsId],[PlanAmount],[FromDate],[ToDate],[MaxRelationAllowed],[ActiveStatus],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate]) VALUES(531614,458,896,999,'2024-01-14 10:17:00.000','2025-01-14 10:17:00.000',
				   2,'Y','admin',Getdate(),'admin',Getdate())
 SELECT TOP 10 * FROM UserPlanDetails order by 1 desc

 SELECT * FROM CNPLanBucket where CNPLanBucketId=21684

