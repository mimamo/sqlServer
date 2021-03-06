USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckApplOverApplyCheck]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckApplOverApplyCheck]
	@CheckKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/02/10  MFT 10.519  Created
*/

DECLARE @AppliedAmount money
DECLARE @CheckAmount money

SELECT @AppliedAmount = SUM(Amount) FROM tCheckAppl (nolock) WHERE CheckKey = @CheckKey
SELECT @CheckAmount = CheckAmount FROM tCheck (nolock) WHERE CheckKey = @CheckKey

IF ISNULL(@CheckAmount, 0) > 0
	BEGIN
		IF ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0)
			RETURN -1
	END
ELSE
	BEGIN
		IF ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0)
			RETURN -1
	END

RETURN 1
GO
