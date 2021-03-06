USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewDeliverableUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewDeliverableUpdate]
	@ReviewDeliverableKey int,
	@CompanyKey int,
	@ProjectKey int,
	@OwnerUserKey int,
	@DeliverableName varchar(200),
	@Description varchar(2000),
	@DueDate smalldatetime,
	@Approved tinyint,
	@ApprovedDate smalldatetime

AS --Encrypt

  /*
  || When		Who Rel			What
  || 07/26/1	MAS 10.5.x.x	Created
  || 01/20/12   GWG 10.5.5.2	Added Approved
  */

IF ISNULL(@ReviewDeliverableKey,0) <= 0
	BEGIN
		INSERT tReviewDeliverable
			(
				CompanyKey,
				ProjectKey,
				OwnerKey,
				DeliverableName,
				Description,
				DueDate,
				Approved,
				ApprovedDate
			)

		VALUES
			(
				@CompanyKey,
				@ProjectKey,
				@OwnerUserKey,
				@DeliverableName,
				@Description,
				@DueDate,
				@Approved,
				@ApprovedDate
			)
		
		RETURN @@IDENTITY	
	END
ELSE
	BEGIN
		UPDATE
			tReviewDeliverable
		SET
			ProjectKey = @ProjectKey,
			OwnerKey = @OwnerUserKey,
			DeliverableName = @DeliverableName,
			Description = @Description,
			DueDate = @DueDate,
			Approved = @Approved,
			ApprovedDate = @ApprovedDate
		WHERE
			ReviewDeliverableKey = @ReviewDeliverableKey

		RETURN @ReviewDeliverableKey		
	END
GO
