USE [HAProduct]
GO
/****** Object:  StoredProcedure [dbo].[UspUpdateBulkBookingStatus]    Script Date: 1/25/2024 3:27:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----select * from statusmaster  where StatusId in (1,2,8,4,9,12,7,9,6)
---select * from  appointment where caseno='HA12042023HJDDE' --acn
---update appointment set ScheduleStatus=8 where  caseno='HA12042023HJDDE'
---exec UspUpdateBulkBookingStatus 'HA12042023HJDDE','rt',null
---exec UspUpdateBulkBookingStatus 'HA12042023HJDDE','Closed',null
-----------------------------------------

ALTER PROCEDURE [dbo].[UspUpdateBulkBookingStatus]
@CaseNo varchar(100),
@schedulestatus varchar(100),
@Remark varchar(100)=NULL,
@UploadedBy varchar(100)=NULL
  

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
			  set @Message= @Message+'Appointment is already in cancel status,  ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
    --      else if @ExistingStatus=6 and @StatusId=7
    --      begin
    --         print 'Appointment is not cancel because already in closed status'
			 --set @Message= @Message+'Cannot perform this action because Appointment is already in closed status, ' 
		  --   set @ColumnName= @ColumnName+'Scedulestatus, '
    --      end
          else if @ExistingStatus=4 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Partial Show status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Partial Show status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=9 and @StatusId in (1,2,8,4,9,12,7)
          begin
             print 'Appointment is not cancel because alredy in Send to QC status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Send to QC status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=12 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in QC Completed status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in QC Completed status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=8 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in ReportPending status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in ReportPending status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=11 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Report On Hold status'
			  set @Message= @Message+'Cannot perform this action because Appointment is alredy in Report On Hold status, ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=43 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Sample Collected status'
			  set @Message= @Message+'Cannot perform this action because Appointment is alredy in Sample Collected status, ' 
		      set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=47 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Phlebo Assign status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Phlebo Assign status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=49 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Phlebo Reached status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Phlebo Reached status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
          else if @ExistingStatus=44 and @StatusId=7
          begin
             print 'Appointment is not cancel because alredy in Sample Received at Lab status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in Sample Received at Lab status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		  else if @ExistingStatus=7 and @StatusId=6
          begin
             print 'Appointment is not closed because already in cancel status'
			 set @Message= @Message+'Cannot perform this action because Appointment is alredy in cancel status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
		  else if @ExistingStatus=6 and @StatusId in (1,2,8,4,9,12,7)
          begin
             print 'Appointment is not cancel because already in closed status'
			 set @Message= @Message+'Cannot perform this action because Appointment is already in closed status, ' 
		     set @ColumnName= @ColumnName+'Scedulestatus, '
          end
	      else
          begin
	  
	                  ----Appointment table-----------------------
	                  
	                  update [HaProductsUAT].DBO.[Appointment] set schedulestatus=@StatusId,UpdatedBy=@UploadedBy,UpdatedDate=getdate() where AppointmentId=@AppointmentId;
	       	          set @Message= @Message+'Appointment Status is updated successfully as ' +@schedulestatus
		              set @ColumnName= @ColumnName+'Scedulestatus, '
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
		                  		
		                  		 
	                    
                                  If @StatusId=7
                                  BEGIN
                                  
                                       update [HaProductsUAT].DBO.[MemberPlanDetails] 
                                  	 set Points=NULL,Isactive='N',IsUtilized='N', UpdatedBy=@UploadedBy,UpdatedDate=getdate() 
                                  	 where AppointmentId=@AppointmentId;
                                  
                                  
                                  END
			           ----------------------------------------------------------------------------------
					   print 'Appointment is cancel successfully'
			
                   END
			END
			Else
			BEGIN

			    set @Message= @Message+'Please enter correct statusname because this status not exist in statusmaster table, ' 
		        set @ColumnName= @ColumnName+'Scedulestatus, '

			END

        --SELECT @ColumnName AS ColumnName, @Message AS Message
	  INSERT INTO ##GlobalLogResultCampBookingStatus VALUES(@ColumnName,@Status,@Success,@Message)
	  

			          
			          	 
			          
END			          