USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_ENTS]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_ENTS]

	@Auto 		smallint,
	@CpnyID		varchar(10),
	@CreditChk	smallint,
	@CreditChkProg	smallint,
	@NotesOn	smallint,
	@RptProg	smallint,
	@SkipTo		varchar(4),
	@SOTypeID	varchar(4),
	@Status		varchar(1)

as
	exec DMG_SOStep_Insert
		@Auto,		'',		'',		'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Enter Shipper',
		'ENTS',		'0100',		'4011000',	@NotesOn,
		'',		@RptProg,	'0300',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
