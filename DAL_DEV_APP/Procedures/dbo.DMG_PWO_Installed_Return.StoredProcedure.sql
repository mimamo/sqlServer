USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PWO_Installed_Return]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PWO_Installed_Return]
AS
	if (
	select	count(*)
	from	WOSetup (NOLOCK)
	where	Init = 'Y'
	and	substring(regoptions, 4, 1) = 'Y'       -- PWO switch
	) = 0
		return 0
	else
		return 1
GO
