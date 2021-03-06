USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetToDoComments]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetToDoComments]
	@ActivityKey int,
	@ChildOnly tinyint = 0 --If 1, it will return only the activity specified by the ActivityKey, rather than all of the children
AS

/*
|| When      Who Rel      What
|| 12/14/10  CRG 10.5.3.9 Created
*/

	IF @ChildOnly = 1
		SELECT	a.ActivityKey,
				u.UserName,
				a.DateAdded,
				a.Notes,
				a.AddedByKey
		FROM	tActivity a (nolock)
		INNER JOIN vUserName u ON a.AddedByKey = u.UserKey
		WHERE	ActivityKey = @ActivityKey
	ELSE
		SELECT	a.ActivityKey,
				u.UserName,
				a.DateAdded,
				a.Notes,
				a.AddedByKey
		FROM	tActivity a (nolock)
		INNER JOIN vUserName u ON a.AddedByKey = u.UserKey
		WHERE	RootActivityKey = @ActivityKey
		AND		ParentActivityKey <> 0
GO
