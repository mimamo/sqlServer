USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteUpdate]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteUpdate]
	@ActivityKey int,
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@ProjectKey int,
	@ParentActivityKey int,
	@Subject varchar(2000),
	@Note text,
	@VisibleToClient tinyint


AS --Encrypt

/*
|| When     Who Rel   What
|| 01/12/09 GHL 10.5  Changed tProjectNote to tActivity               
*/

	UPDATE
		tActivity
	SET
		CompanyKey = @CompanyKey,
		ProjectKey = @ProjectKey,
		ParentActivityKey = @ParentActivityKey,
		DateUpdated = GETDATE(),
		Subject = @Subject,
		Notes = @Note,
		VisibleToClient = @VisibleToClient 
	WHERE
		ActivityKey = @ActivityKey 

	RETURN 1
GO
