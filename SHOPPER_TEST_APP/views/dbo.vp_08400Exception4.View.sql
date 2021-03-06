USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400Exception4]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX


CREATE VIEW [dbo].[vp_08400Exception4] AS 
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400Exception4
*
*++* Narrative: This view will remove Batches where no Account or Subaccount exist. 
*     
*
*
*   Called by: pp_08400prepwork
* 
*/
 
/***** No Account or SubAccount Exist *****/
SELECT DISTINCT t.BatNbr, Module = 'AR', 
       msgid = CASE WHEN t.acct = ' ' OR t.acct IS null THEN 6928 ELSE 6929 END,
       w.UserAddress 
  FROM WrkRelease w INNER JOIN ARTran t 
                          ON w.Module = 'AR' AND w.BatNbr = t.BatNbr
 WHERE t.Acct = ' ' OR  t.Acct is null 
       OR t.Sub = ' ' OR t.sub is null
GO
