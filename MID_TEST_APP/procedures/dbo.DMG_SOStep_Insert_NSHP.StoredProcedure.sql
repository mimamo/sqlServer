USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_NSHP]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_NSHP]

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
		@Auto,		'',		'4065400',	'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Print Advance Shipping Notice',
		'NSHP',		'',		'4065400',	@NotesOn,
		'',		@RptProg,	'0730',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
