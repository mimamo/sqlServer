USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_GLAccountRec]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_GLAccountRec]
AS

/*
|| When      Who Rel     What
|| 05/03/11  MFT 10.543	 Created
|| 03/05/14  MFT 10.577  Added tGLCompany and fields
*/

SELECT
	ar.GLAccountRecKey,
	ar.GLAccountKey,
	ar.GLCompanyKey,
	ar.CompanyKey,
	ar.StartDate AS [Statement Start Date],
	ar.EndDate AS [Statement End Date],
	ar.StartBalance AS [Beginning Balance],
	ar.EndBalance AS [Statement Balance],
	CASE ar.Completed WHEN 1 THEN 'Completed' ELSE 'Open' END AS [Status],
	CASE ar.OpeningRec WHEN 1 THEN 'YES' ELSE 'NO' END AS [Opening Rec],
	ar.OpeningUncleared as [Opening Uncleared Amount],
	ar.OpeningCleared as [Opening Cleared Amount],
	ar.OtherIncrease AS [Other Increases],
	ar.OtherDecrease AS [Other Decreases],
	acct.AccountNumber AS [Account Number],
	acct.AccountName AS [Account Name],
	acct.AccountNumber + ' - ' + acct.AccountName AS [Account],
	glc.GLCompanyName AS [GL Company Name],
	glc.GLCompanyID AS [GL Company ID]
FROM
	tGLAccountRec ar (nolock)
	INNER JOIN tGLAccount acct (nolock) ON ar.GLAccountKey = acct.GLAccountKey
	LEFT JOIN tGLCompany glc (nolock) ON ar.GLCompanyKey = glc.GLCompanyKey
GO
