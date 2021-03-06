USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteGet]
	@QuoteKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Get GLCompanyName
|| 11/26/07 GHL 8.5      Removed *= joins for SQL 2005
|| 01/18/08 BSH 8.5     (18369)Check if Quote is associated to an Estimate.
|| 02/18/10 GHL 10.518   Since the UseEstimate variable is only used on the UI to lock the GL company
||                       and estimates can be entered without a project, but with a campaign
||                       The issue is that there no default GL Company on the campaign.
||                       So I am only setting the UseEstimate variable, if there is a project on the estimate  
|| 05/22/12 GHL 10.556   (143227) Added EstimateEntity and EstimateEntityName to display on screen
*/

DECLARE @UseEstimate int

IF EXISTS(SELECT 1 FROM tEstimateTaskExpense te (nolock)
			INNER JOIN tQuoteDetail qd (nolock) on te.QuoteDetailKey = qd.QuoteDetailKey
			INNER JOIN tQuote q (nolock) on qd.QuoteKey = q.QuoteKey
			INNER JOIN tEstimate e (nolock) on te.EstimateKey = e.EstimateKey
			WHERE q.QuoteKey = @QuoteKey
			AND   isnull(e.ProjectKey, 0) > 0
			)
	SELECT @UseEstimate = 1
ELSE
	SELECT @UseEstimate = 0

		SELECT 
			q.*,
			@UseEstimate as UseEstimate,
			pot.PurchaseOrderTypeName,
			pot.HeaderFieldSetKey,
			pot.DetailFieldSetKey,
--			pot.MarkupType,
			p.ProjectName,
			p.ProjectNumber,
			t.TaskID,
			i.ItemID,
			ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS SendRepliesToName,
			(SELECT COUNT(*) FROM tQuoteDetail qd (NOLOCK) WHERE q.QuoteKey = qd.QuoteKey) AS DetailCount,
			(SELECT TOP 1 qd.ClassKey FROM tQuoteDetail qd (NOLOCK) WHERE q.QuoteKey = qd.QuoteKey AND qd.ClassKey IS NOT NULL) AS ClassKey,
			glc.GLCompanyName,
			isnull(v.[Estimate Entity],'Project') as EstimateEntity,
			v.[Estimate Entity Name] as EstimateEntityName
		FROM 
			tQuote q (nolock)
			LEFT OUTER JOIN tPurchaseOrderType pot (nolock) ON q.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
			LEFT OUTER JOIN tProject p (nolock) ON q.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tTask t (nolock) ON q.TaskKey = t.TaskKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON q.ItemKey = i.ItemKey
			LEFT OUTER JOIN tUser u (NOLOCK) ON q.SendRepliesTo = u.UserKey
			LEFT OUTER JOIN tGLCompany glc (nolock) ON q.GLCompanyKey = glc.GLCompanyKey
			LEFT OUTER JOIN vListing_Quote v (nolock) on q.QuoteKey = v.QuoteKey
		WHERE
			q.QuoteKey = @QuoteKey

	RETURN 1
GO
