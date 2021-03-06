USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckClosedPeriods1]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990CheckClosedPeriods1] AS

SELECT d.*
  FROM ARDOC d LEFT JOIN vp_08400_AllAdjG v
                 ON d.custid = v.custid
                AND d.refnbr = v.adjgrefnbr
                AND d.doctype = v.adjgdoctype
 WHERE d.PerClosed <>
       CASE WHEN d.PerPost > ISNULL(v.PerClosed,' ')
              THEN d.PerPost
            ELSE
              v.PerClosed
       END
   AND d.PerClosed <> ' '
   AND d.DocType in ('PA','PP','SB','CM', 'RA')
GO
