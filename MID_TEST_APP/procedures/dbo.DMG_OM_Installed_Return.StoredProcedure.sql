USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OM_Installed_Return]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OM_Installed_Return]
AS
	if (
	select	count(*)
	from	SOSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
