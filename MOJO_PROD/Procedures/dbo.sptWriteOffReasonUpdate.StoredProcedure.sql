USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWriteOffReasonUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWriteOffReasonUpdate]
	@WriteOffReasonKey int,
	@CompanyKey int,
	@ReasonName varchar(200),
	@Description varchar(4000),
	@Active tinyint

AS --Encrypt

/*
|| When      Who Rel      What
|| 09/14/09  MAS 10.5.0.9 Added Insert Logic
*/

IF @WriteOffReasonKey <= 0
	BEGIN
		INSERT tWriteOffReason
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
		tWriteOffReason
	SET
		CompanyKey = @CompanyKey,
		ReasonName = @ReasonName,
		Description = @Description,
		Active = @Active
	WHERE
		WriteOffReasonKey = @WriteOffReasonKey 

	RETURN @WriteOffReasonKey
END
GO
