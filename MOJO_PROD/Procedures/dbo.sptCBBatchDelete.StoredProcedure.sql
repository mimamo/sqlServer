USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBBatchDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBBatchDelete]
	@CBBatchKey int

AS --Encrypt

	DECLARE @CompanyKey INT
			,@Type INT
	
	SELECT @CompanyKey = CompanyKey
		   ,@Type = Type
	FROM   tCBBatch (NOLOCK)
	WHERE  CBBatchKey = @CBBatchKey
	
	BEGIN TRANSACTION
	
	DELETE tCBPosting WHERE CBBatchKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

	-- Billing Batch	
	IF @Type = 1
	BEGIN
		UPDATE tMiscCost 
		SET    tMiscCost.WIPPostingInKey = 0 
		FROM   tProject p (NOLOCK)	
		WHERE  tMiscCost.ProjectKey = p.ProjectKey
		AND    p.CompanyKey = @CompanyKey
		AND	   tMiscCost.WIPPostingInKey = @CBBatchKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
		
		UPDATE tTime 
		SET    tTime.WIPPostingInKey = 0 
		FROM   tProject p (NOLOCK)	
		WHERE  tTime.ProjectKey = p.ProjectKey
		AND    p.CompanyKey = @CompanyKey
		AND	   tTime.WIPPostingInKey = @CBBatchKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
	END
	
	-- Adjustment Batch
	IF @Type = 2
	BEGIN
		UPDATE tCBBatch
		SET    Adjusted = 0
		WHERE  CBBatchKey IN (SELECT BatchKey FROM tCBBatchAdjustment (NOLOCK) WHERE AdjustmentBatchKey = @CBBatchKey)
		AND    CBBatchKey NOT IN (SELECT BatchKey FROM tCBBatchAdjustment (NOLOCK) WHERE AdjustmentBatchKey <> @CBBatchKey)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

		DELETE tCBBatchAdjustment WHERE AdjustmentBatchKey = @CBBatchKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
	END
	
	DELETE
	FROM tCBBatch
	WHERE
		CBBatchKey = @CBBatchKey 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

	COMMIT TRANSACTION
		
	RETURN 1
GO
