USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_CLOR]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_CLOR]

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
		@Auto,		'',		'',		'ADG_Close_Order',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Close Order',
		'CLOR',		'9999',		'4010000',	@NotesOn,
		'',		@RptProg,	'9999',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
