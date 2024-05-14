USE [HaProduct]
GO
/****** Object:  StoredProcedure [dbo].[ops_spAddupdateCallLog]    Script Date: 2/27/2024 1:37:09 PM ******/
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