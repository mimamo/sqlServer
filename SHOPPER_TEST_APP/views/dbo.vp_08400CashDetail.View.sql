USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[vp_08400CashDetail]    Script Date: 12/21/2015 16:06:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400CashDetail] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400CashDetail
*
*++* Narrative:  Calculates Receipts and Disbursements for CA.
*     
*
*
*   Called by: pp_08400
* 
*/

SELECT Acct = b.BankAcct, Sub = b.BankSub, b.PerPost,  
       TranDate = b.DateEnt, b.CpnyID, 
       Receipt = b.DepositAmt,
       CuryReceipt = b.CuryDepositAmt,
       w.UserAddress
  FROM WrkRelease w INNER JOIN Batch b
			    ON w.batnbr = b.batnbr
                           AND w.Module = b.Module
                    INNER JOIN CashAcct c 
                            ON b.BankAcct = c.BankAcct
                           AND b.BankSub  = c.BankSub
                           AND b.CpnyID   = c.CpnyID
 WHERE w.Module = 'AR'
GO
