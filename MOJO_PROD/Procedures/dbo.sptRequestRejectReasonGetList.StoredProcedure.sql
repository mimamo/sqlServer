USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestRejectReasonGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestRejectReasonGetList]

	@CompanyKey int
	,@Active smallint
	,@RequestRejectReasonKey int = NULL

AS --Encrypt

		SELECT *
		FROM tRequestRejectReason (NOLOCK)
		WHERE
		CompanyKey = @CompanyKey
		AND		((@Active IS NULL OR Active = @Active) OR (RequestRejectReasonKey = @RequestRejectReasonKey))
		Order By Active DESC, ReasonName

	RETURN 1
GO
