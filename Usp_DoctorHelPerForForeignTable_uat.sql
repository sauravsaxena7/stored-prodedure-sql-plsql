USE [HAModuleUAT]
GO
/****** Object:  StoredProcedure [tele_consultaion].[Usp_DoctorHelPerForForeignTable]    Script Date: 11/24/2023 1:29:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [tele_consultaion].[Usp_DoctorHelPerForForeignTable]  8, 331, 2, 0 ,'Y', 'lang', 'EDIT'
ALTER PROCEDURE [tele_consultaion].[Usp_DoctorHelPerForForeignTable]    
 @foreignId int --@languageId @qualificationId  @specialtyId @casetypeId
,@doctorId int    
,@CreatedBy int 
,@CaseTypePriority int =0
,@IsThisFirstElement varchar (1)
,@foreignFlag varchar(30)
,@flag varchar(10)
AS    
BEGIN    
    
SET NOCOUNT ON;
    DECLARE @count int = 0;
	PRINT'LOLA'
    IF (@flag='ADD' AND @foreignId!=-1)
	  BEGIN-- add start
	  print'ADD'
	     IF (@foreignFlag='lang')
		   BEGIN--lang start
		      INSERT INTO [tele_consultaion].[Doctorlanguage]([doctorId],[languageId],[Deleted],[CreatedBy],[CreatedDate] )    
              VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE()) 
		   END--lang end
		 ELSE IF(@foreignFlag='qualification')
		       BEGIN--qalification start
		          INSERT INTO [tele_consultaion].[DoctorQualification]([doctorId],[qualificationId],[Deleted],[CreatedBy],[CreatedDate])    
                  VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE());
		       END--qalification end
		 ELSE IF (@foreignFlag='caseType')
		      BEGIN--case type start
		         INSERT INTO [DoctorCasetype]([doctorId],[casetypeId],[Deleted],[CreatedBy],[CreatedDate],CaseTypePriority)
	             VALUES(@doctorId,@foreignId,0,@CreatedBy,GetDate(),@CaseTypePriority)
		      END---case type end
		ELSE
		  BEGIN
		     INSERT INTO [tele_consultaion].[DoctorSpecialty]([doctorId],[specialtyId],[Deleted],[CreatedBy]   ,[CreatedDate])   
             VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE())
		  END		
	  END--add end
    ELSE IF (@flag='EDIT' AND @foreignId !=-1)
	  BEGIN-- EDIT PART START
	  PRINT 'EDIT'
	     IF @foreignFlag = 'lang'
		   BEGIN--lang part start
		     IF @IsThisFirstElement='Y'
			   BEGIN
			      UPDATE [tele_consultaion].[Doctorlanguage] SET Deleted=1 WHERE doctorId=@doctorId;
			   END
             SELECT @count =  COUNT(languageId) FROM [tele_consultaion].[Doctorlanguage] WHERE doctorId=@doctorId AND languageId=@foreignId;
			 print'count lang'
			 print @count
			 IF (@count=0)
			   BEGIN
			      INSERT INTO [tele_consultaion].[Doctorlanguage]([doctorId],[languageId],[Deleted],[CreatedBy],[CreatedDate] )    VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE()) 
			   END
			ELSE
			  BEGIN --HERE LANGUAGE IS EXIST FOR CORRESPONDING DOCTORID NEED TO UPDATE
			     UPDATE [tele_consultaion].[Doctorlanguage] SET Deleted=0 WHERE doctorId=@doctorId AND languageId=@foreignId;
			  END
		   END----lang part end
		ELSE IF (@foreignFlag='qualification')
		     BEGIN--qualification part start
			   IF @IsThisFirstElement='Y'
			     BEGIN
			        UPDATE [tele_consultaion].[DoctorQualification] SET Deleted=1 WHERE doctorId=@doctorId;
			     END
			   SELECT @count =  COUNT(qualificationId) FROM [tele_consultaion].[DoctorQualification] WHERE doctorId=@doctorId AND qualificationId=@foreignId;
			   IF (@count=0)
			     BEGIN
			        INSERT INTO [tele_consultaion].[DoctorQualification]([doctorId],[qualificationId],[Deleted],[CreatedBy],[CreatedDate])    
                    VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE());
			     END
			ELSE
			  BEGIN --HERE Qualification IS EXIST FOR CORRESPONDING DOCTORID NEED TO UPDATE
			     UPDATE [tele_consultaion].[DoctorQualification] SET Deleted=0 WHERE doctorId=@doctorId 
				 AND qualificationId=@foreignId
			  END
			 END--qualification part end

        ELSE IF (@foreignFlag='caseType')
		     BEGIN--caseType Start 
			   IF @IsThisFirstElement='Y'
			     BEGIN
			        UPDATE [DoctorCasetype] SET Deleted=1 WHERE doctorId=@doctorId;
			     END
			   SELECT @count =  COUNT([casetypeId]) FROM [DoctorCasetype] WHERE doctorId=@doctorId AND [casetypeId]=@foreignId;
			   IF (@count=0)
			     BEGIN
			        INSERT INTO [DoctorCasetype]([doctorId],[casetypeId],[Deleted],[CreatedBy],[CreatedDate],CaseTypePriority)
	                VALUES(@doctorId,@foreignId,0,@CreatedBy,GetDate(),@CaseTypePriority)
			     END
			ELSE
			  BEGIN --HERE [DoctorCasetype] IS EXIST FOR CORRESPONDING DOCTORID NEED TO UPDATE
			     UPDATE [DoctorCasetype] SET Deleted=0, CaseTypePriority=@CaseTypePriority WHERE doctorId=@doctorId 
				 AND [casetypeId]=@foreignId
			  END

			 END--caseType End
	    ELSE
		  BEGIN -- speciality part start
		     IF @IsThisFirstElement='Y'
			     BEGIN
			        UPDATE [tele_consultaion].[DoctorSpecialty] SET Deleted=1 WHERE doctorId=@doctorId;
			     END
			   SELECT @count =  COUNT([specialtyId]) FROM [tele_consultaion].[DoctorSpecialty] WHERE doctorId=@doctorId AND [specialtyId]=@foreignId;
			   IF (@count=0)
			     BEGIN
			        INSERT INTO [tele_consultaion].[DoctorSpecialty]([doctorId],[specialtyId],[Deleted],[CreatedBy]   ,[CreatedDate])   
                    VALUES(@doctorId,@foreignId,0,@CreatedBy,GETDATE())
			     END
			ELSE
			  BEGIN --HERE Qualification IS EXIST FOR CORRESPONDING DOCTORID NEED TO UPDATE
			     UPDATE  [tele_consultaion].[DoctorSpecialty] SET Deleted=0 WHERE doctorId=@doctorId 
				 AND [specialtyId]=@foreignId
			  END
		  END -- speciality part end

	  END--   EDIT PART END
    ELSE if(@flag='EDIT' AND @foreignId=-1)
	     BEGIN
		 PRINT '---1'
		    IF(@foreignFlag='lang')
			  BEGIN
			      UPDATE [tele_consultaion].[Doctorlanguage] SET Deleted=1 WHERE doctorId=@doctorId;
			  END
			ELSE IF(@foreignFlag='qualification')
			     BEGIN
			       UPDATE [tele_consultaion].[DoctorQualification] SET Deleted=1 WHERE doctorId=@doctorId;
			     END
			ELSE IF (@foreignFlag='caseType')
			     BEGIN
				    UPDATE [DoctorCasetype] SET Deleted=1 WHERE doctorId=@doctorId;
				 END
			ELSE
			  BEGIN
			     UPDATE [tele_consultaion].[DoctorSpecialty] SET Deleted=1 WHERE doctorId=@doctorId;
			  END
		 END
END