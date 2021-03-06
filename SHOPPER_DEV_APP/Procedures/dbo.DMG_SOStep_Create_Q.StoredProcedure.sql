USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOStep_Create_Q]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOStep_Create_Q]

	@CpnyID varchar(10)
as
	declare @SOTypeID varchar(4)

	select @SOTypeID = 'Q'

	exec DMG_SOStep_Insert_CLOR 0, @CpnyID, 0, 0, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_ENT  0, @CpnyID, 0, 1, 0, 0, '', @SOTypeID, 'R'
	exec DMG_SOStep_Insert_PRQ  1, @CpnyID, 0, 1, 1, 1, '', @SOTypeID, 'O'
	exec DMG_SOStep_Insert_REL  1, @CpnyID, 0, 1, 0, 0, '', @SOTypeID, 'R'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
