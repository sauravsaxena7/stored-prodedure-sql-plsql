USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspUpdateBulkBookingStatus]    Script Date: 1/27/2024 11:55:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----select * from statusmaster  where StatusId in (1,2,8,4,9,12,7,9,6)
---select * from  appointment  where caseno='HA23012024DFAGHI' --acn
---update appointment set ScheduleStatus=8 where  caseno='HA12042023HJDDE'
---exec UspUpdateBulkBookingStatus 'HA12042023HJDDE','rt',null
---exec UspUpdateBulkBookingStatus 'HA12042023HJDDE','Cancelled',null
---exec UspUpdateBulkBookingStatus 'HA12042023HJDDE','Confirmed',null
--exec UspUpdateBulkBookingStatus 'HA23012024BACGBG','ReportPending',null,null,'Y'


-----------------------------------------

ALTER PROCEDURE [dbo].[UspUpdateBulkBookingStatus]
@CaseNo varchar(100),
@schedulestatus varchar(100),
@Remark varchar(100)=NULL,
@UploadedBy varchar(100)=NULL,
@IsWithNewPlan VARCHAR(100)='N'
  

AS
BEGIN

      declare @ColumnName varchar(100)='';
      declare @Status int=0;
      declare @Success varchar(100)='False';
	  declare @Message varchar(MAX)='';

      Declare @StatusId varchar(100)=(select TOP 1 StatusId from statusmaster  where StatusName=@schedulestatus  and isactive='Y');
      print @StatusId;



	  Declare @ExistingStatus varchar(100)=(select schedulestatus from appointment where caseno=@CaseNo);
	  print  @ExistingStatus;

	  DECLARE  @ExistingStatusName varchar(100)=(select StatusName from StatusMaster  where Statusid=@ExistingStatus);
	  print @ExistingStatusName

	  declare @AppointmentId bigint= (select AppointmentId from appointment where caseno=@CaseNo );
	  
      if @StatusId is not null
	  begin
	  
	      if @ExistingStatus=7 and @StatusId=7
          begin
              print 'Appointment is already in cancel status'
			  set @Message= @Message+'Appointment is in cancel status,  ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
	      else if @ExistingStatus=8 and @StatusId in (1,2)
          begin
             print 'cannot perform this action because Appointment is already in ReportPending status'
			 set @Message= @Message+'cannot perform this action because Appointment is in ReportPending status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		  else if @ExistingStatus=1 and @StatusId =8
		  begin
		    print 'Appointment is not in confirmed status not go for report pending'
			  set @Message= @Message+'Appointment Need to confirmed first then it will goes into Report Pending Status,  ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
		  end
          else if @ExistingStatus=4 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Partial Show status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Partial Show status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=9 and @StatusId in (1,2,8,4,9,12,7)
          begin
             print 'Appointment is not cancel because alredy in Send to QC status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in Send to QC status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=12 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in QC Completed status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in QC Completed status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=8 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in ReportPending status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in ReportPending status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=11 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Report On Hold status'
			  set @Message= @Message+'Cannot perform this action because Appointment is in Report On Hold status, ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=43 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Sample Collected status'
			  set @Message= @Message+'Cannot perform this action because Appointment is in Sample Collected status, ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=47 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Phlebo Assign status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in Phlebo Assign status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=49 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Phlebo Reached status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in Phlebo Reached status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=44 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Sample Received at Lab status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in Sample Received at Lab status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		  else if @ExistingStatus=7 and @StatusId in (1,2,8,4,9,12,7,6)
          begin
             print 'Appointment is not closed because already in cancel status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in cancel status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		  else if @ExistingStatus=6 and @StatusId in (1,2,8,4,9,12,7)
          begin
             print 'Appointment is not cancel because already in closed status'
			 set @Message= @Message+'Cannot perform this action because Appointment is in closed status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		   else if @ExistingStatus=2 and @StatusId in (1)
          begin
             print 'Appointment  not tagged in requested status because already in confirmed status'
			 set @Message= @Message+'Appointment  not tagged in requested status because already in confirmed status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		else if @AppointmentId is null
		begin
		 print 'Appointment NOT FOUND'
			 set @Message= @Message+'Appointment NOT FOUND, ' 
		     set @ColumnName= @ColumnName+'@AppointmentId, '
		end
	      else
          begin
	                 
	                  ----Appointment table-----------------------
	                  
	                  update [HaProduct].DBO.[Appointment] set schedulestatus=@StatusId,UpdatedBy=@UploadedBy,UpdatedDate=getdate() where AppointmentId=@AppointmentId;
	       	          
	                  ----Appointment  Log table-----------------
	       	          
	                  DECLARE @LastApptLogId varchar(100);
	       	          
	                  INSERT INTO [AppointmentLog] ([AppointmentId]                                            
                         , [ScheduleStatus]                                            
                         , [Remarks]                                            
                         , [UserLoginId]                                            
                         , [CreatedBy]                                            
                         , [CreatedDate])                                            
                           VALUES (@AppointmentId, @StatusId, @Remark, null,@UploadedBy, GETDATE())                                            
                                                           
                         SELECT @LastApptLogId = SCOPE_IDENTITY();                                            
                                                           
                         PRINT @LastApptLogId      
                       
                            
	       	          
	                  ----AppointmentLogDetails -Table-------
			          
			          
	                     Declare @Tmp table (AppointmentLogId varchar(100),AppointmentDetailId varchar(100),AppointmentDateTime datetime,
	                                        TestCompletionStatus varchar(10),ProviderId  varchar(100),HomeVisit varchar(100),CreatedBy varchar(100),CreatedDate datetime,
		                  				  FacilityAmount   varchar(10)
		                  				  )
                                             
                                  insert into @Tmp   (
	                                         AppointmentLogId,AppointmentDetailId,AppointmentDateTime,
	                                        TestCompletionStatus,ProviderId,HomeVisit,CreatedBy,CreatedDate,FacilityAmount)
		                  				 
	                    
		                  				  select al.AppointmentLogId,ad.AppointmentDetailId,ad.AppointmentDateTime,
		                  				  ad.TestCompletionStatus,ad.providerid,ad.HomeVisit,ad.UpdatedBy,Getdate(),ad.FacilityAmount
		                  				  from AppointmentLog al join AppointmentDetails  ad on ad.AppointmentId=al.AppointmentId
		                  				  where ad.AppointmentId=@AppointmentId and al.AppointmentLogId=@LastApptLogId   
		                  				  
		                  				                   
                                             insert into AppointmentLogDetails
		                  				  (AppointmentLogId,AppointmentDetailId,AppointmentDateTime,
	                                        TestCompletionStatus,ProviderId,HomeVisit,CreatedBy,CreatedDate,FacilityAmount)
	                                        
                                             select tt.AppointmentLogId,tt.AppointmentDetailId,tt.AppointmentDateTime,
		                  				   tt.TestCompletionStatus,tt.ProviderId,tt.HomeVisit,tt.CreatedBy,tt.CreatedDate,tt.FacilityAmount
	                    
                                            from @Tmp tt
		                                    
                                  DECLARE @AppointmentLogDetailsId varchar(100);
                                  select  @AppointmentLogDetailsId  = SCOPE_IDENTITY();  
		                  		
		                  		 
	                    
                                  If @StatusId=7 and @IsWithNewPlan!='Y' and @IsWithNewPlan is null
                                  BEGIN
                                  
                                       update [HaProduct].DBO.[MemberPlanDetails] 
                                  	 set Points=NULL,Isactive='N',IsUtilized='N', UpdatedBy=@UploadedBy,UpdatedDate=getdate() 
                                  	 where AppointmentId=@AppointmentId;
                                  
                                  
                                  END
								  else If @StatusId=7 and @IsWithNewPlan='Y'
								  BEGIN
								  print 'WITH NEW PLAN'
								    --SELECT TOP 10 * FROM MemberBucketBalance ORDER BY 1 DESC
									--select top 100 * from Appointment order by 1 desc
									--select * From Appointment WHERE MemberId=531688
									--SELECT TOP 10 * from UserLogin order by 1 desc
									--select * from Member where userLoginId=534964
									DECLARE @UserPlanDetailsId bigint, @MemberPlanBucketId bigInt,@MemberId bigint,@UserLoginId bigint;

									SELECT @UserPlanDetailsId=UserPlanDetailsId,@MemberPlanBucketId=MemberPlanBucketID,
									@MemberId=MemberId,@UserLoginId=UserLoginId from Appointment Where AppointmentId=@AppointmentId;

									--SELECT  * FROM MemberBucketBalance Where MemberPLanBucketId=841 and UserPlanDetailsId=841 order by 1 desc and MemberId=531688 and AppointmentId=102524 and WalletTransactionType='DEBIT'

									DECLARE @SumBalanceDebit bigint,@SumOfBalanceCredit bigint ,@AmountSource varchar(150),@FacilityId bigint,@FacilityGroupId bigint;
									



									SELECT TOP 1 @AmountSource=AmountSource,
									@FacilityGroupId=FacilityGroupId,@FacilityId=Facilityids FROM MemberBucketBalance Where MemberPLanBucketId=@MemberPlanBucketId and UserPlanDetailsId=@UserPlanDetailsId and MemberId=@MemberId and AppointmentId=@AppointmentId and WalletTransactionType='DEBIT'

									SELECT @SumBalanceDebit=SUM(ISNULL(TransactionCredit,0)) from MemberBucketBalance Where UserLoginId=@UserLoginId and UserPlanDetailsId=@UserPlanDetailsId and MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y' and  WalletTransactionType='DEBIT';

									print '@SumBalanceDebit'
									print @SumBalanceDebit

									SELECT @SumOfBalanceCredit=SUM(ISNULL(TransactionCredit,0)) from MemberBucketBalance Where UserLoginId=@UserLoginId and UserPlanDetailsId=@UserPlanDetailsId and MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y' and  WalletTransactionType='CREDIT';

									print '@@SumOfBalanceCredit'
									print @SumOfBalanceCredit 

									print '@MemberPlanBucketId'
									print @MemberPlanBucketId

									DECLARE @AvailableCreditCount bigint,@TotalCredit bigint;								 
									SELECT @TotalCredit=ISNULL(TotalCredit,0) from MemberPlanBucket 
									WHERE MemberPlanBucketId=@MemberPlanBucketId and ActiveStatus='Y';

									SET @AvailableCreditCount=@TotalCredit-ISNULL(@SumBalanceDebit,0)
									PRINT '@AvailableCreditCount AFTER DEBIT'
									PRINT @AvailableCreditCount
									SET @AvailableCreditCount = @AvailableCreditCount+ISNULL(@SumOfBalanceCredit,0)

									print '@AvailableCreditCount'
									print @AvailableCreditCount

									INSERT INTO MemberBucketBalance(UserPlanDetailsId, MemberPLanBucketId,UserLoginId,MemberId,BalanceCredit,TransactionCredit ,AmountSource, WalletTransactionType, AppointmentId, ActiveStatus, CreatedDate, UpdatedDate, Facilityids, FacilityGroupId)
				VALUES(@UserPlanDetailsId, @MemberPlanBucketId,@UserLoginId,@MemberId,(@AvailableCreditCount+1) ,1,@AmountSource, 'CREDIT', @AppointmentId, 'Y', GETDATE(), GETDATE(), @FacilityId, @FacilityGroupId)



									

									Print 'credit recovery for appointment cancel'
								  END
			           ----------------------------------------------------------------------------------
					   print 'Appointment is cancel successfully'
					   set @Message= @Message+'Appointment Status is updated successfully as ' +@schedulestatus
		               set @ColumnName= @ColumnName+'Scedulestatus, '
					   set @Status=1
					   set @Success='TRUE'

			
                   END
			END
			Else
			BEGIN

			    set @Message= @Message+'Please enter correct statusname because this status not exist in statusmaster table, ' 
		        set @ColumnName= @ColumnName+'Scedulestatus, '

			END

       -- SELECT @ColumnName AS ColumnName, @Message AS Message
	  INSERT INTO ##GlobalLogResultCampBookingStatus VALUES(@ColumnName,@Status,@Success,@Message)
	  

			          
			          	 
			          
END			          