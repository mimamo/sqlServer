USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadUserGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadUserGet]
	@LeadKey int
AS

/*
|| When     Who Rel     What
|| 06/03/09 MFT 10.500	Creation for OpportunitySnapshot
*/

SET NOCOUNT ON

SELECT
	lu.*,
	u.FirstName + ' ' + u.LastName AS UserName,
	u.Phone1,
	u.Cell,
	u.Email,
	u.CompanyKey,
	c.CompanyName
FROM
	tLeadUser lu (nolock)
	INNER JOIN tUser u (nolock)
		ON lu.UserKey = u.UserKey
	LEFT JOIN tCompany c (nolock)
		ON u.CompanyKey = c.CompanyKey
WHERE 
	lu.LeadKey = @LeadKey

RETURN 1
GO
