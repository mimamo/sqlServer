USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_RcptNbr_dup]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_RcptNbr_dup    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_RcptNbr_dup] @parm1 varchar ( 10) As
Select * From POReceipt
Where POReceipt.RcptNbr = @parm1
Order By POReceipt.RcptNbr
GO
