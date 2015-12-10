USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectSplitBillingGet]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectSplitBillingGet]
	@ProjectSplitBillingKey int
	
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (13583) Created for Enhancement
*/

	SELECT	sb.*, c.CustomerID
	FROM	tProjectSplitBilling sb (nolock)
	INNER JOIN tCompany c ON sb.ClientKey = c.CompanyKey
	WHERE	sb.ProjectSplitBillingKey = @ProjectSplitBillingKey
GO
