--SP_HELPTEXT 'GetAllBucketDetailsForSpecificPlanId'

-- AUTHOR SAURAV SAXENA   
-- DATE 8-08-2023   
--Description : GET ALL SKU'S AND CAPPING LIMIT'S FOR SPECIFIC PLANID  
--  exec GetAllBucketDetailsForSpecificPlanId 284      
alter PROC [dbo].[GetAllBucketDetailsForSpecificPlanId]  
@planId int    
AS  
BEGIN --ALGORITHM START  
   DECLARE @CappingLimitPlanBucket TABLE (BucketId BIGINT,CappingLimit DECIMAL, FacilityId BIGINT,  
           FacilityType VARCHAR(300), FacilityName VARCHAR(300));  
   DECLARE @MyCursor CURSOR;  
   DECLARE @BucketId BIGINT ;  
   DECLARE @FacilityId BIGINT ;  
   DECLARE @CappingLimit DECIMAL;  
   DECLARE @FacilityType VARCHAR(300);  
     
   BEGIN  
      SET @MyCursor = CURSOR FOR SELECT  CNPLanBucketId,FacilityId,CappingLimit,FacilityType FROM CNPLanBucketsDetails WHERE CNPLanBucketId   
        IN (Select  CNPLanBucketId from CNPLanBucket where CNPlanDetailsId=@planId) --AND CNPLanBucketId=13;  
  
      OPEN @MyCursor  
      FETCH NEXT FROM @MyCursor  
      INTO @BucketId,@FacilityId,@CappingLimit,@FacilityType  
   --PRINT @@FETCH_STATUS  
   --PRINT 'LOLA'  
      WHILE @@FETCH_STATUS=0 --WHILE SECTION START  
            BEGIN   
            --PRINT @BucketId;  
            IF @FacilityId=0 AND @FacilityType IS NOT NULL ---SELECT ALL SECTION FOR FACILITY ID 0 IS START IF CONDITION  
            BEGIN  --SECTION  START FOR SELECT ALL SECTION BEGIN PART  
            IF @FacilityType = 'TEST'  
               BEGIN  
               INSERT INTO  @CappingLimitPlanBucket (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)   
                  SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,@FacilityType,FacilityName from FacilitiesMaster WHERE FacilityType=@FacilityType AND IsActive='Y' and CategoryId=1 
				  --AND FacilityGroup='Diagnostics';  
      END  
            ELSE IF @FacilityType='SCAN'  
                 BEGIN  
                 INSERT INTO  @CappingLimitPlanBucket          (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)   
                    SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,@FacilityType,FacilityName      from FacilitiesMaster WHERE IsActive='Y' and CategoryId=2 AND         FacilityGroup='Diagnostics';  
              END  
            ELSE IF @FacilityType='Package'  
                 BEGIN  
                 INSERT INTO  @CappingLimitPlanBucket (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)   
                    SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,FacilityType,FacilityName from FacilitiesMaster WHERE FacilityType=@FacilityType AND IsActive='Y' AND FacilityGroup='Diagnostics';  
              END  
        ELSE IF @FacilityType='Tele-Consultation'  
                 BEGIN  
        print 'lola'  
                 INSERT INTO  @CappingLimitPlanBucket (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)   
                    SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,@FacilityType,FacilityName from FacilitiesMaster WHERE IsActive='Y' AND  
        NTCSpecialityID != 0  and NTCSpecialityID is not null   
        AND FacilityGroup='Tele-Consultation';  
              END  
            ELSE   
                 BEGIN  
                 INSERT INTO  @CappingLimitPlanBucket (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)  
              SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,@FacilityType,FacilityName from FacilitiesMaster  
              WHERE FacilityGroup=@FacilityType AND  IsActive='Y'  
              END  
  
         END-- SECTION  END FOR SELECT ALL SECTION BEGIN PART  
        
      ---SELECT ALL SECTION FOR FACILITY ID 0 IS END IF CONDITION  
  
  
         ELSE --IF  FacilityType IS NULL  
           BEGIN  
        DECLARE @FType varchar(200);  
     DECLARE @FGroup varchar(200);  
     DECLARE @CateId BIGINT ;  
     SELECT @CateId= CategoryId FROM FacilitiesMaster WHERE FacilityId=@FacilityId;  
     SELECT @FGroup=FacilityGroup FROM FacilitiesMaster WHERE FacilityId=@FacilityId;  
     IF @FGroup='Diagnostics' AND @FacilityId <> 0 AND @CateId <> 2  
         BEGIN  
         SELECT @FType=FacilityType FROM FacilitiesMaster WHERE FacilityId=@FacilityId;  
      END  
     ELSE IF @CateId = 2  
         BEGIN  
         SET @FType='SCAN';  
      END  
     ELSE  
         BEGIN  
         SELECT @FType=FacilityGroup FROM FacilitiesMaster WHERE FacilityId=@FacilityId;  
      END  
              INSERT INTO  @CappingLimitPlanBucket (BucketId,CappingLimit,FacilityId,FacilityType,FacilityName)   
           SELECT DISTINCT @BucketId,@CappingLimit,FacilityId,@FType,FacilityName from FacilitiesMaster WHERE FacilityId=@FacilityId;  
           END  
  
  
        FETCH NEXT FROM @MyCursor   
        INTO @BucketId,@FacilityId,@CappingLimit,@FacilityType;  
         END --WHILE SECTION END  
         CLOSE @MyCursor;  
         DEALLOCATE @MyCursor;  
  
      
   END --ALGORITHM END  
  -- WHERE FacilityType='PACKAGE'  
  
  DECLARE @FinalCappingLimitPlanBucket TABLE (BucketId BIGINT,CappingLimit DECIMAL, FacilityId BIGINT,  
           FacilityType VARCHAR(300), FacilityName VARCHAR(300));  
  
  DECLARE @FacilityName VARCHAR(300);  
  
  SET @MyCursor =  CURSOR FOR SELECT BucketId,CappingLimit,FacilityId,FacilityType,FacilityName FROM @CappingLimitPlanBucket  
  
  OPEN @MyCursor  
  FETCH NEXT FROM @MyCursor  
      INTO @BucketId,@CappingLimit,@FacilityId,@FacilityType,@FacilityName  
   --PRINT @@FETCH_STATUS  
   --PRINT 'LOLA'  
      WHILE @@FETCH_STATUS=0 --WHILE SECTION START  
           BEGIN  
        IF EXISTS (SELECT 1 FROM @FinalCappingLimitPlanBucket WHERE BucketId=@BucketId AND FacilityId=@FacilityId)  
             BEGIN  
          IF @CappingLimit IS NOT NULL  
          BEGIN  
             UPDATE @FinalCappingLimitPlanBucket SET CappingLimit=@CappingLimit WHERE BucketId=@BucketId AND FacilityId=@FacilityId   
          END  
       END  
                 ELSE  
        BEGIN  
        INSERT INTO @FinalCappingLimitPlanBucket   
        SELECT @BucketId,@CappingLimit,@FacilityId,@FacilityType,@FacilityName;  
     END  
  
        FETCH NEXT FROM @MyCursor   
           INTO @BucketId,@CappingLimit,@FacilityId,@FacilityType,@FacilityName;  
     END  
     CLOSE @MyCursor;  
           DEALLOCATE @MyCursor;  
   --SELECT * FROM @FinalCappingLimitPlanBucket WHERE FacilityId=4  
  
   SELECT * FROM @FinalCappingLimitPlanBucket ORDER BY BucketId;  
     
END