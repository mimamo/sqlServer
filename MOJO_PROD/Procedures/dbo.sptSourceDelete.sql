USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceDelete]
	@SourceKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  QMD 10.5.0.0 Initial Release
*/

if exists(select 1 from tUserLead (nolock) Where CompanySourceKey = @SourceKey)
	return -1
if exists(select 1 from tCompany (nolock) Where SourceKey = @SourceKey)
	return -1 

	DELETE
	FROM tSource
	WHERE
		SourceKey = @SourceKey

	RETURN 1
GO
