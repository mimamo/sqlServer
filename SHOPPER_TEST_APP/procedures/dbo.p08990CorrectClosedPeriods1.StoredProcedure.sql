USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CorrectClosedPeriods1]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990CorrectClosedPeriods1] AS

UPDATE d
   SET d.Perclosed =
       CASE WHEN d.PerPost > ISNULL(v.PerClosed,' ')
              THEN d.PerPost
            ELSE
              v.PerClosed
       END
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
   AND d.DocType in ('PA','PP','CM','SB', 'RA')
GO
