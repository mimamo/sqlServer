USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyMapUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyMapUpdate]
	@GLCompanyMapKey int,
	@SourceGLCompanyKey int,
	@TargetGLCompanyKey int,
	@APDueToAccountKey int,
	@APDueFromAccountKey int,
	@ARDueToAccountKey int,
	@ARDueFromAccountKey int,
	@JEDueToAccountKey int,
	@JEDueFromAccountKey int,
	@OverrideDuplicateCheck tinyint = 0
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/26/12  MFT 10.554  Created
|| 03/28/12  MFT 10.554  Added Journal Entry fields
|| 03/29/12  MFT 10.554  Added @OverrideDuplicateCheck
|| 03/30/12  MFT 10.554  Added Cash Sweep fields
|| 03/19/15  WDF 10.590  Remove Cash Sweep fields
*/

--The duplicate check should be overridden when validated
--in the user interface to allow for updates that may
--create a duplicate with one transaction and then fix
--with a later call to this procedure
IF @OverrideDuplicateCheck = 0 AND EXISTS
	(
		SELECT *
		FROM tGLCompanyMap (nolock)
		WHERE 
			SourceGLCompanyKey = @SourceGLCompanyKey AND
			TargetGLCompanyKey = @TargetGLCompanyKey AND
			GLCompanyMapKey != ISNULL(@GLCompanyMapKey, 0)
	)
	RETURN -1

IF @SourceGLCompanyKey = @TargetGLCompanyKey
	RETURN -2

IF ISNULL(@GLCompanyMapKey, 0) > 0
	BEGIN 
		UPDATE tGLCompanyMap
		SET
			SourceGLCompanyKey = @SourceGLCompanyKey,
			TargetGLCompanyKey = @TargetGLCompanyKey,
			APDueToAccountKey = @APDueToAccountKey,
			APDueFromAccountKey = @APDueFromAccountKey,
			ARDueToAccountKey = @ARDueToAccountKey,
			ARDueFromAccountKey = @ARDueFromAccountKey,
			JEDueToAccountKey = @JEDueToAccountKey,
			JEDueFromAccountKey = @JEDueFromAccountKey
		WHERE GLCompanyMapKey = @GLCompanyMapKey
	END
ELSE
	BEGIN
		INSERT INTO tGLCompanyMap
			(
				SourceGLCompanyKey,
				TargetGLCompanyKey,
				APDueToAccountKey,
				APDueFromAccountKey,
				ARDueToAccountKey,
				ARDueFromAccountKey,
				JEDueToAccountKey,
				JEDueFromAccountKey
			)
		VALUES
			(
				@SourceGLCompanyKey,
				@TargetGLCompanyKey,
				@APDueToAccountKey,
				@APDueFromAccountKey,
				@ARDueToAccountKey,
				@ARDueFromAccountKey,
				@JEDueToAccountKey,
				@JEDueFromAccountKey
			)
		
		SELECT @GLCompanyMapKey = SCOPE_IDENTITY()
	END

RETURN @GLCompanyMapKey
GO
