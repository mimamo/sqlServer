USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupUpdateMultiple]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupUpdateMultiple]
	(
	@TranType INT		-- -1 All, 1 Labor, 2 Misc Cost, 3 Exp Receipt, 4 Voucher, 5 PO, 6 Billed, 7 Unbilled, 8 WriteOff
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/08/07 GHL 8.4   Creation to solve performance problems in listing and reports
  ||                    Only Handle labor for now
  || 02/15/08 GHL 8.504 Added update times to monitor when the rollup is done     
  */

	SET NOCOUNT ON
	
	-- For tracking update times
	DECLARE @UpdateString VARCHAR(250)
	
	SELECT @UpdateString = 'sptProjectRollupUpdateMultiple' 
			+ ' ,@TranType=' + CAST(@TranType AS VARCHAR(250))
			
	/* Assume done in calling SP
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
		LaborWriteOff money NULL ,
		MiscCostNet money NULL ,
		MiscCostGross money NULL ,
		MiscCostUnbilled money NULL ,
		MiscCostWriteOff money NULL ,
		ExpReceiptNet money NULL ,
		ExpReceiptNetApproved money NULL ,
		ExpReceiptGross money NULL ,
		ExpReceiptGrossApproved money NULL ,
		ExpReceiptUnbilled money NULL ,
		ExpReceiptWriteOff money NULL ,
		VoucherNet money NULL ,
		VoucherNetApproved money NULL ,
		VoucherGross money NULL ,
		VoucherGrossApproved money NULL ,
		VoucherUnbilled money NULL ,
		VoucherWriteOff money NULL ,
		OpenOrderNet money NULL ,
		OpenOrderNetApproved money NULL ,
		OpenOrderGross money NULL ,
		OpenOrderGrossApproved money NULL ,
		OrderPrebilled money NULL ,
		BilledAmount money NULL ,
		AdvanceBilled money NULL ,
		AdvanceBilledOpen money NULL 
	) 
	
	*/
		
	-- If missing in tProjectRollup, add them now
	UPDATE #tProjectRollup
	SET    #tProjectRollup.Action = 0 
	
	UPDATE #tProjectRollup
	SET    #tProjectRollup.Action = 1 -- Update
	FROM   tProjectRollup (NOLOCK)
	WHERE  #tProjectRollup.ProjectKey = tProjectRollup.ProjectKey 
	
	INSERT tProjectRollup (ProjectKey, UpdateStarted, UpdateString)
	SELECT ProjectKey, GETDATE(), @UpdateString
	FROM   #tProjectRollup 
	WHERE  Action = 0 -- INSERT 
	
	UPDATE tProjectRollup
	SET    UpdateStarted = GETDATE(), UpdateString = @UpdateString 
	FROM   #tProjectRollup 
	WHERE  Action = 1 -- UPDATE
	AND    tProjectRollup.ProjectKey = #tProjectRollup.ProjectKey
	
	IF @TranType = 1
	BEGIN
	
		UPDATE #tProjectRollup
		SET	       #tProjectRollup.Hours =  
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
			
			       ,#tProjectRollup.LaborNet =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
						
					,#tProjectRollup.LaborGross =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
					
					,#tProjectRollup.LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND DateBilled IS NULL
					AND WriteOff = 0), 0)
					
					,#tProjectRollup.HoursApproved = 
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
				
					,#tProjectRollup.LaborNetApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
						
					,#tProjectRollup.LaborGrossApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0)

					,#tProjectRollup.LaborWriteOff =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND WriteOff = 1), 0) 
		
			UPDATE tProjectRollup
			SET tProjectRollup.Hours = ISNULL(#tProjectRollup.Hours, 0)
				,tProjectRollup.HoursApproved = ISNULL(#tProjectRollup.HoursApproved, 0)
				,tProjectRollup.LaborNet = ISNULL(#tProjectRollup.LaborNet, 0)
				,tProjectRollup.LaborNetApproved = ISNULL(#tProjectRollup.LaborNetApproved, 0)
				,tProjectRollup.LaborGross = ISNULL(#tProjectRollup.LaborGross, 0)
				,tProjectRollup.LaborGrossApproved = ISNULL(#tProjectRollup.LaborGrossApproved, 0)
				,tProjectRollup.LaborUnbilled = ISNULL(#tProjectRollup.LaborUnbilled, 0)
				,tProjectRollup.LaborWriteOff = ISNULL(#tProjectRollup.LaborWriteOff, 0)	
				
				,tProjectRollup.UpdateEnded = GETDATE()				
			FROM    #tProjectRollup		
			WHERE   tProjectRollup.ProjectKey = #tProjectRollup.ProjectKey
	
		END
				
	RETURN 1
GO
