USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetThreadKeys]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetThreadKeys]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 12/15/10  CRG 10.5.3.9 Created for Diary and To Do to get all ActivityKeys from a thread.
*/

	--Get the Root in case the ActivityKey passed in is not the root
	DECLARE	@RootActivityKey int

	SELECT	@RootActivityKey = RootActivityKey
	FROM	tActivity (nolock)
	WHERE	ActivityKey = @ActivityKey

	SELECT	ActivityKey
	FROM	tActivity (nolock)
	WHERE	RootActivityKey = @RootActivityKey
GO
