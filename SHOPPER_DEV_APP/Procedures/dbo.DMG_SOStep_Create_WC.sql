USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Create_WC]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Create_WC]

	@CpnyID varchar(10)
as
	declare @SOTypeID varchar(4)

	select @SOTypeID = 'WC'

	exec DMG_SOStep_Insert_CSHP 0, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_ENT  0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_ENTS 0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'D'
	exec DMG_SOStep_Insert_PINV 1, @CpnyID, 0, 0, 1, 1, '', @SOTypeID, 'O'
	exec DMG_SOStep_Insert_PPAK 0, @CpnyID, 1, 1, 1, 1, '', @SOTypeID, 'O'
	exec DMG_SOStep_Insert_PRC  1, @CpnyID, 0, 1, 1, 1, '', @SOTypeID, 'D'
	exec DMG_SOStep_Insert_REL  1, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_RUPD 1, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_USHP 0, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_X    0, @CpnyID, 1, 1, 0, 0, '', @SOTypeID, 'R'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
