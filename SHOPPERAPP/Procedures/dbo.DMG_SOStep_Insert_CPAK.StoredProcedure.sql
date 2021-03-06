USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_CPAK]    Script Date: 12/21/2015 16:13:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_CPAK]

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
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Confirm Packing',
		'CPAK',		'0450',		'4011000',	@NotesOn,
		'',		@RptProg,	'0620',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
