USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeDelete]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptActivityTypeDelete]
	@ActivityTypeKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  RTC 10.5.0.0 Initial Release
*/

if exists(select 1 from tActivity (nolock) Where ActivityTypeKey = @ActivityTypeKey)
	return -1

	DELETE
	FROM tActivityType
	WHERE
		ActivityTypeKey = @ActivityTypeKey

	RETURN 1
GO
