USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSourceInsert]
	@CompanyKey int,
	@SourceName varchar(200),
	@Active int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  QMD 10.5.0.0 Initial Release
*/

	INSERT tSource
		(
		CompanyKey,
		SourceName,
		Active,
		LastModified
		)

	VALUES
		(
		@CompanyKey,
		@SourceName,
		@Active,
		GetDate()
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
