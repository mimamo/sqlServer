USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WrkRelease_ALL]    Script Date: 12/16/2015 15:55:18 ******/
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
