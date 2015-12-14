USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetUpdateStatus]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetUpdateStatus]
 @Approver int,
 @TimeSheetKey int,
 @Status smallint,
 @ApprovalComments varchar(300) = NULL,
 @DoProjectRollup int = 1
 
AS --Encrypt

/*
|| When      Who Rel	  What
|| 11/07/06  RTC 8.4	  Delete entires with zero hours retained from the timesheet copy function
|| 01/24/07  RTC 8.4.0.2  Do not delete zero hour entries if comments exist
|| 02/15/07  GHL 8.4.0.4  Added project rollup section
|| 10/15/08  RTC 10.0.1.1 Only create a new timesheet if the user is active and they have a user id
|| 11/25/08  CRG 10.0.1.3 (41074) Added DateCreated when creating a new timesheet.
|| 04/08/09  RLB 10.0.2.2 (50496) Changed the date range check when auto creating a timesheet
|| 05/13/10  GHL 10.5.2.2 (80581) Added param DoProjectRollup so that the project rollup can be done offline
|| 10/6/10   CRG 10.5.3.6 Added call to sptTimeSheetProcessUnverified, to check for unverified time entries, and process them based on the company preference
|| 11/14/11  GHL 10.5.5.0 Because of custom trigger for the Integer Group, we need to have ApprovedByKey set at the same
||                        time that we update the status to 4
|| 03/16/12  GHL 10.5.5.4 (137417) Date Approved and Submitted should be UTC
|| 05/13/13  MFT 10.5.6.8 Added check for RequireMinimumHours (sptTimeSheetValidateMinimum) and return code
|| 09/23/13  WDF 10.5.7.2 Pass in Approver rather than pulling from tUser using the Timesheet User key
|| 10/09/13  GWG 10.5.7.2 Fixed how approver is set when submitting
|| 11/21/13  MFT 10.5.7.4 (197217) Added check for RequireMinimumHours (sptTimeSheetValidateMinimum) and return code for Status=4
*/

/*
 *	Init Data
 */
DECLARE @TimeSheetPeriod INT  -- 1 Daily, 2 Weekly, 3 Bi-Weekly, 4 Semi-Monthly, 5 Monthly
		,@StartTimeOn INT
		,@StartDate SMALLDATETIME
		,@EndDate SMALLDATETIME
		,@UserKey INT
		,@CompanyKey INT
		,@Active tinyint
		,@UserID varchar(100)
		,@DefaultApproverKey int

SELECT @StartDate = DATEADD(d, 1, EndDate)
		,@UserKey  = UserKey
		,@CompanyKey = CompanyKey
FROM   tTimeSheet (NOLOCK)
WHERE  TimeSheetKey = @TimeSheetKey

SELECT @TimeSheetPeriod = TimeSheetPeriod
		,@StartTimeOn = StartTimeOn
FROM  tTimeOption (NOLOCK)
WHERE CompanyKey = @CompanyKey

Select @DefaultApproverKey = TimeApprover
	  ,@Active = Active
      ,@UserID = UserID
from tUser (NOLOCK) 
Where UserKey = @UserKey

/*
 *	Change Status
 */
-- only reset ApprovedByKey if we are not approving somehow because of the update trigger for the Integer company
-- in that trigger we need Status = 4 and ApprovedByKey to be part of the same update 
if @Status in (1, 3) -- Unapproved, Rejected
begin
	UPDATE tTimeSheet
	SET  Status = @Status
		,ApprovedByKey = NULL
		,ApprovalComments = case when @ApprovalComments is not null then @ApprovalComments else ApprovalComments end
	WHERE TimeSheetKey = @TimeSheetKey
end

/*
 *	Change Dates
 */	
DECLARE	@VerifyReturn int
 	
if @Status = 4 -- Approved
BEGIN
	--Check for minimum hours
	EXEC @VerifyReturn = sptTimeSheetValidateMinimum @TimeSheetKey
	
	IF @VerifyReturn < 0
		RETURN @VerifyReturn
	
	--Check for unverified entries
	EXEC @VerifyReturn = sptTimeSheetProcessUnverified @TimeSheetKey

	IF @VerifyReturn < 0
		RETURN @VerifyReturn

	if @Approver = @UserKey
		UPDATE tTimeSheet
		SET Status = 4
			,DateSubmitted = GETUTCDATE()
			,DateApproved = GETUTCDATE()
			,ApprovedByKey = @Approver
			,ApprovalComments = case when @ApprovalComments is not null then @ApprovalComments else ApprovalComments end
		WHERE TimeSheetKey = @TimeSheetKey
	else	
		UPDATE tTimeSheet
		SET Status = 4
		    ,DateApproved = GETUTCDATE()
		    ,ApprovedByKey = @Approver
			,ApprovalComments = case when @ApprovalComments is not null then @ApprovalComments else ApprovalComments end
		WHERE TimeSheetKey = @TimeSheetKey	
		
	--delete entires with zero hours retained from the timesheet copy function
	delete tTime
	where TimeSheetKey = @TimeSheetKey
	and ActualHours = 0	
	and Comments is null	
END

IF @Status = 2 -- Sent For Approval
BEGIN
	--Check for minimum hours
	EXEC @VerifyReturn = sptTimeSheetValidateMinimum @TimeSheetKey
	
	IF @VerifyReturn < 0
		RETURN @VerifyReturn
	
	--Check for unverified entries
	EXEC @VerifyReturn = sptTimeSheetProcessUnverified @TimeSheetKey

	IF @VerifyReturn < 0
		RETURN @VerifyReturn

	if @DefaultApproverKey = @UserKey
		UPDATE tTimeSheet
		SET Status = 4
			,DateSubmitted = GETUTCDATE()
			,DateApproved = GETUTCDATE()
			,ApprovedByKey = @Approver
			,ApprovalComments = case when @ApprovalComments is not null then @ApprovalComments else ApprovalComments end
		WHERE TimeSheetKey = @TimeSheetKey
	else	
		UPDATE tTimeSheet
		SET  Status = 2
		    ,DateSubmitted = GETUTCDATE()
		    ,ApprovedByKey = NULL
			,ApprovalComments = case when @ApprovalComments is not null then @ApprovalComments else ApprovalComments end
		WHERE TimeSheetKey = @TimeSheetKey
			
	--delete entires with zero hours leftover from the timesheet copy function
	delete tTime
	where TimeSheetKey = @TimeSheetKey
	and ActualHours = 0
	and Comments is null	
END

/*
 *	When the time sheet is sent for approval or approved, create a new one
 */				
IF @Status IN (2, 4)
BEGIN			
	IF @TimeSheetPeriod = 1 -- Daily
	BEGIN
		While DATEPART(WEEKDAY, @StartDate) = 1 OR DATEPART(WEEKDAY, @StartDate) = 7
		BEGIN
			Select @StartDate = DATEADD(d, 1, @StartDate)	
		END
		SELECT @EndDate = @StartDate 
	END
	
	IF @TimeSheetPeriod = 2	-- Weekly
		SELECT @EndDate = DATEADD(d, 6, @StartDate)
		
	IF @TimeSheetPeriod = 3 -- BiWeekly
		SELECT @EndDate = DATEADD(d, 13, @StartDate)
		
	IF @TimeSheetPeriod = 4	-- Semi-Monthly
	BEGIN
		IF DATEPART(d, @StartDate) = 1
			SELECT @EndDate = DATEADD(d, 14, @StartDate)
		ELSE
		BEGIN
			-- Start on 16 th
			-- End may vary, 28, 29, 30, 31
			-- Go back 15 days
			SELECT @EndDate = DATEADD(d, -15, @StartDate)
			-- Add a month
			SELECT @EndDate = DATEADD(m, 1, @EndDate)
			-- Subtract 1 day
			SELECT @EndDate = DATEADD(d, -1, @EndDate)
		END 
	END
		
	IF @TimeSheetPeriod = 5 -- Monthly
	BEGIN
		SELECT @EndDate = DATEADD(m, 1, @StartDate)
		SELECT @EndDate = DATEADD(d, -1, @EndDate)	 
	END
		
	if isnull(@Active, 0) = 1 and @UserID is not null
		begin
			IF NOT EXISTS (SELECT 1
							FROM  tTimeSheet (NOLOCK)
							WHERE UserKey = @UserKey
							AND   CompanyKey = @CompanyKey
						    AND   StartDate <= @EndDate
							AND   EndDate >= @StartDate)
			BEGIN				
				INSERT tTimeSheet (CompanyKey, UserKey, StartDate, EndDate, Status, DateCreated)
				SELECT @CompanyKey, @UserKey, @StartDate, @EndDate, 1, GETUTCDATE()
			END
		end
		

END 
 
 DECLARE @ProjectKey INT
 
 IF @DoProjectRollup = 1
 BEGIN 
	 SELECT @ProjectKey = -1
	 WHILE (1=1)
	 BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   tTime (NOLOCK)
		WHERE  TimeSheetKey = @TimeSheetKey
		AND    ProjectKey > @ProjectKey
		
		IF @ProjectKey IS NULL
			BREAK
			
		-- Rollup project, TranType = Labor or 1, Approved rollup only	
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 0, 1, 0, 0
	 END
 END
  
RETURN 1
GO
