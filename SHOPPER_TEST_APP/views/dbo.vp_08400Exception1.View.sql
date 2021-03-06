USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400Exception1]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400Exception1] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400Exception1
*
*++* Narrative: This view will remove Batches where Refnbrs are Null or 
*++*            or trans are missing               
*
*
*   Called by: pp_08400prepwork
* 
*/
SELECT DISTINCT w.UserAddress, Module = 'AR', d.BatNbr, Situation = 12125
  FROM WrkRelease w INNER JOIN ARDoc d 
                          ON w.Batnbr = d.Batnbr
                   INNER JOIN currncy c 
                          ON d.curyid+' ' = c.curyid
 WHERE w.Module = 'AR'   
   AND  (SELECT COUNT(t.RefNbr)
           FROM ARTran t
          WHERE t.RefNbr = d.RefNbr 
            AND t.TranType = d.DocType) = 0 
            AND d.DocType NOT IN ('PA', 'CM', 'NS', 'NC', 'RP', 'SB', 'PP', 'RA')
UNION

SELECT DISTINCT w.UserAddress, Module = 'AR', t.BatNbr, Situation = 12126
   
  FROM WrkRelease w INNER join ARTran t
                         ON  w.Module = 'AR' 
                         AND w.BatNbr = t.BatNbr
                   LEFT outer JOIN ARDoc d 
                         ON t.RefNbr = d.RefNbr 
                         AND t.TranType = d.DocType 
                         AND t.BatNbr = d.BatNbr
  WHERE  t.TranType IN ('IN', 'DM') 
         AND d.RefNbr Is Null
GO
