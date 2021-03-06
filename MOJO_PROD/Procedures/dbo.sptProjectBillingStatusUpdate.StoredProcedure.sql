USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusUpdate]
	@ProjectBillingStatusKey int,
	@CompanyKey int,
	@ProjectBillingStatusID varchar(30),
	@ProjectBillingStatus varchar(200),
	@DisplayOrder int,
	@Active tinyint

AS --Encrypt

/*
|| When     Who Rel			What
|| 5/1/07	CRG 8.5			(8991) Added @Active parameter.
|| 09/01/09	MAS 10.5.0.8    Added insert logic

*/

IF EXISTS(SELECT 1 From tProjectBillingStatus (NOLOCK) WHERE ProjectBillingStatusID = @ProjectBillingStatusID AND ProjectBillingStatusKey <> @ProjectBillingStatusKey AND CompanyKey = @CompanyKey)
	RETURN -1
	
IF @ProjectBillingStatusKey <= 0
	BEGIN	
		INSERT tProjectBillingStatus
			(
			CompanyKey,
			ProjectBillingStatusID,
			ProjectBillingStatus,
			DisplayOrder,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ProjectBillingStatusID,
			@ProjectBillingStatus,
			@DisplayOrder,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN	
		UPDATE
			tProjectBillingStatus
		SET
			CompanyKey = @CompanyKey,
			ProjectBillingStatusID = @ProjectBillingStatusID,
			ProjectBillingStatus = @ProjectBillingStatus,
			DisplayOrder = @DisplayOrder,
			Active = @Active
		WHERE
			ProjectBillingStatusKey = @ProjectBillingStatusKey 

		RETURN @ProjectBillingStatusKey
	END
GO
