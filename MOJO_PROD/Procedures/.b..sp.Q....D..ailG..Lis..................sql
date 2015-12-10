USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDetailGetList]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDetailGetList]

	@QuoteKey int


AS --Encrypt
		    
 /*
  || When     Who Rel   What
  || 11/26/07 GHL 8.5   Removed non ANSI joins for SQL 2005 
  */
		            
		SELECT qd.*,		 
			p.ProjectNumber,
			t.TaskID,
			c.ClassID,
			i.ItemID
		FROM tQuoteDetail qd (NOLOCK) 
			LEFT OUTER JOIN tProject p (NOLOCK) ON qd.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tTask t (NOLOCK) ON qd.TaskKey = t.TaskKey
			LEFT OUTER JOIN tClass c (NOLOCK) ON qd.ClassKey = c.ClassKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON qd.ItemKey = i.ItemKey
		WHERE
		qd.QuoteKey = @QuoteKey
		ORDER BY
		LineNumber

	RETURN 1
GO
