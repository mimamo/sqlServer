USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingGetByProject]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingGetByProject]
	@ProjectKey int
	
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/23/07  CRG 8.5     (13583) Created for Enhancement
|| 10/25/10  GHL 10.537  Added Client info to display on flash screen
*/

	SELECT	psb.*
	        ,c.CompanyName as ClientName
			,c.CustomerID
			,isnull(c.CustomerID + ' - ', '') + isnull(c.CompanyName, '') as ClientFullName 
	FROM	tProjectSplitBilling  psb (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on psb.ClientKey = c.CompanyKey
	WHERE	psb.ProjectKey = @ProjectKey
GO
