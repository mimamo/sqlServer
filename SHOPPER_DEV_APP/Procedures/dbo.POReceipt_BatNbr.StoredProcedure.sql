USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_BatNbr]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_BatNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_BatNbr] @parm1 varchar ( 10) As
Select * From POReceipt
Where BatNbr = @parm1
        and Rlsed = 0
Order By Batnbr, RcptNbr
GO
