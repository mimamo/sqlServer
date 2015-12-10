USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetTypeColor]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetTypeColor]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 5/7/09    CRG 10.5.0.0 Created to get the TypeColor of an Activity
*/

	SELECT	type.TypeColor
	FROM	tActivityType type (nolock)
	INNER JOIN tActivity a (nolock) ON a.ActivityTypeKey = type.ActivityTypeKey
	WHERE	a.ActivityKey = @ActivityKey
GO
