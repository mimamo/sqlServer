USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Get_Batch_Total]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Get_Batch_Total    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[Get_Batch_Total] @parm1 varchar ( 10) as
        SELECT CuryCrTot from Batch WHERE
        Batch.BatNbr = @parm1
	AND Batch.Module = 'AR'
GO
