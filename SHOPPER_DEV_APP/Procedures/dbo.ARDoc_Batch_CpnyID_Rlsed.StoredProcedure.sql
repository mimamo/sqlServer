USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Batch_CpnyID_Rlsed]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_Batch_CpnyID_Rlsed] @parm1 varchar ( 15), @parm2 varchar ( 10)
As
SELECT * FROM ARDoc, Currncy, Batch
 WHERE ARDoc.CuryId = Currncy.CuryId AND
       batch.batnbr = ardoc.batnbr AND
       (batch.module = 'AR' OR (ARDoc.Crtd_prog = 'BIREG' AND Batch.Module = 'BI')) AND
       ARDoc.CustId = @parm1 AND
       ARDoc.CpnyID = @parm2 AND
       ARDoc.Rlsed = 1
 ORDER BY CustId, DocDate DESC
GO
