USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_GL001]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_GL001]
as
SELECT RefNbr, ProjectID, FiscYr, Acct, PerEnt, PerPost, DrAmt, CrAmt, CuryCrAmt, CuryDrAmt, BatNbr, Posted, LUpd_User, LedgerID, JrnlType
FROM GLTRAN
WHERE ProjectID = 'NON POST'
	--AND FiscYr = '2007'
	AND acct between '1200' and '1299'
GO
