USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeGet]
	@CBCodeKey int

AS --Encrypt

		SELECT *
		FROM tCBCode (nolock)
		WHERE
			CBCodeKey = @CBCodeKey

	RETURN 1
GO
