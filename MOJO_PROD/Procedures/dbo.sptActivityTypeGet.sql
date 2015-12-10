USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptActivityTypeGet]
	@ActivityTypeKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  QMD 10.5.0.0 Initial Release
*/

		SELECT	*
		FROM	tActivityType (nolock)
		WHERE	ActivityTypeKey = @ActivityTypeKey

	RETURN 1
GO
