USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_LotSerT_Validation]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_LotSerT_Validation]
	@BaseDecPl		SmallInt,
	@BMIDecPl		SmallInt,
	@DecPlPrcCst		SmallInt,
	@DecPlQty		SmallInt
As
/*	This procedure will look for missing LotSerT transactions.	*/
	Select	INTran.BatNbr, INTran.CpnyID, INTran.LineRef, INTran.SiteID, INTran.TranType
		From	INTran (NoLock) Inner Join Inventory (NoLock)
			On INTran.InvtID = Inventory.InvtID
			Left Join LotSerT (NoLock)
			On INTran.BatNbr = LotSerT.BatNbr
			And INTran.CpnyID = LotSerT.CpnyID
			And INTran.LineRef = LotSerT.INTranLineRef
			And INTran.SiteID = LotSerT.SiteID
			AND INTran.TranType = LOTSERT.TranType
		Where	(Inventory.SerAssign = 'R'
			Or (Inventory.SerAssign = 'U' And INTran.Qty * INTran.InvtMult < 0))
			And LotSerT.BatNbr Is Null
			And INTran.TranType Not In ('CG', 'CT')
			And INTran.Rlsed = 1
			And 1 = Case 	When INTran.Qty * INTran.InvtMult = 0 Then 0
					When INTran.S4Future09 In (1, 2) Then 0
					When RTrim(INTran.JrnlType) = 'OM' And RTrim(INTran.TranType) = 'DM' Then 0
					Else 1
				End
GO
