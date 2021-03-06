USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_08400ARBalHistSum]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400ARBalHistSum] AS


SELECT Balance = SUM(CASE WHEN DocType IN ('IN','DM','SC','NC','FI')
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
       PrePay = SUM(Prepay),
       lastinvdate = MAX(V.LastInvDate),
       lastactdate = MAX(lastactdate) 
  FROM vp_08400ARBalancesHist v, arsetup (NOLOCK)
 WHERE v.perpost <= arsetup.currpernbr
GROUP BY UserAddress, CpnyID, CustID
GO
