USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTran_RcptNbr]    Script Date: 12/21/2015 15:49:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTran_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTran_RcptNbr] @parm1 varchar ( 10) As
Delete from POTran Where RcptNbr = @parm1
GO
