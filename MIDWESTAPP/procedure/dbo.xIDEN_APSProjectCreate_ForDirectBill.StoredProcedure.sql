USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xIDEN_APSProjectCreate_ForDirectBill]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Sara Knight
-- Create date: <Create Date,,7/11/2006>
-- Updates:
--	CyGen - 4/17/2007 KJ - no longer creates PJPENT records, instead it updates the existing PJPENT records with the taxvalue from teh user table
-- Description:	<Adapten from xIDEN_APSProjectCreate with small changes to support direct bill functionality
-- Modified:    Dan Bertram
-- Modify Date: 4/26/2012
-- Description: Commented out the EXEC msdb.dbo.sp_start_job N'TRAPS Project Export' line because we no longer use this job to export the data.
-- =============================================
CREATE PROCEDURE [dbo].[xIDEN_APSProjectCreate_ForDirectBill] 
	@Project varchar(16), @user varchar(30)
AS
BEGIN
	DECLARE @Result int
	DECLARE @IsDirectBill bit
	
		
	IF NOT EXISTS (SELECT * FROM PJPROJ, (SELECT * FROM	PJCONTRL WHERE Control_Code = 'APSJOBSETUP') PC WHERE Project = LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10)))
		BEGIN
			SET @Result = 0

			--CyGen - KJ - 3/8/2007
			--this is a direct bill job. check to see if it is already in the xTRAPS_JOBHDR table
			--if it is set @Result = 1 (job already exists) and jump to the end
			declare @DoesExist as varchar(20)
			set  @DoesExist = (SELECT job_number from xTRAPS_JOBHDR where job_number = @Project)
			set @DoesExist = ltrim(rtrim(@DoesExist))
			if @DoesExist <> ''
				BEGIN
					SET @Result = 1
					GOTO ReturnData
				END
			--Cygen - SK - 2/22/07
			--When DirectBill = 1 row do not need to be created for PJPROJ, PJPROJEX, and PJPROJEM
			--SQL statements adding were removed. 
			--The original store procedure xIDEN_APSProject Create does. 			

				--Create TRAPS Export entry
--			SET IDENTITY_INSERT [xTRAPS_JOBHDR] ON
			INSERT INTO [xTRAPS_JOBHDR]
					   ([job_number]
					   ,[job_title]
					   ,[parent_job]
					   ,[child_job]
					   ,[status]
					   ,[progress]
					   ,[noteid]
					   ,[sub_prod_code]
					   ,[date_created]
					   ,[billable]
					   ,[trigger_status])
				 SELECT
					   @Project
					   ,P.project_desc
					   ,''
					   ,''
					   ,'A'
					   ,'W'
					   ,0
					   ,P.pm_id02
					   ,GETDATE()
					   ,'Y'
					   ,'RI'
				FROM
					(SELECT
							*
						 FROM
							PJCONTRL
						 WHERE
							Control_Code = 'APSJOBSETUP') PC
						INNER JOIN xJobTypeDefault JD ON
							RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
						PJPROJ P
				WHERE
						P.Project = @Project

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 3
				END
		-- Gets the taxid00 value to enter data into the fipsnum column
			DECLARE @Taxid00 char (10)
			Set @Taxid00 = (SELECT taxid00 FROM Customer,(SELECT customer FROM PJPROJ WHERE Project = @Project) PP WHERE customer.custid = PP.customer)
	
			--CyGen 4/17/2007 KJ
			--don't need to insert into PJPENT as the function codes are already there.  Instead, update fips_num with the new taxInfo
			update [dbo].[PJPENT] SET [fips_num] = @Taxid00 WHERE [project] = @Project

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 4
				END

--			SET IDENTITY_INSERT [xTRAPS_JOBHDR] OFF
		END
	ELSE
		BEGIN
			SET @Result = 1
			GOTO ReturnData
		END

	--CyGen - 3-2-2007 KJ
	--change the stored procedure to use the test job
	--EXEC msdb.dbo.sp_start_job N'Traps Project Export'
	-- DAB - 4/25/2012
	-- Commenting this out because we no longer use this job to export the job information over
	-- we use the WKMJG jobs to pass the data. 
	--EXEC msdb.dbo.sp_start_job N'TRAPS Project Export'

	GOTO ReturnData
ReturnData:
	SELECT @Result as Result
END
GO
