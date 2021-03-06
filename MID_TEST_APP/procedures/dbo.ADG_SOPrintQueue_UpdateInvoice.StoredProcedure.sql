USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintQueue_UpdateInvoice]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPrintQueue_UpdateInvoice]
	@CpnyID 	varchar(10),
	@RI_ID 		smallint,
	@ShipperID 	varchar(15),
	@InvcNbr 	varchar(15)

AS
	Declare @CurrentInvcNbr	varchar(15)
		-- Make sure that an Invoice number has not already been written in this field.
	select	@CurrentInvcNbr = InvcNbr
	from	SOPrintQueue
	Where	CpnyID = @CpnyID
	  and	RI_ID = @RI_ID
	  and	ShipperID = @ShipperID

	If RTrim(@CurrentInvcNbr) = ''
	begin
		update 	SOPrintQueue
		Set	InvcNbr = @InvcNbr
		Where	CpnyID = @CpnyID
		  and	RI_ID = @RI_ID
		  and	ShipperID = @ShipperID

		select  @InvcNbr
	end
	else
		select 	@CurrentInvcNbr
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
