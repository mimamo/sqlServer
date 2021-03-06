USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserProjectSearch]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserProjectSearch]
	@ProjectKey int
	
as --Encrypt

/*
|| When      Who  Rel     What
|| 10/22/13  RLB  10573   (193598) Created for Diary Add Email to just pull project users
|| 12/04/13  RLB  10575   (198608) added sort
*/

	SELECT u.*
		   ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
		   ,s.Description AS ServiceDescription
		   ,s.ServiceCode
		   ,0 AS ASC_Selected
    FROM tAssignment asm (nolock)
    INNER JOIN tProject p (nolock) on asm.ProjectKey = p.ProjectKey
    LEFT OUTER JOIN tUser u (nolock) on asm.UserKey = u.UserKey
    LEFT OUTER JOIN tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
    WHERE asm.ProjectKey = @ProjectKey
	Order By UserName
GO
