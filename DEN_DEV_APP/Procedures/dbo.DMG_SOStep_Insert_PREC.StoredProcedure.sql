USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_PREC]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_PREC]

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
		@Auto,		'',		'4064500',		'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Print Receiver',
		'PREC',		'',		'4064500',	@NotesOn,
		'',		@RptProg,	'0314',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
