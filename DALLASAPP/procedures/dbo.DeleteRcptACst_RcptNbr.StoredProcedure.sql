USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRcptACst_RcptNbr]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteRcptACst_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeleteRcptACst_RcptNbr] @parm1 varchar ( 10) As
Delete from RcptACst Where RcptNbr = @parm1
GO
