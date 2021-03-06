USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyMapGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyMapGetList]
	@CompanyKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/26/12  MFT 10.554  Created
|| 03/28/12  MFT 10.554  Added Journal Entry fields
|| 03/30/12  MFT 10.554  Added Cash Sweep fields
|| 03/19/15  WDF 10.590  Remove Cash Sweep fields
*/

SELECT
	gcm.*,
	gcs.GLCompanyName AS SourceGLCompanyName,
	gcs.GLCompanyID AS SourceGLCompanyID,
	gct.GLCompanyName AS TargetGLCompanyName,
	gct.GLCompanyID AS TargetGLCompanyID,
	apt.AccountName AS APDueToAccountName,
	apt.AccountNumber AS APDueToAccountNumber,
	apf.AccountName AS APDueFromAccountName,
	apf.AccountNumber AS APDueFromAccountNumber,
	art.AccountName AS ARDueToAccountName,
	art.AccountNumber AS ARDueToAccountNumber,
	arf.AccountName AS ARDueFromAccountName,
	arf.AccountNumber AS ARDueFromAccountNumber,
	jet.AccountName AS JEDueToAccountName,
	jet.AccountNumber AS JEDueToAccountNumber,
	jef.AccountName AS JEDueFromAccountName,
	jef.AccountNumber AS JEDueFromAccountNumber
FROM
	tGLCompanyMap gcm (nolock)
	INNER JOIN tGLCompany gcs (nolock) ON gcm.SourceGLCompanyKey = gcs.GLCompanyKey
	INNER JOIN tGLCompany gct (nolock) ON gcm.TargetGLCompanyKey = gct.GLCompanyKey
	LEFT JOIN tGLAccount apt (nolock) ON gcm.APDueToAccountKey = apt.GLAccountKey
	LEFT JOIN tGLAccount apf (nolock) ON gcm.APDueFromAccountKey = apf.GLAccountKey
	LEFT JOIN tGLAccount art (nolock) ON gcm.ARDueToAccountKey = art.GLAccountKey
	LEFT JOIN tGLAccount arf (nolock) ON gcm.ARDueFromAccountKey = arf.GLAccountKey
	LEFT JOIN tGLAccount jet (nolock) ON gcm.JEDueToAccountKey = jet.GLAccountKey
	LEFT JOIN tGLAccount jef (nolock) ON gcm.JEDueFromAccountKey = jef.GLAccountKey
WHERE gcs.CompanyKey = @CompanyKey
ORDER BY gcs.GLCompanyName

RETURN 1
GO
