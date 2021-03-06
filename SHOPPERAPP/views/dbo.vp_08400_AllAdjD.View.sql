USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_08400_AllAdjD]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400_AllAdjD] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400_AllAdjD
*
*
* Narrative: Figures out the current adjustments to adjusted docs in this batch
*     
*
*
*   Called by: pp_08400
* 
*/


SELECT PerClosed = MAX(CASE WHEN PerAppl > AdjgPerPost THEN PerAppl ELSE AdjgPerPost END),
       PerOpen =   MIN(PerAppl),
       AdjgDocDate= MAX(case AdjgDocType When 'CM' then '' Else AdjgDocDate END),
       CustID,
       AdjdDocType,
       AdjdRefNbr
  FROM ARAdjust 
 GROUP BY 
       CustID,
       AdjdDocType,
       AdjdRefNbr
GO
