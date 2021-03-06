USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[MIDocFetch]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MIDocFetch] @parm1 VARCHAR(21) AS

SELECT d.*
  FROM WrkRelease w JOIN ArDoc d
                      ON w.batnbr = d.batnbr
WHERE w.UserAddress = @Parm1 AND w.Module = 'AR'
  AND d.rlsed = 1
  AND d.doctype = 'IN'
  AND EXISTS
        (SELECT 'Terms Exist'
           FROM DocTerms dt
          WHERE dt.DocType = 'IN'
            AND dt.RefNbr = d.RefNbr)
GO
