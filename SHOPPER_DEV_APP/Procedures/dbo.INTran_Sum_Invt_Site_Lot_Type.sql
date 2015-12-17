USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Sum_Invt_Site_Lot_Type]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_Sum_Invt_Site_Lot_Type    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_Sum_Invt_Site_Lot_Type    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_Sum_Invt_Site_Lot_Type] @parm1 varchar ( 30), @parm2 varchar ( 10) as
Select Sum(Qty), Sum(TranAmt) from INTran
	where INTran.Invtid = @parm1
	and INTran.Siteid = @parm2
	and InSuffQty = 1
GO
