USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetContactByEmail]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetContactByEmail]
	@Email varchar(100),
	@OwnerCompanyKey int

AS


SELECT	*
FROM	tUser (nolock)
WHERE	UPPER(Email) = UPPER(@Email)
AND		OwnerCompanyKey = @OwnerCompanyKey
GO
