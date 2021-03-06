USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PostTimesheet]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- this SPROC is called from the 2nd step of the scheduled job "TRAPS Timesheet Import" - MSB

CREATE PROCEDURE [dbo].[xAlt_PostTimesheet] @DocNbr varchar(10)
AS

IF NOT EXISTS (SELECT * FROM PJTIMHDR WHERE docnbr = @DocNbr AND th_status = 'C')
	BEGIN
		-- If timesheet not completed, return 1001 to calling procedure
		RETURN 1001
	END

-- Get period from timesheet PJTIMHDR.th_date for posting
DECLARE @ControlData varchar(255), @PostPeriod varchar(6)

-- Get Current Fiscal Period for PA
	DECLARE @CurrentPAPeriod varchar(6)
	SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'TM' AND control_code = 'CURRENT-PERIOD'
	SET @CurrentPAPeriod = SUBSTRING(@ControlData, 1, 6)

-- Get date from header level of document
DECLARE @th_date smalldatetime
SELECT @th_date = th_date FROM PJTIMHDR WHERE docnbr = @DocNbr

-- Get info from PJWeek based on date
DECLARE @we_date smalldatetime,
		@fiscalno varchar(6),
		@WeekComment varchar(30)
SELECT TOP 1 @we_date = we_date, @fiscalno = fiscalno, @WeekComment = comment FROM pjweek WHERE we_date >= @th_date ORDER BY we_date
	
-- If current period is newer than the timesheet period, use current period, otherwise, use timesheet period
IF @fiscalno < @CurrentPAPeriod
	BEGIN
		SET @PostPeriod = @CurrentPAPeriod
	END
ELSE
	BEGIN
		SET @PostPeriod = @fiscalno
	END

-- Get control data for timesheet-info
DECLARE 
		@EQ_Charge_Acct varchar(16),
		@EQ_Offset_Acct varchar(16),
		@EQ_Charge_GLAcct varchar(10),
		@EQ_Offset_GLAcct varchar(10),
		@UOP_Charge_Acct varchar(16)
SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'PA' AND control_code = 'TIMESHEET-INFO'
SET @EQ_Charge_Acct = SUBSTRING(@ControlData, 1, 16)
SET @EQ_Offset_Acct = SUBSTRING(@ControlData, 17, 16)
SET @EQ_Charge_GLAcct = SUBSTRING(@ControlData, 33, 10)
SET @EQ_Offset_GLAcct = SUBSTRING(@ControlData, 43, 10)
SET @UOP_Charge_Acct = SUBSTRING(@ControlData, 53, 16)

-- get first day of week and post option from setup record
DECLARE @FirstDayofWeek varchar(3),
		@PostOption varchar(1)
SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'TM' AND control_code = 'SETUP'
SET @FirstDayofWeek = SUBSTRING(@ControlData, 221, 3)
SET @PostOption = SUBSTRING(@ControlData, 220, 1)

-- get info from setup1 record
DECLARE @DailyTimecards varchar(1),
		@DailyPosting varchar(1)
SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'TM' AND control_code = 'SETUP1'
SET @DailyTimecards = SUBSTRING(@ControlData, 1, 1)
SET @DailyPosting = SUBSTRING(@ControlData, 3, 1)

-- Get site info from setup record
DECLARE @SiteID varchar(20)
SELECT @ControlData = Control_data FROM PJCONTRL WHERE control_type = 'TM' AND control_code = 'SITE'
SET @SiteID = SUBSTRING(@ControlData, 1, 4)
IF RTRIM(@SiteID) = ''
	BEGIN
		SET @SiteID = '0000'
	END

-- Post directly if PostOption is Y, else post to timecards first
IF @PostOption = 'Y'
	BEGIN
		DECLARE @TotalHours float
				

		DECLARE 
			@linenbr smallint
		DECLARE csr_DirectPost CURSOR FOR
			SELECT LineNbr FROM PJTIMDET WHERE docnbr = @DocNbr ORDER BY LineNbr

		OPEN csr_DirectPost 
		FETCH NEXT FROM csr_DirectPost INTO
			@linenbr 	
		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC xAlt_PostTimesheetDirectly @DocNbr, @LineNbr, @PostPeriod
				UPDATE PJTIMDET SET tl_status = 'P', lupd_prog = 'AUTOPOST', lupd_user = 'IMPORT', lupd_datetime = GETDATE() WHERE DocNbr = @DocNbr AND LineNbr = @LineNbr
				FETCH NEXT FROM csr_DirectPost INTO
					@linenbr 	
			END

		CLOSE csr_DirectPost 
		DEALLOCATE csr_DirectPost 

	END
ELSE
	BEGIN
		RETURN 1002
	END

	UPDATE PJTIMHDR SET th_status = 'P', lupd_prog = 'AUTOPOST', lupd_user = 'IMPORT', lupd_datetime = GETDATE() WHERE DocNbr = @DocNbr
GO
