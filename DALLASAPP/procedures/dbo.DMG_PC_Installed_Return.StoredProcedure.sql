USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PC_Installed_Return]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PC_Installed_Return]
AS
	if (
	select	count(*)
	from	PCSetup (NOLOCK)
	where	S4Future3 = 'S'
	) = 0
		return 0
	else
		return 1
GO
