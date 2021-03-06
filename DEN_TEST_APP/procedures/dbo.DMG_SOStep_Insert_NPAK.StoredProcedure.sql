USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_NPAK]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_NPAK]

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
		@Auto,		'',		'4065300',	'',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Print Packing Notice',
		'NPAK',		'',		'4065300',	1,
		'',		1,		'0630',		@SkipTo,
		@SOTypeID,	@Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
