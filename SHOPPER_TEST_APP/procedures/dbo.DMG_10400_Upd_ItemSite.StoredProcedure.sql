USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10400_Upd_ItemSite]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_10400_Upd_ItemSite]
	/*Begin Process Parameter Group*/
	@BatNbr			Varchar(10),
	@ProcessName		Varchar(8),
	@UserName		Varchar(10),
	@UserAddress		Varchar(21),
	@BaseDecPl		SmallInt,
	@BMIDecPl		SmallInt,
	@DecPlQty		SmallInt,
	@DecPlPrcCst		SmallInt,
	@NegQty			Bit,
	@ValMthd		Char(1),
	@MatlOvhCalc		Char(1),
	/*End Process Parameter Group*/
	/*Begin Primary Key Parameter Group*/
	@InvtID			Varchar(30),
	@SiteID			Varchar(10),
	@CpnyID			Varchar(10),
	/*End Primary Key Parameter Group*/
	/*Begin Update Values Parameter Group*/
	@BMILastCost		Float,
	@LastCost		Float,
	@QtyInTransit		Float,
	@QtyNotAvail		Float,
	@QtyOnBO		Float,
	@QtyOnDP		Float,
	@QtyOnHand		Float,
	@QtyOnKitAssyOrders	Float,
	@QtyOnPO		Float,
	@QtyOnTransferOrders	Float,
	@AllocBucket		Smallint,
	@BMITotCost		Float,
	@TotCost		Float
	/*End Update Values Parameter Group*/
As
	Set NoCount On
	/*
	Parameters are grouped together functionally. This procedure will update
	costs and quantities for the record matching the primary key fields passed
	as parameters.

	Automatically determines if record to be updated exists.

	Returns:	@True = 1	The procedure executed properly.
			@False = 0	An error occurred.
	*/

	Declare	@True		Bit,
		@False		Bit
	Select	@True 		= 1,
		@False 		= 0

	Declare	@SQLErrNbr	SmallInt,
		@ReturnStatus	Bit
	Select	@SQLErrNbr	= 0,
		@ReturnStatus	= @True

	Declare	@QtyOnWO	Float,
		@CostOnWO	Float,
		@BMICostOnWO	Float

	Select	@QtyOnWO = 0, @CostOnWO = 0, @BMICostOnWO = 0

	Exec	SCM_10400_ItemCost_WO @InvtID, @SiteID, @BaseDecPl, @BMIDecPl, @DecPlPrcCst,
			@DecPlQty, @QtyOnWO Output, @CostOnWO OutPut, @BMICostOnWO OutPut

	/*
	Item Site field variables.
	*/
	Declare	@IS_AvgCost		DEC(25,9),
		@IS_BMIAvgCost		DEC(25,9),
		@IS_BMICostAvail	DEC(28,3),
		@IS_BMIDirStdCst	DEC(25,9),
		@IS_BMILastCost		DEC(25,9),
		@IS_BMIStdCost		DEC(25,9),
		@IS_BMITotCost		DEC(28,3),
		@IS_DirStdCost		DEC(25,9),
		@IS_LastCost		DEC(25,9),
		@IS_StdCost		DEC(25,9),
		@IS_QtyAvail		DEC(25,9),
		@IS_CostAvail		DEC(28,3),
		@IS_QtyOnHand		DEC(25,9),
		@IS_TotCost		DEC(28,3)
	Select	@IS_AvgCost		= 0,
		@IS_BMIAvgCost		= 0,
		@IS_BMICostAvail	= 0,
		@IS_BMIDirStdCst	= 0,
		@IS_BMILastCost		= 0,
		@IS_BMIStdCost		= 0,
		@IS_BMITotCost		= 0,
		@IS_DirStdCost		= 0,
		@IS_LastCost		= 0,
		@IS_StdCost		= 0,
		@IS_QtyAvail		= 0,
		@IS_CostAvail		= 0,
		@IS_QtyOnHand		= 0,
		@IS_TotCost		= 0

	Execute	@ReturnStatus = DMG_Insert_ItemSite 	@InvtID, @SiteID, @CpnyID, @ProcessName, @UserName
	Select @SQLErrNbr = @@Error
	If @SQLErrNbr <> 0
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_ItemSite', @SQLErrNbr, 2,
				@InvtID, @SiteID)
		Goto Abort
	End
	If @ReturnStatus = @False
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_ItemSite', @SQLErrNbr, 2,
				@InvtID, @SiteID)
		Goto Abort
	End
	/*
	Retrieves the current per unit costs and quantities on hand into variables.
	*/
	Select	@IS_AvgCost	= Round(CONVERT(DEC(25,9),AvgCost), @DecPlPrcCst),
		@IS_BMIAvgCost	= Round(CONVERT(DEC(25,9),BMIAvgCost), @DecPlPrcCst),
		@IS_BMIDirStdCst = Round(CONVERT(DEC(25,9),BMIDirStdCst), @DecPlPrcCst),
		@IS_BMILastCost	= Round(CONVERT(DEC(25,9),BMILastCost), @DecPlPrcCst),
		@IS_BMIStdCost	= Round(CONVERT(DEC(25,9),BMIStdCost), @DecPlPrcCst),
		@IS_BMITotCost	= Case When @ValMthd = 'U' Then 0 Else Round(CONVERT(DEC(28,3),BMITotCost), @BMIDecPl) End,
		@IS_LastCost	= Round(CONVERT(DEC(25,9),LastCost), @DecPlPrcCst),
		@IS_DirStdCost	= Round(CONVERT(DEC(25,9),DirStdCst), @DecPlPrcCst),
		@IS_StdCost	= Round(CONVERT(DEC(25,9),StdCost), @DecPlPrcCst),
		@IS_QtyOnHand	= Round(CONVERT(DEC(25,9),QtyOnHand), @DecPlQty),
		@IS_TotCost	= Case When @ValMthd = 'U' Then 0 Else Round(CONVERT(DEC(28,3),TotCost), @BaseDecPl) End
		From	ItemSite
		Where	InvtID = @InvtID
			And SiteID = @SiteID

	/*
	Negative Check

	If the Inventory Setup settings does not allow negative quantities, check to keep
	the costing layer from having either a negative quantity or a negative cost.
	*/
	If (@NegQty = @False
		Or (Select RTrim(LotSerTrack) From Inventory Where InvtID = @InvtID) = 'SI')
		And (@IS_QtyOnHand + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
		Or (@IS_TotCost + Round(CONVERT(DEC(28,3),@TotCost), @BaseDecPl) < 0 And @IS_QtyOnHand + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) > 0
		And @ValMthd <> 'U'))
	Begin
		/*
		Solomon Error Message
		*/
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, MsgNbr,
				ParmCnt, Parm00, Parm01)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_ItemSite', @SQLErrNbr, 16080,
				2, @InvtID, @SiteID)
		Goto Abort
	End

	/*
	Check Costing Rules

	Costing Rule # 1
		Cost and quantity must have the same sign.

	If the quantity is positive the layer total cost must be positive.  If the quantity
	is negative the layer total cost must be negative.
	*/
	If	@ValMthd <> 'U'
		And ((@IS_QtyOnHand + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
			And @IS_TotCost + Round(CONVERT(DEC(28,3),@TotCost), @BaseDecPl) > 0)
		Or (@IS_QtyOnHand + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) > 0
			And @IS_TotCost + Round(CONVERT(DEC(28,3),@TotCost), @BaseDecPl) < 0))
	Begin		/*
		Solomon Error Message
		*/
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, MsgNbr,
				ParmCnt, Parm00, Parm01)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_ItemSite', @SQLErrNbr, 16086,
				2, @InvtID, @SiteID)
		Goto Abort
	End

	/*
	Update the layer quantity and total layer cost for the costing layer
	and recalculate the per unit cost.
	*/
	Update	ItemSite
		Set	QtyInTransit = Round(CONVERT(DEC(25,9),QtyInTransit), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyInTransit), @DecPlQty),
			QtyNotAvail = Round(CONVERT(DEC(25,9),QtyNotAvail), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyNotAvail), @DecPlQty),
			QtyOnBO = Round(CONVERT(DEC(25,9),QtyOnBO), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnBO), @DecPlQty),
			QtyOnDP = Round(CONVERT(DEC(25,9),QtyOnDP), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnDP), @DecPlQty),
			QtyOnHand = Round(CONVERT(DEC(25,9),QtyOnHand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty),
			QtyOnKitAssyOrders = Round(CONVERT(DEC(25,9),QtyOnKitAssyOrders), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnKitAssyOrders), @DecPlQty),
			QtyOnPO = Round(CONVERT(DEC(25,9),QtyOnPO), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnPO), @DecPlQty),
			QtyOnTransferOrders = Round(CONVERT(DEC(25,9),QtyOnTransferOrders), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnTransferOrders), @DecPlQty),
			QtyAllocBM = Case @AllocBucket When 1 Then Round(CONVERT(DEC(25,9),QtyAllocBM), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyAllocBM End,
			QtyAllocIN = Case @AllocBucket When 2 Then Round(CONVERT(DEC(25,9),QtyAllocIN), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyAllocIN End,
			QtyAllocPORet = Case @AllocBucket When 3 Then Round(CONVERT(DEC(25,9),QtyAllocPORet), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyAllocPORet End,
			QtyAllocSD = Case @AllocBucket When 4 Then Round(CONVERT(DEC(25,9),QtyAllocSD), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyAllocSD End,
			QtyShipNotInv = Case @AllocBucket When 6 Then Round(CONVERT(DEC(25,9),QtyShipNotInv), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyShipNotInv End,
			QtyWORlsedDemand = Case @AllocBucket When 8 Then Round(CONVERT(DEC(25,9),QtyWORlsedDemand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) Else QtyWORlsedDemand End,
			TotCost = Case When @ValMthd = 'U' Then TotCost Else Round(CONVERT(DEC(28,3),TotCost), @BaseDecPl) + Round(CONVERT(DEC(28,3),@TotCost), @BaseDecPl) End,
			BMITotCost = Case When @ValMthd = 'U' Then BMITotCost Else Round(CONVERT(DEC(28,3),BMITotCost), @BMIDecPl) + Round(CONVERT(DEC(28,3),@BMITotCost), @BMIDecPl) End,
			LUpd_DateTime = Convert(SmallDateTime, GetDate()),
			LUpd_Prog = @ProcessName,
			LUpd_User = @UserName
		Where	InvtID = @InvtID
			And SiteID = @SiteID

	Select @SQLErrNbr = @@Error
	If @SQLErrNbr <> 0
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_ItemSite', @SQLErrNbr, 2,
				@InvtID, @SiteID)
		Goto Abort
	End
	/*
	Recalculate Average Cost (AVGCOST).
	*/

	Select	@IS_QtyAvail = Round(CONVERT(DEC(25,9),QtyOnHand), @DecPlQty) - Round(CONVERT(DEC(25,9),@QtyOnWO), @DecPlQty),
		@IS_CostAvail = Round(CONVERT(DEC(28,3),TotCost), @BaseDecPl) - Round(CONVERT(DEC(28,3),@CostOnWO), @BaseDecPl),
		@IS_BMICostAvail = Round(CONVERT(DEC(28,3),BMITotcost), @BMIDecPl) - Round(CONVERT(DEC(28,3),@BMICostOnWO), @BMIDecPl)
		From	ItemSite
		Where	ItemSite.InvtID = @InvtID
			And ItemSite.SiteID = @SiteID

	Update	ItemSite
		Set	ItemSite.BMIAvgCost = Abs(Case When @IS_QtyAvail <> 0 Then Round(@IS_BMICostAvail / @IS_QtyAvail, @DecPlPrcCst) Else @IS_BMIAvgCost End),
			ItemSite.BMILastCost = Case When Round(CONVERT(DEC(25,9),@BMILastCost), @DecPlPrcCst) = 0 Then ItemSite.BMILastCost Else Abs(Round(CONVERT(DEC(25,9),@BMILastCost), @DecPlPrcCst)) End,
			ItemSite.AvgCost = Abs(Case When @IS_QtyAvail <> 0 Then Round(@IS_CostAvail / @IS_QtyAvail, @DecPlPrcCst) Else @IS_AvgCost End),
			ItemSite.LastCost = Case When Round(CONVERT(DEC(25,9),@LastCost), @DecPlPrcCst) = 0 Then ItemSite.LastCost Else Abs(Round(CONVERT(DEC(25,9),@LastCost), @DecPlPrcCst)) End,
			ItemSite.QtyAllocBM = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyAllocBM), @DecPlQty) < 0 Then 0 Else ItemSite.QtyAllocBM End,
			ItemSite.QtyAllocIN = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyAllocIN), @DecPlQty) < 0 Then 0 Else ItemSite.QtyAllocIN End,
			ItemSite.QtyAllocPORet = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyAllocPORet), @DecPlQty) < 0 Then 0 Else ItemSite.QtyAllocPORet End,
			ItemSite.QtyAllocSD = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyAllocSD), @DecPlQty) < 0 Then 0 Else ItemSite.QtyAllocSD End,
			ItemSite.QtyShipNotInv = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyShipNotInv), @DecPlQty) < 0 Then 0 Else ItemSite.QtyShipNotInv End,
			ItemSite.QtyWORlsedDemand = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyWORlsedDemand), @DecPlQty) < 0 Then 0 Else ItemSite.QtyWORlsedDemand End,
			ItemSite.LUpd_DateTime = Convert(SmallDateTime, GetDate()),
			ItemSite.LUpd_Prog = @ProcessName,
			ItemSite.LUpd_User = @UserName,
			/* Costing Rule # 2  If Quantity On Hand equals zero, cost should equal zero. */
			ItemSite.TotCost = Case When Round(CONVERT(DEC(25,9),ItemSite.QtyOnHand), @DecPlQty) = 0 Then 0 Else ItemSite.TotCost End
		From	ItemSite
		Where	ItemSite.InvtID = @InvtID
			And ItemSite.SiteID = @SiteID

Goto Finish

Abort:
	Return @False

Finish:
	Return @True
GO
