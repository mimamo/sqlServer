USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WC_Installed_Return]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_WC_Installed_Return]
AS
	if (
	select	count(*)
	from	WCSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
