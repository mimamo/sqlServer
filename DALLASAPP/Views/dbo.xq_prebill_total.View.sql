USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xq_prebill_total]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xq_prebill_total]
AS
SELECT     rp.RI_ID, SUM(dbo.GLTran.CrAmt - dbo.GLTran.DrAmt) AS proj_pb_amt
FROM         dbo.RptRuntime AS rp INNER JOIN
                      dbo.GLTran ON rp.BegPerNbr >= dbo.GLTran.PerPost
WHERE     (dbo.GLTran.Acct BETWEEN '2100' AND '2120') AND (dbo.GLTran.Posted = 'P')
GROUP BY rp.RI_ID
GO
