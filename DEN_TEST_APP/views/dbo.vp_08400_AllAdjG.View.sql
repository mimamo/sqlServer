USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400_AllAdjG]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400_AllAdjG] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400_AllAdjG
*
*++* Narrative: Figures out the current adjustments to adjusting docs in this batch
*     
*
*
*   Called by: pp_08400
* 
*/

SELECT PerClosed = MAX(CASE WHEN j.PerAppl > d.PerPost THEN j.PerAppl ELSE d.PerPost END),
       PerOpen   = MIN(j.PerAppl),
       j.CustID,
       j.AdjgDocType,
       j.AdjgRefNbr
  FROM ARAdjust j INNER JOIN ARDoc d 
                     ON d.CustId = j.CustId AND d.DocType = j.AdjdDocType 
                    AND d.RefNbr = j.AdjdRefNbr
 GROUP BY 
       j.CustID,
       j.AdjgDocType,
       j.AdjgRefNbr
GO
