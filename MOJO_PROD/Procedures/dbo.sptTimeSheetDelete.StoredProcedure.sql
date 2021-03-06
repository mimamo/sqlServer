USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetDelete]
 @TimeSheetKey int,
 @UserKey int = 0

AS --Encrypt

  /*
  || When     Who Rel      What
  || 02/15/07 GHL 8.4      Added project rollup section
  || 02/12/09 MFT 10.0.1.9 Reversed the DELETE action order (FK was droped) to allow trigger to catch history
  || 03/24/11 RLB 10.5.4.2 (106787) Removed check for status of 2 or 4 all checks are done before the delete is run
  || 02/12/12 RLB 10.5.5.2 (134349) Added a few checks when deleting a timesheet
  || 02/18/12 RLB 10.5.6.5 Added for logging
  */
  


  if exists(Select 1 from tTime (NOLOCK) Where TimeSheetKey = @TimeSheetKey and (WIPPostingInKey > 0 or WIPPostingOutKey > 0))
			return -3
	
  if exists(Select 1 from tBillingDetail bd (nolock)
					inner join tTime t (nolock) on bd.EntityGuid = t.TimeKey
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey  
				Where t.TimeSheetKey = @TimeSheetKey
				And   bd.Entity = 'tTime'
				And   b.Status < 5)
			return -4
	
  if exists(Select 1 from tTime (NOLOCK) Where TimeSheetKey = @TimeSheetKey and InvoiceLineKey > 0)  -- was (InvoiceLineKey is null or WriteOff = 1)
			return -5

-- adding for logging
 IF @UserKey > 0
 BEGIN
	DECLARE @Date smalldatetime, @Comment varchar(1000), @StartDate smalldatetime, @EndDate smalldatetime, @FullName varchar(100), @TimeSheetUserKey int

	SELECT @Date = GETUTCDATE()	

	SELECT @TimeSheetUserKey = UserKey, @StartDate = StartDate, @EndDate = EndDate from tTimeSheet (nolock) where TimeSheetKey = @TimeSheetKey

	SELECT @FullName = UserFullName from vUserName (nolock) where UserKey = @TimeSheetUserKey

	IF DATEDIFF(day,@StartDate,@EndDate) > 0
		SELECT @Comment = ' Time sheet starting ' + CONVERT(varchar, @StartDate, 101) + ' to ' + CONVERT(varchar, @EndDate, 101) + ' was deleted'
	ELSE
	 SELECT @Comment = 'Daily time sheet ' + CONVERT(varchar, @StartDate, 101) + ' was deleted'

	 EXEC sptActionLogInsert 'Time Sheet',@TimeSheetKey, 0, 0, 'Deleted', @Date, NULL, @Comment, @FullName, NULL, @UserKey  

 END


 CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
 
 INSERT #ProjectRollup (ProjectKey)
 SELECT DISTINCT ProjectKey
 FROM   tTime (NOLOCK)
 WHERE  TimeSheetKey = @TimeSheetKey
 AND    ProjectKey IS NOT NULL
 
 BEGIN TRAN
  
 DELETE tTimeSheet
 WHERE TimeSheetKey = @TimeSheetKey
 
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN -1
 END
 
 DELETE  tTime
 WHERE   TimeSheetKey = @TimeSheetKey
 
 IF @@ERROR <> 0
 BEGIN
  ROLLBACK TRAN
  RETURN -1
 END

 COMMIT TRAN

 -- The Project Rollup operation does not have to be in the transaction
 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   #ProjectRollup
	WHERE  ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = Labor or 1, Base + approved rollup	
	EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1
 END
  
 	   
 RETURN 1
GO
