USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[OU_ShipperFrtToApply]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[OU_ShipperFrtToApply]
	@CpnyID			varchar(10),
	@OrdNbr			varchar(15),
	@ShipperID		varchar(15)
as
	set nocount on

	declare	@RcptCuryTotFreight	float,
		@RcptTotFreight		float,
		@ShipCuryTotPremFrtAmt	float,
		@ShipTotPremFrtAmt	float

	-- Get the freight on all PO receipts for the purchase order(s) for the sales order.
	select	@RcptCuryTotFreight = cast(isnull(sum(CuryExtCost), 0) as float),
		@RcptTotFreight = cast(isnull(sum(ExtCost), 0) as float)
	from	POTran
	where	PurchaseType = 'FR'
	and	PONbr in (	select	distinct PONbr
				from	POAlloc P
				where	CpnyID = @CpnyID
				and	SOOrdNbr = @OrdNbr)

	-- Get the premium freight on the shipper(s) for the sales order.
	select	@ShipCuryTotPremFrtAmt = sum(CuryPremFrtAmt),
		@ShipTotPremFrtAmt = sum (PremFrtAmt)
	from	SOShipHeader (nolock)
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	Cancelled = 0

	-- Calculate the freight to apply using the previous values and
	-- the currently applied premium freight from the sales order.
	select	@RcptCuryTotFreight - (@ShipCuryTotPremFrtAmt - S4Future04) CuryFreightToApply,
		@RcptTotFreight - (@ShipTotPremFrtAmt - S4Future05) FreightToApply
	from	SOHeader
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
GO
