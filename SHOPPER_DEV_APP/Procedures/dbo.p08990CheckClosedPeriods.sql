USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckClosedPeriods]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990CheckClosedPeriods] AS

SELECT d.*
  FROM ARDOC d LEFT JOIN vp_08400_AllAdjD v
                 ON d.custid = v.custid
                AND d.refnbr = v.adjdrefnbr
                AND d.doctype = v.adjddoctype
 WHERE d.PerClosed <>
       CASE WHEN d.PerPost > ISNULL(v.PerClosed,' ')
              THEN d.PerPost
            ELSE
              v.PerClosed
       END
   AND d.PerClosed <> ' '
   AND d.DocType in ('IN','DM','FI','NC','SC','RP','NS','CS', 'AD')
GO
