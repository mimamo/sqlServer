USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_EDI_Installed_Return]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_EDI_Installed_Return]
AS
	if (
	select	count(*)
	from	EDSetup (NOLOCK)
	) = 0
		return 0
	else
		return 1
GO
