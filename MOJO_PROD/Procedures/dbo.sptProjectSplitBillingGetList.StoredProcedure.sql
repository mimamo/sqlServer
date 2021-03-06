USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingGetList]
	@ProjectKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (13583) Created for Enhancement
*/

	SELECT	sb.*, c.CustomerID, c.CompanyName
	FROM	tProjectSplitBilling sb (nolock)
	INNER JOIN tCompany c (nolock) ON sb.ClientKey = c.CompanyKey
	WHERE	sb.ProjectKey = @ProjectKey
	ORDER BY c.CustomerID
GO
