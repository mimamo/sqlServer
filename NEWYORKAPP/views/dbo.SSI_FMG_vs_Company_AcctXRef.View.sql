USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[SSI_FMG_vs_Company_AcctXRef]    Script Date: 12/21/2015 16:00:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SSI_FMG_vs_Company_AcctXRef] AS

   SELECT c.CpnyId, c.Active, c.CpnyCOA, c.DatabaseName, a.Acct 
   FROM vs_Company c (NOLOCK) INNER JOIN vs_AcctXRef a (NOLOCK) ON c.CpnyCOA = a.CpnyID
GO
