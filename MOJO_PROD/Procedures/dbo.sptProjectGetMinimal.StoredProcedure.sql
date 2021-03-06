USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetMinimal]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetMinimal]
	@ProjectKey int

AS --Encrypt

/*
|| When      Who Rel		What
|| 03/29/12  MAS 10.5.5.2	Created
|| 09/25/13  GHL 10.5.7.2   Added currency ID
|| 01/15/15  GHL 10.5.8.8   Added Client because it is very useful
*/
 	
	
SELECT p.ProjectKey,
	p.ProjectNumber, 
	p.ProjectName,
	p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
	p.OfficeKey, OfficeID, o.OfficeName,
	p.GLCompanyKey, glc.GLCompanyID,glc.GLCompanyName,
	p.CurrencyID,
	p.ClientKey
FROM tProject p (nolock)
	LEFT OUTER JOIN tOffice o (NOLOCK) ON p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON p.GLCompanyKey = glc.GLCompanyKey
WHERE p.ProjectKey = @ProjectKey
GO
