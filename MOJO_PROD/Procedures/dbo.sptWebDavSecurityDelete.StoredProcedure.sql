USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityDelete]
	@CompanyKey int,
	@ProjectKey int,
    @Entity varchar(50),
	@EntityKey int,
	@Path varchar(2000),
	@DeleteSubFolders tinyint
AS

/*
|| When      Who Rel      What
|| 9/8/11    CRG 10.5.4.8 Created
*/

	SELECT	@ProjectKey = ISNULL(@ProjectKey, 0),
			@Entity = ISNULL(@Entity, ''),
			@EntityKey = ISNULL(@EntityKey, 0),
			@Path = UPPER(ISNULL(@Path, ''))

	DELETE	tWebDavSecurity
	WHERE	CompanyKey = @CompanyKey
	AND		((ProjectKey = @ProjectKey)
			OR
			(@DeleteSubFolders = 1 AND @ProjectKey = 0)) --We're deleting a Company level exception and all project level ones as well
	AND		Entity = @Entity
	AND		EntityKey = @EntityKey
	AND		((UPPER(ISNULL(Path, '')) = @Path)
			OR
			(@DeleteSubFolders = 1 AND UPPER(LEFT(ISNULL(Path, ''), LEN(@Path))) = @Path))
GO
