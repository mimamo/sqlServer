USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Dup_InvoiceNumber]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_Dup_InvoiceNumber]

	@InvoiceNumber varchar(15),
	@OrdNbr varchar(15),
	@ShipperID varchar(15)
as

	declare @DupOrdNbr varchar(15)
	declare @DupShipperID varchar(15)

	select 	@DupOrdNbr = '', @DupShipperID = ''

	select	@DupOrdNbr = OrdNbr
	from	SOHeader
	where	InvcNbr = @InvoiceNumber
	and	OrdNbr <> @OrdNbr

	select	@DupShipperID = ShipperID
	from	SOShipHeader
	where	InvcNbr = @InvoiceNumber
	and	ShipperID <> @ShipperID

	select @DupOrdNbr, @DupShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
