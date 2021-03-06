USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Insert_CANA]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Insert_CANA]

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
		@Auto,		'',		'',		'ADG_X_CancelBackorder',
		@CpnyID,	@CreditChk,	@CreditChkProg,	'Cancel Backorder Quantities',
		'X',		'0105',		'4011000',	@NotesOn,
		'',		@RptProg,	'0305',		@SkipTo,
		@SOTypeID,	@Status
GO
