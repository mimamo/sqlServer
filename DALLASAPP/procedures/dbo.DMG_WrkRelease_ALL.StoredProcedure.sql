USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WrkRelease_ALL]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[DMG_WrkRelease_ALL]
	@BatNbr		Char(10),
	@Module		Char(2),
	@UserAddress	Char(21)
AS
	SELECT * FROM WrkRelease
		WHERE WrkRelease.BatNbr = @BatNbr
			AND WrkRelease.Module Like @Module
			AND WrkRelease.UserAddress Like @UserAddress

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
