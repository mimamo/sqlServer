USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BlanketOrder_Check]    Script Date: 12/21/2015 14:34:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_BlanketOrder_Check]
	@CpnyID		varchar(10),	-- Company ID
	@OrdNbr		varchar(15)	-- Child Sales Order Number
as
	set nocount on

	-- get blanket order number and cancelled status for this order - only consider
	-- order type behaviors of Counter Sale, Sales Order, and Will Call, and RMA, and MO, and INVC
	select	H.BlktOrdNbr, H.Cancelled
	from	SOHeader H join SOType T on
		H.CpnyID = T.CpnyID and
		H.SOTypeID = T.SOTypeID
	where	H.CpnyID = @CpnyID
	and	H.OrdNbr = @OrdNbr
	and	T.Behavior in ('CS', 'SO', 'WC', 'RMA', 'MO', 'INVC')
GO
