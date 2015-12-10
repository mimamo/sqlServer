USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUserGetForCompany]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spUserGetForCompany]
	@CompanyKey int,
	@UserKey int = NULL
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 09/17/2009 RLB 10.5.1.0 (63569) changed because we can now have users with no company key
*/


	SELECT	tUser.*,
			ISNULL(tUser.FirstName, '') + ' ' + ISNULL(tUser.LastName, '') AS UserName,
			ISNULL(tUser.FirstName, '') + ' ' + ISNULL(tUser.LastName, '') + ' (' + ISNULL(tUser.Email,'') + ')' AS UserNameEmail
	FROM	tUser (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND     @CompanyKey > 0
	AND		(Active = 1 OR UserKey = @UserKey)
	Order By tUser.LastName

	RETURN 1
GO
