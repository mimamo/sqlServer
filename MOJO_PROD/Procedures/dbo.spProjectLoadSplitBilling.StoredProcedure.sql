USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadSplitBilling]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadSplitBilling]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/14/08   CRG 1.0.0.0  Created for Project Manager
|| 7/28/09   CRG 10.5.0.4 Added Client fields because we switched the screen to a Client lookup from a combo.
*/

	SELECT	sb.*, c.CustomerID AS ClientID, c.CompanyName AS ClientName
	FROM	tProjectSplitBilling sb (nolock)
	INNER JOIN tCompany c (nolock) ON sb.ClientKey = c.CompanyKey
	WHERE	sb.ProjectKey = @ProjectKey
	ORDER BY c.CustomerID
GO
