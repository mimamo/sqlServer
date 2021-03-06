USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaWorksheetGet]
	@MediaWorksheetKey int

AS

/*
|| When      Who Rel      What
|| 6/12/13   CRG 10.5.6.9 Created
|| 12/11/13  CRG 10.5.7.5 Added ProductName and UserName
|| 06/11/14  GHL 10.5.8.1 Added count of MediaOrderKeys
||                        If media orders have been created, do not change the grouping method
*/

	SELECT	w.*,
			c.CustomerID,
			c.CompanyName,
			p.ProjectNumber,
			p.ProjectName,
			cp.ProductName,
			u.UserName AS PrimaryBuyerName,
			(select count(*) from tMediaOrder (nolock) where MediaWorksheetKey = @MediaWorksheetKey) as MediaOrderCount
	FROM	tMediaWorksheet w (nolock)
	LEFT JOIN tCompany c (nolock) ON w.ClientKey = c.CompanyKey
	LEFT JOIN tProject p (nolock) ON w.ProjectKey = p.ProjectKey
	LEFT JOIN tClientProduct cp (nolock) ON w.ClientProductKey = cp.ClientProductKey
	LEFT JOIN vUserName u (nolock) ON w.PrimaryBuyerKey = u.UserKey
	WHERE	w.MediaWorksheetKey = @MediaWorksheetKey
GO
