USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_08400IncorrectRGOL]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400IncorrectRGOL] AS

SELECT BatNbr = w.batnbr, UserAddress = w.UserAddress, AdjgRefNbr = j.AdjgRefNbr,
	CuryRGOLAmt = SUM(CONVERT(DEC(28,3),j.CuryRGOLAmt))
  FROM WRKRELEASE w INNER JOIN BATCH b  
                       ON w.BatNbr = b.BatNbr 
                      AND w.Module = b.Module
                    INNER JOIN ARAdjust j
                       ON b.BatNbr = j.AdjBatNbr
		    CROSS JOIN GLSetup g (NOLOCK)

 WHERE w.Module = 'AR' 
   AND j.CuryAdjdCuryId = g.BaseCuryId
   AND b.CuryID = g.BaseCuryId
 GROUP BY w.UserAddress, w.BatNbr, j.AdjgRefNbr
GO
