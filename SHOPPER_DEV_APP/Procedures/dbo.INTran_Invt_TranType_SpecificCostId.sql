USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invt_TranType_SpecificCostId]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_Invt_TranType_SpecificCostId]
	@parm1 varchar ( 30),
	@parm2 varchar ( 25),
	@parm3 varchar ( 2)
AS
SELECT Count(*) from INTran
	WHERE Invtid = @parm1
	AND SpecificCostID = @parm2
	AND TranType = @parm3
	GROUP BY InvtID,TranType,SpecificCostID
GO
