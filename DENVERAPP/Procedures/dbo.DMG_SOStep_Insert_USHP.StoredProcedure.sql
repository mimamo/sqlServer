USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_USHP]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_USHP]

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
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Update Shipper',
		'USHP',		'0200',		'4043000',	@NotesOn,
		'',		@RptProg,	'0810',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
