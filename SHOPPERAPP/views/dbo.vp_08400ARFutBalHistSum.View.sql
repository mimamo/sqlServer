USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vp_08400ARFutBalHistSum]    Script Date: 12/21/2015 16:12:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400ARFutBalHistSum] AS


SELECT Balance = Sum(CASE WHEN DocType IN ('IN','DM','SC','NC','FI')
                            THEN HistBal
                          WHEN DocType IN ('CM','SB')
                            THEN -(HistBal + DiscBal)
                          WHEN DocType IN ('PP','PA')
                            THEN -(HistRcpt + DiscBal)
/*                          WHEN DocType IN ('AD','RA')
                            THEN Accrued
*/
                          ELSE
                            0
                      END),
       RGOLAmt = SUM(RGOLamt),
       v.CpnyID, v.CustID, v.UserAddress, 
       PrePay = SUM(PrePay),
       lastinvdate = MAX(V.LastInvDate),
       lastactdate = MAX(V.lastactdate) 
  FROM vp_08400ARBalancesHist v, arsetup (NOLOCK)
 WHERE v.perpost > arsetup.currpernbr
GROUP BY UserAddress, CpnyID, CustID
GO
