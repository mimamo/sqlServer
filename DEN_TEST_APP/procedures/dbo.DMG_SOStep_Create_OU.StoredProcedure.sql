USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Create_OU]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Create_OU]

	@CpnyID varchar(10)
as
	declare @SOTypeID varchar(4)

	select @SOTypeID = 'OU'

	exec DMG_SOStep_Insert_AINV 1, @CpnyID, 0, 0, 0, 0, '0800', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_CSHP 0, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_ENT  0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_ENTS 0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'D'
	exec DMG_SOStep_Insert_GPOS 1, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_PINV 0, @CpnyID, 0, 0, 1, 1, '', @SOTypeID, 'O'
	exec DMG_SOStep_Insert_PPAK 0, @CpnyID, 1, 1, 0, 1, '', @SOTypeID, 'O'
	exec DMG_SOStep_Insert_PRC  1, @CpnyID, 0, 1, 1, 1, '', @SOTypeID, 'D'
	exec DMG_SOStep_Insert_REL  1, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_RUPD 1, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_USHP 0, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_X    0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
