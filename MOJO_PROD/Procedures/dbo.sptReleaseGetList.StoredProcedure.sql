USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReleaseGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReleaseGetList]
AS --Encrypt

/*
|| When      Who Rel     What
|| 1/9/08    CRG 1.0     Added ability to sort latest release to the top (with Null releases at the very top)
|| 6/9/09    CRG 10.0.2.7 Changed DateSort value to 1/1 so that it doesn't get into any culture problems on non-US servers
|| 
*/

	SELECT	*,
			CASE 
				WHEN DateInstalled IS NULL THEN '1/1/2050'
				ELSE DateInstalled 
			END AS DateSort
	FROM	tRelease (NOLOCK)
	ORDER BY DateSort DESC, ReleaseKey DESC
GO
