USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invt_Site_Lot_Type_1]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_Invt_Site_Lot_Type_1    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_Invt_Site_Lot_Type_1    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_Invt_Site_Lot_Type_1] @parm1 varchar ( 30), @parm2 varchar ( 10) as
Select * from INTran
	where INTran.Invtid = @parm1
	and INTran.Siteid = @parm2
	and InSuffQty = 1
Order by InvtId, SiteId, Trandate,RefNbr
GO
