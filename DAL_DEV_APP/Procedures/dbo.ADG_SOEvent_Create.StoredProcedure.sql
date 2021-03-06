USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOEvent_Create]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOEvent_Create]
	@cpnyid		varchar(10),
	@descr		varchar(30),
	@eventtype	varchar(4),
	@ordnbr		varchar(15),
	@progid		varchar(8),
	@shipperid	varchar(15),
	@userid		varchar(10)
as

        declare @invcnbr varchar(15)
        select @invcnbr = space(15)

        if (@cpnyid != '' and @ordnbr != '')
            select @invcnbr = isnull(invcnbr, space(15)) from soheader where cpnyid = @cpnyid and ordnbr = @ordnbr

        if (@cpnyid != '' and @shipperid != '')
            select @invcnbr = isnull(invcnbr, space(15)) from soshipheader where cpnyid = @cpnyid and shipperid = @ShipperId

	insert SOEvent	(
			CpnyID, Crtd_DateTime, Crtd_Prog, Crtd_User,Descr, EventDate, EventTime,
			EventType, invcnbr,LUpd_DateTime, LUpd_Prog, LUpd_User,
			NoteID, OrdNbr, ProgID,
			S4Future01,S4Future02,S4Future03,S4Future04,S4Future05,S4Future06,
			S4Future07,S4Future08,S4Future09,S4Future10,S4Future11,S4Future12,
			ShipperID,
			User1, User10, User2, User3, User4, User5,
			User6, User7, User8, User9, UserID
			)

	values		(
			@cpnyid, getdate(), '', '',@descr, getdate(), getdate(),
			@eventtype, @invcnbr, getdate(), '', '',0, @ordnbr, @progid,
			'', '', 0, 0, 0, 0,
			'', '', 0, 0, '', '',
			@shipperid,
			'', '', '', '', '', 0,
			0, '', '', '', @userid

			)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
