USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGroupGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptNoteGroupGetList]

	@CompanyKey int,
	@AssociatedEntity varchar(50),
	@EntityKey int


AS --Encrypt

		SELECT tNoteGroup.*
		FROM tNoteGroup (nolock)
		WHERE
		CompanyKey = @CompanyKey and
		AssociatedEntity = @AssociatedEntity and
		EntityKey = @EntityKey
		Order By DisplayOrder

	RETURN 1
GO
