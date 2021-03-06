USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestRejectReasonUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestRejectReasonUpdate]
	@RequestRejectReasonKey int,
	@CompanyKey int,
	@ReasonName varchar(200),
	@Description varchar(4000),
	@Active tinyint

AS --Encrypt

/*
|| When      Who Rel      What
|| 04/23/15  GHL 10.5.9.1 Creation for Kohls enhancement
*/

IF @RequestRejectReasonKey <= 0
	BEGIN
		INSERT tRequestRejectReason
			(
			CompanyKey,
			ReasonName,
			Description,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ReasonName,
			@Description,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
BEGIN	
	UPDATE
		tRequestRejectReason
	SET
		CompanyKey = @CompanyKey,
		ReasonName = @ReasonName,
		Description = @Description,
		Active = @Active
	WHERE
		RequestRejectReasonKey = @RequestRejectReasonKey 

	RETURN @RequestRejectReasonKey
END
GO
