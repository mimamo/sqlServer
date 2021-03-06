USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Invt_AdjustQtyShipNotInv]    Script Date: 12/21/2015 16:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Invt_AdjustQtyShipNotInv]
	@InvtID			varchar(30),
	@SiteID			varchar(10),
	@WhseLoc		varchar(10),
	@LotSerNbr		varchar(25),
	@SpecificCostID 	varchar(25),
	@QtyShip		float,
	@QtyAvailUpdateMode	smallint,	-- 0: CPS Off; 1: CPS On
	@QtyAvail		float,
	@ProgID			varchar(8),
	@UserID			varchar(10),
	@ErrorCode		smallint	output
as
	set nocount on

	declare	@QtyPrec	smallint
	declare @StkItem	smallint

	-- Exit if no quantity is being adjusted.
	if (@QtyShip = 0)
		return

	-- Fetch information from Inventory.
	select	@StkItem = StkItem
	from	Inventory (nolock)
	where	InvtID = @InvtID

	-- Exit if the item is not a stock item.
	if (@StkItem = 0)
		return

	-- Create the item records if they don't already exist.
	exec ADG_Invt_NewItem @InvtID, @SiteID, @WhseLoc, @LotSerNbr,
				@ProgID, @UserID, @ErrorCode output

	-- Exit if an error occurred while creating item records.
	if ((@@Error > 0) or (@ErrorCode <> 0))
		return

	-- Get the precision.
	select @QtyPrec = (select DecPlQty from INSetup (nolock))

	-- LotSerMst
	if (rtrim(@LotSerNbr) > '')
	begin
		update	LotSerMst
		set	QtyShipNotInv = round((QtyShipNotInv + @QtyShip), @QtyPrec),
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @ProgID,
			LUpd_User = @UserID

		where	InvtID = @InvtID
		  and	SiteID = @SiteID
		  and 	WhseLoc = @WhseLoc
		  and	LotSerNbr = @LotSerNbr
	end

	-- Location
	update	Location
	set	QtyShipNotInv = round((QtyShipNotInv + @QtyShip), @QtyPrec),
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @ProgID,
		LUpd_User = @UserID

	where	InvtID = @InvtID
	  and	SiteID = @SiteID
	  and 	WhseLoc = @WhseLoc

	-- ItemSite
	update	ItemSite
	set	LUpd_DateTime = GetDate(),
		LUpd_Prog = @ProgID,
		LUpd_User = @UserID,
		QtyShipNotInv = round((QtyShipNotInv + @QtyShip), @QtyPrec)

	where	InvtID = @InvtID
	  and	SiteID = @SiteID

	-- ItemCost
	update	ItemCost
	set	S4Future03 = round((S4Future03 + @QtyShip), @QtyPrec),
		LUpd_DateTime = GetDate(),
		LUpd_Prog = @ProgID,
		LUpd_User = @UserID
	where	InvtID = @InvtID
	  And	SiteID = @SiteID
	  And	SpecificCostID = @SpecificCostID
	  And   SpecificCostID <> ''

	-- Recalculate the quantity available
	if @QtyAvailUpdateMode = 0	-- CPS Off
		exec ADG_Invt_CalcQtyAvail @InvtID, @SiteID, @ProgID, @UserID

	else if @QtyAvailUpdateMode = 1	-- CPS On
		update	ItemSite
		set	QtyAvail = @QtyAvail
		where	InvtID = @InvtID
		and	SiteID = @SiteID
GO
