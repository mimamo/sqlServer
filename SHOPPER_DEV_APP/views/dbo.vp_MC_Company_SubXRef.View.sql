USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vp_MC_Company_SubXRef]    Script Date: 12/21/2015 14:33:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_MC_Company_SubXRef] AS

   SELECT c.CpnyId, CpnyActive = C.Active, c.CpnyCOA, c.DatabaseName, s.Sub, SubActive = s.Active 
   FROM vs_Company c (NOLOCK) INNER JOIN vs_SubXRef s (NOLOCK) ON c.CpnySub = s.CpnyID
GO
