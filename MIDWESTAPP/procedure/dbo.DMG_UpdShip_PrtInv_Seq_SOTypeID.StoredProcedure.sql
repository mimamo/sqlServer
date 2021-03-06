USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdShip_PrtInv_Seq_SOTypeID]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_UpdShip_PrtInv_Seq_SOTypeID]

	@CpnyID			varchar(10),
	@SOTypeID		varchar(4)
as

Declare @PrintInvoiceSeq	varchar(4)
Declare @UpdateShipSeq		varchar(4)
Declare @ReturnValue		bit

select @ReturnValue = 0

	select  @UpdateShipSeq = ''
	select 	@PrintInvoiceSeq = ''

	select 	@UpdateShipSeq = Seq
	from 	sostep
	where 	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
	  and   EventType = 'USHP'

	select 	@PrintInvoiceSeq = Seq
	from 	sostep
	where 	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
	  and   EventType = 'PINV'
		If @UpdateShipSeq < @PrintInvoiceSeq and @UpdateShipSeq > 0 and @PrintInvoiceSeq > 0
		select convert(smallint, 1)
	else
		select convert(smallint, 0)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
