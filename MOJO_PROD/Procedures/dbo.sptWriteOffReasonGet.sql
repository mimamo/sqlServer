USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWriteOffReasonGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWriteOffReasonGet]
	@WriteOffReasonKey int

AS --Encrypt

		SELECT *
		FROM tWriteOffReason (NOLOCK)
		WHERE
			WriteOffReasonKey = @WriteOffReasonKey

	RETURN 1
GO
