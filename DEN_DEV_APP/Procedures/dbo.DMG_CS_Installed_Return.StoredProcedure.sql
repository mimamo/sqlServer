USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CS_Installed_Return]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_CS_Installed_Return]
AS
	if (
	select	count(*)
	from	CSSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
