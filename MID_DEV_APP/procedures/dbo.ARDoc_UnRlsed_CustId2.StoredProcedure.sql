USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId2]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_UnRlsed_CustId2    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_UnRlsed_CustId2] @parm1 varchar ( 15) as
        SELECT * FROM ARDoc, Batch WHERE Batch.Module = 'AR'
        AND ARDoc.ApplBatNbr = Batch.BatNbr
        AND (ARDoc.Rlsed = 0 OR Batch.Rlsed = 0)
        AND CustId = @parm1
        ORDER BY ARDoc.BatNbr
GO
