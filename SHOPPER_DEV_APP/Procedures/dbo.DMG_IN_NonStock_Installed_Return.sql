USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IN_NonStock_Installed_Return]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_IN_NonStock_Installed_Return]
AS
	if (
	select	count(*)
	from	INSetup (NOLOCK)
	where	Init = 0
	) = 0
		return 0
	else
		return 1
GO
