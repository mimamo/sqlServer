USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[SSI_FMG_vs_Company_SubXRef]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SSI_FMG_vs_Company_SubXRef] AS

   SELECT c.CpnyId, c.Active, c.CpnyCOA, c.DatabaseName, s.Sub 
   FROM vs_Company c (NOLOCK) INNER JOIN vs_SubXRef s (NOLOCK) ON c.CpnySub = s.CpnyID
GO
