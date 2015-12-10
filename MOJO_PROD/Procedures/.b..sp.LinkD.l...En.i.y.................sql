USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkDeleteEntity]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLinkDeleteEntity]
@EntityKey int,
@AssociatedEntity varchar(50)

AS --Encrypt

DELETE
	FROM tLink
	WHERE
		EntityKey = @EntityKey
		and AssociatedEntity = @AssociatedEntity 

	RETURN 1
GO
