USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetFavoriteContactWithTwitterIDs]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetFavoriteContactWithTwitterIDs]
	@CompanyKey int,
	@AccountManagerKey int
	
	AS --Encrypt

	/*
	  || When     Who Rel   What
	  || 01/16/15 RLB 10588 Added to sales dashboard to pull an account manager favorite contacts with twitter id
	  || 03/11/15 RLB 10590 Fixed blank twitter id's getting pulled into twitter feed
	*/
 
	 SELECT u.*, ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as FormattedName 
	 FROM tUser u (NOLOCK)
	 INNER JOIN tAppFavorite af (NOLOCK) on u.UserKey = af.ActionKey and af.ActionID = 'cm.contacts'
	 WHERE af.CompanyKey = @CompanyKey
	 AND af.UserKey = @AccountManagerKey
	 AND ISNULL(u.TwitterID, '') <> ''
	 ORDER BY u.LastName
	 
	 RETURN 1
GO
