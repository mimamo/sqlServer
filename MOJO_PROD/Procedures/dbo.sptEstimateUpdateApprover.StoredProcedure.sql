USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUpdateApprover]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUpdateApprover]
	(
		@EstimateKey INT,
		@Approver INT,
		@Internal TINYINT
	)
AS
	SET NOCOUNT ON
	
	DECLARE @InternalStatus SMALLINT
			,@ExternalStatus SMALLINT
	
	SELECT @InternalStatus = InternalStatus
		  ,@ExternalStatus = ExternalStatus
	FROM   tEstimate (NOLOCK)
	WHERE  EstimateKey = @EstimateKey
	
	IF @Internal = 1
	BEGIN

		IF @InternalStatus <> 4
			UPDATE tEstimate
			SET    InternalApprover = @Approver
			WHERE  EstimateKey = @EstimateKey
		ELSE
			RETURN -1
	
	END
	
	ELSE
	
	BEGIN
	
		IF @ExternalStatus <> 4
			UPDATE tEstimate
			SET    ExternalApprover = @Approver
			WHERE  EstimateKey = @EstimateKey
		ELSE
			RETURN -1
	
	END	
	
	
	
	RETURN 1
GO
