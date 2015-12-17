USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_DocClass_RefNbr_CpnyID2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_DocClass_RefNbr_CpnyID2] @parm1 varchar ( 10), @parm2 varchar ( 1), @parm3 varchar ( 10) as
    SELECT *
      FROM ARDoc
     WHERE CpnyId = @parm1 AND
           (DocClass = @parm2 OR
              (DocClass = 'P' AND doctype IN ('RP','NS'))) AND
           refnbr LIKE @parm3  AND doctype <> 'VT'
     order by CpnyId, DocClass, RefNbr
GO
