USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetTopParent]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetTopParent]
	(
	@ActivityKey int
	,@oParentActivityKey int OUTPUT	
	)
AS -- Encrypt

/*
|| When      Who Rel      What
|| 01/09/09  GHL 10.5.0.0 Inserting now in tActivity instead of tProjectNote
*/
	SET NOCOUNT ON
	
	-- This is much easier now that the top parent is stored as tActivity.RootActivityKey
	SELECT @oParentActivityKey = RootActivityKey FROM tActivity (NOLOCK) WHERE ActivityKey = @ActivityKey
	
	/*
	-- We could also use recursivity like in 10.0
	 
	DECLARE @ParentActivityKey int
	
	SELECT	@ParentActivityKey = ParentActivityKey
	FROM	tActivity (NOLOCK)
	WHERE	ActivityKey = @ActivityKey
	
	SELECT	@ParentActivityKey = ISNULL(@ParentActivityKey, 0)
	
	IF @ParentActivityKey = 0
		SELECT @oParentActivityKey = @ActivityKey
	ELSE
		EXEC sptProjectNoteGetTopParent @ParentActivityKey, @oParentActivityKey OUTPUT
	*/
		
	RETURN 1
GO
