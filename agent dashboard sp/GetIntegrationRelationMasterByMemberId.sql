USE [HaProduct]
GO
/****** Object:  StoredProcedure [dbo].[GetIntegrationRelationMasterByMemberId]    Script Date: 5/7/2024 1:32:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetIntegrationRelationMasterByMemberId '532038'
--SELECT * FROM RelationMaster
ALTER PROCEDURE [dbo].[GetIntegrationRelationMasterByMemberId]  
@MemberId BIGINT,
@CaseNo VARCHAR(100),
@OnCaseFlag VARCHAR(100)
AS
BEGIN
   IF @OnCaseFlag = 'TRUE'
     BEGIN
	   SELECT @MemberId = MemberId from Appointment where caseNo=@CaseNo;
	 END
  print @MemberId
  if (select Relation from Member where MemberId=@MemberId) ='SELF'
  BEGIN
    SELECT 'Self' as IntegrationRelationMaster,MemberId from Member where MemberId=@MemberId
	RETURN
  END
  select rm.IntegrationRelationMaster,m.MemberId from RelationMaster rm
  join Member m on m.Relation=rm.RelationCode
  where m.MemberId=@MemberId
END