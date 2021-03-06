USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateChangeStatus]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateChangeStatus]
	(
		@EstimateKey int,
		@Status smallint,
		@Comments text,
		@ApprovedQty  smallint,  -- May be changed on external approval screen, 0 (i.e. no change) on other screens
		@Internal tinyint,
		@SetInternalDueDateOnApproval int = 0
	)
AS --Encrypt

/*
|| When     Who Rel       What
|| 04/20/10 GHL 10.5.2.2  Added call to sptEstimateRollupOpportunity
||                        because of links between estimates and opps
|| 08/19/10 GHL 10.5.3.4  When unapproving a project estimate, check if it is on an approved campaign estimate 
|| 09/01/10 GHL 10.5.3.4  Added @SetInternalDueDateOnApproval so that we can set the internal due date even if we approve the estimate
||                        versus doing it when sending for approval only
||                        Also when unapproving a project estimate, check where ep.ProjectEstimateKey = @EstimateKey not ep.ProjectKey = @ProjectKey
|| 10/06/10 GHL 10.5.3.6  (91509) Updating now ApprovedQty before recalculating the stats
|| 05/15/13 MFT 10.5.6.8  Added OnlyOneApprovedEstimate, test and RETURN code (-3)
*/
	SET NOCOUNT ON

	DECLARE @InternalApprover int
			,@ExternalApprover int
			,@CampaignKey int
			,@ProjectKey int
			,@OldApprovedQty smallint
			,@EstType int
			,@InternalDueDate smalldatetime
			,@ExternalDueDate smalldatetime
			,@EstimateInternalApprovalDays int
			,@EstimateExternalApprovalDays int
			,@InternalStatus int
			,@ExternalStatus int
			,@CompanyKey int
			,@OnlyOneApprovedEstimate tinyint

	SELECT @CompanyKey = e.CompanyKey
			,@CampaignKey = e.CampaignKey
			,@ProjectKey = e.ProjectKey
			,@OldApprovedQty = e.ApprovedQty
			,@InternalApprover = isnull(e.InternalApprover, 0)
			,@InternalDueDate = e.InternalDueDate
			,@ExternalApprover = isnull(e.ExternalApprover, 0)
			,@ExternalDueDate = e.ExternalDueDate
			,@EstType = e.EstType
			,@EstimateInternalApprovalDays = isnull(pref.EstimateInternalApprovalDays, 0)
			,@EstimateExternalApprovalDays = isnull(pref.EstimateExternalApprovalDays, 0)
			,@InternalStatus = isnull(e.InternalStatus, 0)
			,@ExternalStatus = isnull(e.ExternalStatus, 0)
			,@OnlyOneApprovedEstimate = ISNULL(pref.OnlyOneApprovedEstimate, 0)
	FROM   tEstimate e (nolock)
		LEFT JOIN tProject p (nolock) on e.ProjectKey = p.ProjectKey
		INNER JOIN tPreference pref (nolock) on e.CompanyKey = pref.CompanyKey
	WHERE  e.EstimateKey = @EstimateKey
				
	-- Must have an Internal Approver before submittal for approver or approval			
	If @InternalApprover = 0 And (@Status = 2 Or @Status = 4) And @Internal = 1
		RETURN -1			
	
	-- if unapproving a project estimate, make sure it is not on an approved campaign estimate
	If isnull(@ProjectKey, 0) > 0 And @Status = 1
	begin
		if exists (select 1 
					from tEstimate e (nolock)
					inner join tEstimateProject ep (nolock) on  e.EstimateKey = ep.EstimateKey -- this is the campaign estimate
					where e.CompanyKey = @CompanyKey
					and   e.InternalStatus = 4
					and   ep.ProjectEstimateKey = @EstimateKey -- this is the project estimate
					)
			RETURN -2   	
	end
	
	--if OnlyOneApprovedEstimate, make sure no others are approved for this project
	IF @OnlyOneApprovedEstimate > 0 AND @Internal = 1 AND @Status = 4
		BEGIN
			--Only need to check internal b/c it must be 4 before sent to external
			IF EXISTS (
				SELECT *
				FROM tEstimate (nolock)
				WHERE
					EstimateKey != @EstimateKey AND
					ProjectKey = @ProjectKey AND
					InternalStatus = 4)
				RETURN -3
		END
	IF @ApprovedQty > 0 And @ApprovedQty <> @OldApprovedQty
	BEGIN
		If @EstType = 1
			-- Rollup ammounts to tEstimateTask
			exec sptEstimateTaskExpenseRollupDetail @EstimateKey

		Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
		Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
		
		Update tEstimate 
		set ApprovedQty = @ApprovedQty -- important to set approved qty before recalculating the stats
		  , SalesTaxAmount = @SalesTax1Amount
		  , SalesTax2Amount = @SalesTax2Amount 
		where EstimateKey = @EstimateKey
		
		Exec sptEstimateTaskRollupDetail @EstimateKey

	END
	
	IF @Internal = 1
	BEGIN
		-- Internal Approval
		
		IF @ApprovedQty > 0 
			UPDATE tEstimate
			SET    InternalStatus = @Status
		          ,InternalApproval = GETDATE()
				  ,InternalComments = @Comments
				  ,ApprovedQty = @ApprovedQty
			WHERE  EstimateKey = @EstimateKey

		ELSE
				
			UPDATE tEstimate
			SET    InternalStatus = @Status
				  ,InternalApproval = GETDATE()
				  ,InternalComments = @Comments
			WHERE  EstimateKey = @EstimateKey
		
		-- If Internally rejected, reset the external status
		-- Unapprove case
		IF @ExternalApprover > 0 AND @Status in (1, 3)
			UPDATE tEstimate
			SET    ExternalStatus = 1
				  ,ExternalDueDate = null			  
			WHERE  EstimateKey = @EstimateKey
		
		-- Set internal due date if necessary, when send for approval
		IF @Status = 2
		BEGIN
			IF @InternalDueDate IS NULL AND @EstimateInternalApprovalDays > 0
			BEGIN
				SELECT @InternalDueDate = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10), GETDATE(), 101), 101)
				SELECT @InternalDueDate = DATEADD(d, @EstimateInternalApprovalDays, @InternalDueDate) 
				UPDATE tEstimate SET InternalDueDate = @InternalDueDate 
				WHERE  EstimateKey = @EstimateKey
			END
		END
		
		-- At Kathryn's request when testing flex screen, set it even if we approve (instead of sending for approval)
		if @SetInternalDueDateOnApproval = 1 and @Status = 4
		BEGIN
			IF @InternalDueDate IS NULL AND @EstimateInternalApprovalDays > 0
			BEGIN
				SELECT @InternalDueDate = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10), GETDATE(), 101), 101)
				SELECT @InternalDueDate = DATEADD(d, @EstimateInternalApprovalDays, @InternalDueDate) 
				UPDATE tEstimate SET InternalDueDate = @InternalDueDate 
				WHERE  EstimateKey = @EstimateKey
			END
		END

		-- If rejected or send to 1, reset internal due date and Internal Approver date
		IF @Status IN (1, 3)
		BEGIN
			UPDATE tEstimate SET InternalDueDate = NULL,  InternalApproval = null
			WHERE  EstimateKey = @EstimateKey
		END
		
		-- If Internally approved, send for submittal to external approver
		IF @ExternalApprover > 0 AND @Status = 4
		BEGIN
			IF @ExternalDueDate IS NULL AND @EstimateExternalApprovalDays > 0 
			BEGIN
				SELECT @ExternalDueDate = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(10), GETDATE(), 101), 101)
				SELECT @ExternalDueDate = DATEADD(d, @EstimateExternalApprovalDays, @ExternalDueDate) 
			END
			ELSE
				SELECT @ExternalDueDate = NULL
								
			UPDATE tEstimate
			SET    ExternalStatus = 2
				  ,ExternalComments = ''				  
				  ,ExternalDueDate = @ExternalDueDate
			WHERE  EstimateKey = @EstimateKey
		END
		
		-- if it has anything with approval, update the opp
		IF @InternalStatus = 4 OR @Status = 4
		BEGIN
			EXEC sptEstimateRollupOpportunity @EstimateKey
			EXEC sptEstimateRollupCampaign @CampaignKey		
		END	
	END
	ELSE
	BEGIN
		-- External Approval

		IF @ApprovedQty > 0 
			UPDATE tEstimate
			SET    ExternalStatus = @Status
		          ,ExternalApproval = GETDATE()
				  ,ExternalComments = @Comments
				  ,ApprovedQty = @ApprovedQty
			WHERE  EstimateKey = @EstimateKey

		ELSE
				
			UPDATE tEstimate
			SET    ExternalStatus = @Status
				  ,ExternalApproval = GETDATE()
				  ,ExternalComments = @Comments
			WHERE  EstimateKey = @EstimateKey

		-- If externally rejected, set status to rejected so it does not appear back in the internal approvers list
		-- Hopefully external comments will be left by client
		-- Reset all DueDates
		IF @Status = 3
			UPDATE tEstimate
			SET    InternalStatus = 3
			      ,InternalDueDate = NULL 
			      ,ExternalDueDate = NULL
			WHERE  EstimateKey = @EstimateKey
			

		-- if it has anything with approval, update the opp
		IF @ExternalStatus = 4 OR @Status = 4
		BEGIN
			EXEC sptEstimateRollupOpportunity @EstimateKey
			EXEC sptEstimateRollupCampaign @CampaignKey		
		END	
					
	END	
		
	-- Rollup ammounts to task, project, etc...
	exec sptEstimateRollupDetail @ProjectKey

		
	RETURN 1
GO
