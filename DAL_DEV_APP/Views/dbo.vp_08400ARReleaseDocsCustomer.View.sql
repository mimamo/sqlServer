USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_08400ARReleaseDocsCustomer]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX


CREATE VIEW [dbo].[vp_08400ARReleaseDocsCustomer] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400ARReleaseDocsCustomer
*
*++* Narrative:  
*     
*
*
*   Called by: pp_08400
* 
*/

/***** AR Release Customer View *****/

SELECT UserAddress, CustID, CpnyID,PerPost = MAX(RTRIM(PerPost)), 
        Docdate = MAX(Docdate), DueDate = MAX(DueDate),
        CurrentAmt = SUM(CASE WHEN (RTRIM(PerPost) <= RTRIM(CurYr) + RTRIM(CurPer)) 
                              THEN CustomerAmt ELSE 0 END),
        FutureAmt = SUM(CASE WHEN (RTRIM(PerPost) > RTRIM(CurYr) + RTRIM(CurPer)) 
                             THEN CustomerAmt ELSE 0 END), 
        LastActDate = MAX(DocDate), 
        LastInvcDate = MAX(CASE DocType WHEN 'IN' 
                                        THEN DocDate ELSE ' ' END), 
        LastFinChrgDate = MAX(CASE DocType WHEN 'FI' 
                                           THEN DocDate ELSE ' ' END),
        TotalOpnOrd = SUM(CASE WHEN (RTRIM(PerPost) > RTRIM(CurYr) + RTRIM(CurPer)) 
                               THEN StmtBal ELSE 0 END),
        TotPrePay = SUM(CASE WHEN (RTRIM(PerPost) <= RTRIM(CurYr) + RTRIM(CurPer)) 
                    AND DocType = 'PP' THEN CustomerAmt ELSE 0 END)
  FROM vp_08400ARReleaseDocs
GROUP BY UserAddress, CustID, CpnyID
GO
