USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_POReceipt]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_POReceipt    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[Delete_POReceipt] @parm1 varchar ( 6) as
    Delete from POReceipt where
        (POReceipt.PerClosed <= @parm1 and POReceipt.PerClosed <> '')
GO
