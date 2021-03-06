USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_UnRlsed_CustId    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_UnRlsed_CustId] @parm1 varchar ( 15) as
        SELECT * FROM ARDoc, Batch WHERE Batch.Module = 'AR'
        AND ARDoc.BatNbr = Batch.BatNbr
        AND (ARDoc.Rlsed = 0 OR Batch.Rlsed = 0)
        AND CustId = @parm1
        ORDER BY ARDoc.BatNbr
GO
