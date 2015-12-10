USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAttributeGetAll]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAttributeGetAll]
	@CompanyKey int,
	@POKind smallint

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/
		SELECT *
		FROM tMediaAttribute (nolock)
		WHERE CompanyKey = @CompanyKey and POKind = @POKind
		ORDER BY AttributeName

		SELECT *
		FROM tMediaAttributeValue (nolock)
		WHERE MediaAttributeKey in (SELECT MediaAttributeKey
		                              FROM tMediaAttribute (nolock)
		                             WHERE CompanyKey = @CompanyKey and POKind = @POKind)
		ORDER BY MediaAttributeKey, ValueName

	RETURN 1
GO
