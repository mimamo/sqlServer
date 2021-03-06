USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteDelete]
	@ActivityKey int

AS --Encrypt

/*
|| When     Who Rel   What
|| 01/12/09 GHL 10.5  Changed tProjectNote to tActivity               
*/

	IF EXISTS (SELECT 1
				   FROM tActivity (NOLOCK)
				   WHERE ParentActivityKey = @ActivityKey)
		RETURN -1

	exec sptActivityDelete @ActivityKey

	RETURN 1
GO
