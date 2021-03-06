USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertMultiple]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeInsertMultiple]
 @TimeSheetKey int
 
AS --Encrypt

/*
|| When     Who Rel     What
|| 10/04/06 CRG 8.35    Added GUID to #tOldTime
|| 02/15/07 GHL 8.4     Added project rollup section
|| 03/08/07 GHL 8.4     Modified second insert into #tProjectRollup to avoid duplicate projects
|| 03/08/07 GHL 8.4     Using now sptProjectRollupUpdateMultiple instead of sptProjectRollupUpdate
|| 04/03/07 RTC 8.5     Changed order of insert/delete to delete/insert to try to eliminate the nolock due to data movement errors
|| 06/20/07 CRG 8.4.3.1 Added DetailTaskKey
|| 10/7/10  CRG 10.5.3.6 Now setting Verified to 1.
|| 02/04/13 GHL 10.5.6.4 (167256) Do not copy entries with wrong project on task      
|| 03/12/13 GHL 10.565 (171480) Cannot have RateLevel = 0                                            
|| 11/04/13 GHL 10.574 Added Currency info   
|| 03/10/15 GHL 10.590 Added DepartmentKey for Abelson Taylor                                                                 
*/	
	-- Assume done before calling this sp
	/*
	CREATE TABLE #tTime (RowNumber INT NULL
						,ProjectNumber VARCHAR(50)
						,ErrorNumber INT NULL 
						,TimeKey uniqueidentifier NULL
						,TimeSheetKey INT NULL
						,UserKey INT NULL
						,ProjectKey INT NULL
						,TaskKey INT NULL
						,ServiceKey INT NULL
						,RateLevel int NULL
						,WorkDate smalldatetime NULL
						,StartTime smalldatetime NULL
						,EndTime smalldatetime NULL
						,ActualHours decimal(24,4) NULL
						,PauseHours decimal(24,4) NULL
						,Comments varchar(300) NULL
						,CostRate decimal(24,4) NULL
						,DepartmentKey int null
						) 	
	*/
		
	DECLARE	@UpdateKey uniqueidentifier

	SELECT	@UpdateKey = NEWID()

	CREATE TABLE #tOldTime(TimeKey uniqueidentifier NULL, ProjectKey int NULL, UpdateKey uniqueidentifier NULL)
	INSERT #tOldTime(TimeKey, ProjectKey, UpdateKey)
	SELECT TimeKey, ProjectKey, @UpdateKey FROM tTime (NOLOCK) WHERE TimeSheetKey = @TimeSheetKey 
	
	-- Capture old and new project keys
	CREATE TABLE #tProjectRollup (
	    Action int NULL,			-- 1 Update, 0 Insert
		ProjectKey int NOT NULL ,
		Hours decimal(24, 4) NULL ,
		HoursApproved decimal(24, 4) NULL ,
		LaborNet money NULL ,
		LaborNetApproved money NULL ,
		LaborGross money NULL ,
		LaborGrossApproved money NULL ,
		LaborUnbilled money NULL ,
		LaborWriteOff money NULL )
		
	INSERT #tProjectRollup (ProjectKey)
	SELECT DISTINCT ProjectKey
	FROM   #tTime (NOLOCK)
	WHERE  TimeSheetKey = @TimeSheetKey
	AND    ProjectKey IS NOT NULL
	
	INSERT #tProjectRollup (ProjectKey)
	SELECT DISTINCT ProjectKey
	FROM   #tOldTime (NOLOCK)
	WHERE  UpdateKey = @UpdateKey
	AND    ProjectKey IS NOT NULL
	AND    ProjectKey NOT IN (SELECT ProjectKey FROM #tProjectRollup)
	
	BEGIN TRAN

	DELETE	tTime 
	FROM	#tOldTime b
	WHERE	tTime.TimeKey = b.TimeKey
	AND		b.UpdateKey = @UpdateKey

	 		 
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN

		DELETE #tTime
		WHERE  TimeSheetKey = @TimeSheetKey
		
		IF (SELECT COUNT(*) FROM #tTime) = 0 
			DROP TABLE #tTime

		RETURN -1
	END
			
	DELETE #tTime
	FROM   tTask ta (nolock)
	WHERE  #tTime.TaskKey = ta.TaskKey
	AND    #tTime.ProjectKey <> ta.ProjectKey

	UPDATE #tTime 
	SET    RateLevel = 1
	WHERE  ISNULL(RateLevel, 0) = 0
				 		    
	INSERT tTime
			(TimeKey,
			TimeSheetKey,
			UserKey,
			ProjectKey,
			TaskKey,
			ServiceKey,
			RateLevel,
			WorkDate,
			StartTime,
			EndTime,
			ActualHours,
			PauseHours,
			ActualRate,
			Comments,
			CostRate,
			DetailTaskKey,
			Verified,
			CurrencyID,
			ExchangeRate,
			HCostRate,
			DepartmentKey
			)
			
	SELECT	TimeKey,
			TimeSheetKey,
			UserKey,
			ProjectKey,
			TaskKey,
			ServiceKey,
			RateLevel,
			WorkDate,
			StartTime,
			EndTime,
			ActualHours,
			PauseHours,
			ActualRate,
			Comments,
			CostRate,
			DetailTaskKey,
			1,
			CurrencyID,
			ExchangeRate,
			HCostRate,
			DepartmentKey
	FROM   #tTime
	WHERE  TimeSheetKey = @TimeSheetKey			

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN

		DELETE #tTime
		WHERE  TimeSheetKey = @TimeSheetKey
		
		IF (SELECT COUNT(*) FROM #tTime) = 0 
			DROP TABLE #tTime

		RETURN -1
	END

	COMMIT TRAN
				
	DELETE #tTime
	WHERE  TimeSheetKey = @TimeSheetKey
	
	IF (SELECT COUNT(*) FROM #tTime) = 0 
		DROP TABLE #tTime
	
 -- Rollup project, TranType = Labor or 1
 EXEC sptProjectRollupUpdateMultiple 1
 
 RETURN 1
GO
