USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormGetAvailUsers]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormGetAvailUsers]
 (
  @CompanyKey int,
  @ProjectKey int,
  @Mode int,
  @UserKey int = NULL
 )
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	IF @Mode = 1 -- Entire Company
		SELECT	us.UserKey
				,us.FirstName + ' ' + us.LastName AS FullName
				,us.LastName
				,us.FirstName
		FROM	tUser      us (NOLOCK)
				,tCompany   c (NOLOCK)
		WHERE	us.CompanyKey = @CompanyKey
		AND		(us.Active = 1 OR us.UserKey = @UserKey)
		AND		us.CompanyKey = c.CompanyKey
		ORDER BY FullName
	ELSE
		-- For a project
		select	us.UserKey
				,us.FirstName + ' ' + us.LastName as FullName
				,us.LastName
				,us.FirstName
		from	tUser       us (nolock)
				,tAssignment ag (nolock)
				,tCompany    c  (nolock)
		where	ag.ProjectKey = @ProjectKey
		and		ag.UserKey = us.UserKey
		and		(us.Active = 1 OR us.UserKey = @UserKey)
		and		us.CompanyKey = c.CompanyKey
		order by FullName
 
 
 /* set nocount on */
 return 1
GO
