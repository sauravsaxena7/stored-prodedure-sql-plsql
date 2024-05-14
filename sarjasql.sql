SELECT * FROM CNPlanRelation Where CNPl;




select * from CNPLanBucketsDetails where CNPLanBucketId=14;  --skus

select * from  CNPLanBucketsDetails where CNPL




select FacilityId,FacilityName from FacilitiesMaster WHERE FacilityType='TEST' AND IsActive='Y' and CategoryId=1 AND FacilityGroup='Diagnostics'; 

SELECT distinct FacilityId,FacilityName,FacilityType FROM FacilitiesMaster where  IsActive='Y' and CategoryId=1 and FacilityType='TEST'

select * from CNPLanBucketRelation-- relation



SELECT  * FROM CNPLanBucketsDetails WHERE CNPLanBucketId   
        IN (Select  CNPLanBucketId from CNPLanBucket where CNPlanDetailsId=334) and CNPLanBucketId=35 and CappingLimit is not null

		Select  * from CNPLanBucket where CNPlanDetailsId=334