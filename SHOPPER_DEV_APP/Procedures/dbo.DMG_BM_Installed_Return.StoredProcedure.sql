USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BM_Installed_Return]    Script Date: 12/21/2015 14:34:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_BM_Installed_Return]
AS
	if (
	select	count(*)
	from	BMSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
