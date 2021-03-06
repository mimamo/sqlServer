USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10400_Upd_Location]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_10400_Upd_Location]
	/*Begin Process Parameter Group*/
	@BatNbr			Varchar(10),
	@ProcessName		Varchar(8),
	@UserName		Varchar(10),
	@UserAddress		Varchar(21),
	@DecPlQty		SmallInt,
	@DecPlPrcCst		SmallInt,
	@NegQty			Bit,
	/*End Process Parameter Group*/
	/*Begin Primary Key Parameter Group*/
	@InvtID			Varchar(30),
	@SiteID			Varchar(10),
	@WhseLoc		Char(10),
	/*End Primary Key Parameter Group*/
	/*Begin Update Values Parameter Group*/
	@QtyOnHand		Float,
	@AllocBucket		SmallInt
	/*End Update Values Parameter Group*/
As
	Set NoCount On
	/*
	Parameters are grouped together functionally.

	This procedure will update the quantity on hand (QTYONHAND) and quantity shipped
	not invoiced for the record matching the primary key fields passed as parameters.
	The primary key fields in the Location table define a specific warehouse storage
	location.

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

	Execute	@ReturnStatus = DMG_Insert_Location	@InvtID, @SiteID, @Whseloc, @ProcessName, @UserName
	Select @SQLErrNbr = @@Error
	If @SQLErrNbr <> 0
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01, Parm02)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_Location', @SQLErrNbr, 3,
				@InvtID, @SiteID, @Whseloc)
		Goto Abort
	End
	If @ReturnStatus = @False
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01, Parm02)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_Location', @SQLErrNbr, 3,
				@InvtID, @SiteID, @Whseloc)
		Goto Abort
	End
	/*
	Quantity on hand will be passed in positive and negative.  If quantity on hand
	is increasing, the system should not return an error message because a quantity
	can be received into the warehouse bin location that does not completely offset
	the negative on hand quantity.  Also, the system should not fail if the quantity
	on hand value in the quantity on hand (@QTYONHAND) parameter is equal to zero. A
	zero quantity on hand (@QTYONHAND) parameter may occur when when only the quantity
	shipped not invoice (QTYSHIPNOTINV) is to be updated.
	*/
	If @NegQty = @False And Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
	Begin
		If (	Select	Round(CONVERT(DEC(25,9),QtyOnHand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
				From	Location
				Where	InvtID = @InvtID
					And SiteID = @SiteID
					And WhseLoc = @WhseLoc) < 0
		Begin
		/*
		Solomon Error Message
		*/
			Insert 	Into IN10400_RETURN
					(BatNbr, ComputerName, S4Future01, MsgNbr, ParmCnt,
					Parm00, Parm01, Parm02)
				Values
					(@BatNbr, @UserAddress, 'DMG_10400_Upd_Location', 16081, 3,
					@InvtID, @SiteID, @Whseloc)
			Goto Abort
		End
	End
	/*
	Update the warehouse location quantity on hand and the quantity shipped not invoiced.
	*/
	Update	Location
		Set	QtyOnHand = Round(CONVERT(DEC(25,9),QtyOnHand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty),
			QtyAllocBM =	Case	When @AllocBucket <> 1 Then QtyAllocBM Else
					Case	When Round(CONVERT(DEC(25,9),QtyAllocBM), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyAllocBM), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyAllocIN =	Case	When @AllocBucket <> 2 Then QtyAllocIN Else
					Case	When Round(CONVERT(DEC(25,9),QtyAllocIN), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyAllocIN), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyAllocPORet =	Case	When @AllocBucket <> 3 Then QtyAllocPORet Else
					Case	When Round(CONVERT(DEC(25,9),QtyAllocPORet), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyAllocPORet), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyAllocSD =	Case	When @AllocBucket <> 4 Then QtyAllocSD Else
					Case	When Round(CONVERT(DEC(25,9),QtyAllocSD), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyAllocSD), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyShipNotInv =	Case	When @AllocBucket <> 6 Then QtyShipNotInv Else
					Case	When Round(CONVERT(DEC(25,9),QtyShipNotInv), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyShipNotInv), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyWORlsedDemand =	Case	When @AllocBucket <> 8 Then QtyWORlsedDemand Else
					Case	When Round(CONVERT(DEC(25,9),QtyWORlsedDemand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty) < 0
							Then 0
						Else Round(CONVERT(DEC(25,9),QtyWORlsedDemand), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End End,
			QtyAvail =	Case	When @AllocBucket <> 0 Or Not Exists (Select * From LocTable Where LocTable.SiteId = Location.SiteId And LocTable.WhseLoc = Location.WhseLoc And LocTable.InclQtyAvail = 1)
						Then QtyAvail Else
						Round(CONVERT(DEC(25,9),QtyAvail), @DecPlQty) + Round(CONVERT(DEC(25,9),@QtyOnHand), @DecPlQty)
					End,
			LUpd_DateTime = Convert(SmallDateTime, GetDate()),
			LUpd_Prog = @ProcessName,
			LUpd_User = @UserName
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And WhseLoc = @WhseLoc

	Select @SQLErrNbr = @@Error
	If @SQLErrNbr <> 0
	Begin
		Insert 	Into IN10400_RETURN
				(BatNbr, ComputerName, S4Future01, SQLErrorNbr, ParmCnt,
				Parm00, Parm01, Parm02)
			Values
				(@BatNbr, @UserAddress, 'DMG_10400_Upd_Location', @SQLErrNbr, 3,
				@InvtID, @SiteID, @Whseloc)
		Goto Abort
	End

Goto Finish

Abort:
	Return @False

Finish:
	Return @True
GO
