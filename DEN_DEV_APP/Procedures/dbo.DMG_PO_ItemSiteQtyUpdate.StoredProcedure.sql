USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_ItemSiteQtyUpdate]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_ItemSiteQtyUpdate]
	@InvtID			varchar(30),
	@SiteID			varchar(10),
	@PurchaseType		varchar(2),
	@QtyDelta		decimal(25,9),
	@DecPlQty		smallint,
	@LastPurchaseDate	smalldatetime,
	@LastPurchasePrice	decimal(25,9),
	@LastVendor		varchar(15),
	@CPSOn			smallint,
	@ItemOrSiteChange	smallint,
	@ProgID			varchar(8),
	@UserID			varchar(10)
as
	declare	@Retval	smallint

	--Make sure the ItemSite record exists
	if (
	select	count(*)
	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	) = 0
		exec ADG_Invt_NewItem @InvtID, @SiteID, '', '', @ProgID, @UserID, @RetVal

	set nocount on

	--Update the ItemSite record
	if @PurchaseType = 'GD'
		update	ItemSite
		set	QtyOnDP = round(QtyOnDP + @QtyDelta, @DecPlQty),
			LastPurchaseDate = @LastPurchaseDate,
			LastVendor = @LastVendor
		where	InvtID = @InvtID
		and	SiteID = @SiteID
	else
		update	ItemSite
		set	QtyOnPO = round(QtyOnPO + @QtyDelta, @DecPlQty),
			LastPurchaseDate = @LastPurchaseDate,
			LastPurchasePrice = @LastPurchasePrice,
			LastVendor = @LastVendor
		where	InvtID = @InvtID
		and	SiteID = @SiteID

	set nocount off

	--If CPS off is in effect and the item or site has been changed
	--The calculation of quantity available only needs to be done in
	--the case noted above. Process Manager will calculate quantity
	--available in the CPS on case. The CPS off routines called during
	--the finish routines will calculate quantity available for the
	--current item and site, they don't deal with the calculation when
	--the item or site changes.
	if @CPSOn = 0 and @ItemOrSiteChange = 1

		--Recalculate the quantity available
		exec ADG_Invt_CalcQtyAvail @InvtID, @SiteID, @ProgID, @UserID
GO
