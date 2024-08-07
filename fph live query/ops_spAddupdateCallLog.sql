USE [HaProductsUAT]
GO
/****** Object:  StoredProcedure [dbo].[ops_spAddupdateCallLog]    Script Date: 2/12/2024 4:58:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------
ALTER PROC [dbo].[ops_spAddupdateCallLog]
(        
@AppointmentId bigint=0,          
@MemberId bigint,          
@UserLoginId bigint,          
@StatusId int,          
@CallResponseId int,          
@NextCallDate varchar(50)=null,          
@CallFor varchar(500)=null,          
@CallType varchar(50)='Outbound',          
@UserName varchar(50)=null,          
@Remarks varchar(500)=null,          
@MemberPlanId bigint=null,        
@OpsMenuName varchar(200)=null,
@IsWithNewPlan VARCHAR(200)=NULL
)        
AS          
BEGIN -- 1st Begin          
          
  DECLARE @CallStatus int;          
  DECLARE @Memberdetailscnt int = 0;          
  DECLARE @NumberOfCall int = 0;          
  DECLARE @MemCallId bigint = 0;          
   DECLARE @MemCallId1 bigint = 0;          
          
  SET @MemCallId1 = (SELECT          
     Max(MemCallId)          
  FROM MemberCallDetails          
  WHERE UserLoginId = @UserLoginId)          
          
  if(@MemCallId1 <> 0)          
  BEGIN          
  set @CallStatus = (Select StatusId from MemberCallDetails where MemCallId=@MemCallId1)          
  END          
          
  SET @Memberdetailscnt = (SELECT          
    COUNT(MemberId)          
  FROM MemberCallDetails          
  WHERE MemberId = @MemberId)          
          
  SET @NumberOfCall = (SELECT          
    COUNT(mcl.MemCallId)          
  FROM MemberCallLog mcl          
  JOIN MemberCallDetails mcd          
    ON mcl.MemCallId = mcd.MemCallId          
  WHERE mcd.MemberId = @MemberId)
  
  DECLARE @UserPlandetailsId BIGINT=NULL;
  IF @IsWithNewPlan='Y'
    BEGIN
	  Set @UserPlandetailsId = @MemberPlanId;
	  SET @MemberPlanId=NULL;
	END

          
 -- IF (@Memberdetailscnt = 0)          
 -- BEGIN -- 2nd Begin          
 --   INSERT INTO MemberCallDetails (        
 --  MemberId          
 --   , UserLoginId          
 --   , StatusId          
 --   , NextCallDate          
 --   , CallFor          
 --   , NoofCall          
 --   , CallType          
 --   , CreatedBy          
 --   , CreatedDate          
 --   ,AppointmentId          
 --   ,MemberPlanId        
 --,OpsMenuName        
 --)          
 --     VALUES (@MemberId, @UserLoginId, @StatusId, @NextCallDate, @CallFor, @NumberOfCall + 1, @CallType, @UserName, GETDATE(),@AppointmentId, @MemberPlanId,@OpsMenuName )          
 --   SET @MemCallId = (SELECT          
 --     SCOPE_IDENTITY())          
          
 --   INSERT INTO MemberCallLog (MemCallId,          
 --   StatusId,          
 --   CallStatusId,          
 --   NextCallDate,          
 --   CallFor,          
 --   CallType,          
 --   Remark,          
 --   CreatedBy,          
 --   CreatedDate,           
 --AppointmentId,          
 --MemberPlanId)          
 --     VALUES (@MemCallId, @StatusId, @CallResponseId, @NextCallDate, @CallFor, @CallType, @Remarks, @UserName, GETDATE(), @AppointmentId,@MemberPlanId)          
          
          
 -- END -- 2nd Begin END          
 -- ELSE          
 -- BEGIN  -- 3rd Begin           
 --   IF (@CallStatus = 14          
 --     OR @CallStatus = 16) -- If case is Completed or aborted then new entry in Both tables          
 --   BEGIN -- 4th Begin          
 --     INSERT INTO MemberCallDetails (MemberId          
 --     , UserLoginId          
 --     , StatusId          
 --     , NextCallDate          
 --     , CallFor          
 --     , NoofCall          
 --     , CallType          
 --     , CreatedBy          
 --     , CreatedDate         
 --     , AppointmentId          
 --     ,MemberPlanId        
 --  ,OpsMenuName        
 --  )          
 --       VALUES (@MemberId, @UserLoginId, @StatusId, @NextCallDate, @CallFor, @NumberOfCall + 1, @CallType, @UserName, GETDATE(), @AppointmentId,@MemberPlanId,@OpsMenuName)          
 --     SET @MemCallId = (SELECT          
 --       SCOPE_IDENTITY())          
          
 --     INSERT INTO MemberCallLog (MemCallId,          
 --     StatusId,          
 --     CallStatusId,          
 --     NextCallDate,          
 --     CallFor,          
 --     CallType,          
 --     Remark,          
 --     CreatedBy,          
 --     CreatedDate,          
 --  AppointmentId,          
 --  MemberPlanId)          
 --       VALUES (@MemCallId, @StatusId, @CallResponseId, @NextCallDate, @CallFor, @CallType, @Remarks, @UserName, GETDATE(),@AppointmentId,@MemberPlanId)          
          
 --   END -- 4th Begin END          
 --ELSE          
 --BEGIN -- 5th Begin Start          
          
 --Update MemberCallDetails set          
 -- MemberId = @MemberId,          
 -- UserLoginId = @UserLoginId,          
 -- StatusId = @StatusId,          
 -- NextCallDate = @NextCallDate,          
 -- CallFor = @CallFor,          
 -- NoofCall = @NumberOfCall + 1,          
 -- CallType = @CallType,          
 -- updatedby = @UserName,          
 -- updateddate = getdate(),          
 -- AppointmentId=@AppointmentId,          
 -- MemberPlanId=@MemberPlanId ,        
 -- OpsMenuName=@OpsMenuName        
 -- where MemCallId = @MemCallId1          
             
            
 --     INSERT INTO MemberCallLog (MemCallId,          
 --     StatusId,          
 --     CallStatusId,          
 --     NextCallDate,          
 --     CallFor,          
 --     CallType,          
 --     Remark,          
 --     CreatedBy,          
 --     CreatedDate,          
 --  AppointmentId,          
 --  MemberPlanId)          
 --       VALUES (@MemCallId1, @StatusId, @CallResponseId, @NextCallDate, @CallFor, @CallType, @Remarks, @UserName, GETDATE(),@AppointmentId,@MemberPlanId)          
          
 --END -- 5th Begin End          
 -- END-- 3rd Begin END          
     INSERT INTO MemberCallDetails (        
   MemberId          
    , UserLoginId          
    , StatusId          
    , NextCallDate          
    , CallFor          
    , NoofCall          
    , CallType          
    , CreatedBy          
    , CreatedDate          
    ,AppointmentId          
    ,MemberPlanId
	,UserPlanDetailsId
 ,OpsMenuName        
 )          
      VALUES (@MemberId, @UserLoginId, @StatusId, @NextCallDate, @CallFor, 1, @CallType, @UserName, GETDATE(),@AppointmentId, @MemberPlanId,@UserPlandetailsId,@OpsMenuName )          
    SET @MemCallId = (SELECT          
      SCOPE_IDENTITY())          
          
    INSERT INTO MemberCallLog (MemCallId,          
    StatusId,          
    CallStatusId,          
    NextCallDate,          
    CallFor,          
    CallType,          
    Remark,          
    CreatedBy,          
    CreatedDate,           
 AppointmentId,          
 MemberPlanId)          
      VALUES (@MemCallId, @StatusId, @CallResponseId, @NextCallDate, @CallFor, @CallType, @Remarks, @UserName, GETDATE(), @AppointmentId,@MemberPlanId)                
          
  select @userLoginId as userLoginId         
          
END -- 1st Begin ENd 