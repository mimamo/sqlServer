USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_PPIK]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_PPIK]

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
		@Auto,		'',		'4063000',	'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Print Picking List',
		'PPIK',		'',		'4063000',	@NotesOn,
		'',		@RptProg,	'0310',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
