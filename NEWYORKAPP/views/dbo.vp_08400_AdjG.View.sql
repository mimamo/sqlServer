USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vp_08400_AdjG]    Script Date: 12/21/2015 16:00:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400_AdjG] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400_AdjG
*
*++* Narrative: Figures out the current adjustments to adjusting docs in this batch
*     
*
*
*   Called by: pp_08400
* 
*/

SELECT SUM(CONVERT(DEC(28,3),AdjAmt) - CONVERT(DEC(28,3),CuryRGOLAmt))  AdjAmt,  
       SUM(CONVERT(DEC(28,3),CuryAdjgAmt))  CuryAdjgAmt,
       SUM(CONVERT(DEC(28,3),CuryRGOLAmt))  RGOLAmt,
       w.UserAddress,
       j.CustID,
       j.AdjgDocType,
       j.AdjgRefNbr
  FROM ARAdjust j,  WrkRelease w
 WHERE w.Module = 'AR' AND w.Batnbr = j.AdjBatnbr
 GROUP BY w.UserAddress,
       j.CustID,
       j.AdjgDocType,
       j.AdjgRefNbr
GO
