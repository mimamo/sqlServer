USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CM_Installed_Return]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_CM_Installed_Return]
AS
	if (
	select	count(*)
	from	CMSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
