USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vp_ShareGLTranCondition]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_ShareGLTranCondition] AS

SELECT w.UserAddress, t.BatNbr, t.Module, DrAmt = SUM(t.DrAmt), CrAmt = SUM(t.CrAmt), 
	TranCount = Count(t.BatNbr)
FROM WrkRelease w LEFT OUTER JOIN GLTran t ON w.BatNbr = t.BatNbr AND w.Module = t.Module
GROUP BY w.UserAddress, t.BatNbr, t.Module
GO
