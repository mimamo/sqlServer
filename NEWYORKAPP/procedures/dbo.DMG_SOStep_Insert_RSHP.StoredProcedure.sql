USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_RSHP]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_RSHP]

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
		@Auto,		'',		'',	'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Release for Shipping',
		'RSHP',		'0500',		'4011000',	@NotesOn,
		'',		@RptProg,	'0700',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
