USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_AINV]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_AINV]

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
		@Auto,		'',		'6041000',		'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Auto Advance to Invoice',
		'AAI',		'0000',		'6041000',	@NotesOn,
		'',		@RptProg,	'0235',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
