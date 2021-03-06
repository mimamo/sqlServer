USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xCog_ExpAcctTotalsATable]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_ExpAcctTotalsATable]
AS
-- This view is for importing access tables in the Expense Model.
-- Base = NODATA, Remove Obsolete, Save as AccountsATable File.


--Account Access Tables

-- Regular Account Validation for all departments
Select  RTRIM(xas.Acct) + ' - ' + RTRIM(REPLACE(a.descr, ',', '')) as Account
	, Case When xas.sub = '1000' Then
			Case When xas.user1 = '                                                         ' Then
				'1000 - All Other'
				Else RTRIM(xas.user1) END
		When xas.sub = '1012' THEN
			Case When xas.user1 = '                                                         ' Then
				'1012 - All Other IT'
				Else RTRIM(xas.user1) END
		ELSE RTRIM(xas.Sub) + ' - ' + RTRIM(s.Descr) END as Sub
	, 	CASE WHEN xas.Active = '0' THEN 
		Case When IsNull(ah.acct, 'xx') = 'xx' THEN 'NODATA'
		ELSE 'READ' END
		ELSE 'READ' END as AccessLevel
FROM SQL1.Denversys.dbo.acctsub xas JOIN Account a ON xas.Acct = a.Acct
	JOIN SubAcct s ON xas.Sub = s.Sub
	JOIN xCog_AccessTables ON a.Acct = xCog_AccessTables.ItemName AND xCog_AccessTables.Active = 'TRUE'
	LEFT JOIN AcctHist ah ON xas.Acct = ah.Acct AND xas.Sub = ah.Sub AND ah.FiscYr = '2011' and LedgerID = 'ACTUAL'
Where s.Sub Not In ('0000', '1050','1051','1052', '1042', '1076', '1081', '1095', '2800', '5000')




UNION ALL
-- read total for all cost centers
Select 'TOTAL'
	, RTRIM(xas.Sub) + ' - ' + RTRIM(s.Descr)
	, 'READ'
FROM SQL1.Denversys.dbo.acctsub xas JOIN Account a ON xas.Acct = a.Acct
	JOIN SubAcct s ON xas.Sub = s.Sub
	JOIN xCog_AccessTables ON a.Acct = xCog_AccessTables.ItemName AND xCog_AccessTables.Active = 'TRUE'
	LEFT JOIN AcctHist ah ON xas.Acct = ah.Acct AND xas.Sub = ah.Sub AND ah.FiscYr = '2011' and LedgerID = 'ACTUAL'
Where s.Sub Not In ('0000', '1050','1051','1052', '1042', '1076', '1081', '1095', '2800', '5000')
Group by xas.Sub, s.Descr


-- Read total for all agency breakouts
Union ALL

Select 'TOTAL'
	, Case When xas.sub = '1000' Then
			Case When xas.user1 = '                                                         ' Then
				'1000 - All Other'
				Else RTRIM(xas.user1) END
		When xas.sub = '1012' THEN
			Case When xas.user1 = '                                                         ' Then
				'1012 - All Other IT'
				Else RTRIM(xas.user1) END
		ELSE RTRIM(xas.Sub) + ' - ' + RTRIM(s.Descr) END as Sub
	, 'READ'
FROM SQL1.Denversys.dbo.acctsub xas JOIN Account a ON xas.Acct = a.Acct
	JOIN SubAcct s ON xas.Sub = s.Sub
	JOIN xCog_AccessTables ON a.Acct = xCog_AccessTables.ItemName AND xCog_AccessTables.Active = 'TRUE'
	LEFT JOIN AcctHist ah ON xas.Acct = ah.Acct AND xas.Sub = ah.Sub AND ah.FiscYr = '2011' and LedgerID = 'ACTUAL'
Where s.Sub  In ('1000', '1012')
Group by xas.User1, xas.Sub, s.Descr


UNION ALL

--Read All accounts of subs that have a break out.
--Fixes Subtotal issues
Select  RTRIM(xas.Acct) + ' - ' + RTRIM(REPLACE(a.descr, ',', '')) as Account
	, RTRIM(xas.Sub) + ' - ' + RTRIM(s.Descr)  as Sub
	, 	CASE WHEN xas.Active = '0' THEN 
		Case When IsNull(ah.acct, 'xx') = 'xx' THEN 'NODATA'
		ELSE 'READ' END
		ELSE 'READ' END as AccessLevel
FROM SQL1.Denversys.dbo.acctsub xas JOIN Account a ON xas.Acct = a.Acct
	JOIN SubAcct s ON xas.Sub = s.Sub
	JOIN xCog_AccessTables ON a.Acct = xCog_AccessTables.ItemName AND xCog_AccessTables.Active = 'TRUE'
	LEFT JOIN AcctHist ah ON xas.Acct = ah.Acct AND xas.Sub = ah.Sub AND ah.FiscYr = '2011' and LedgerID = 'ACTUAL'
Where s.Sub  In ('1000', '1012')
GO
