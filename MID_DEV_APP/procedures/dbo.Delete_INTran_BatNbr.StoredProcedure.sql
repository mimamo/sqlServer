USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_INTran_BatNbr]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_INTran_BatNbr    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Delete_INTran_BatNbr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Delete_INTran_BatNbr] @parm1 varchar ( 10) as

    Exec Delete_LotSerT_BatNbr @Parm1

    Delete INTran from INTran where BatNbr = @parm1 and Rlsed = 0
GO
