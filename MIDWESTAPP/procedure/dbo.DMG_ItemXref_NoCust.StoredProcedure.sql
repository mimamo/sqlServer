USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXref_NoCust]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ItemXref_NoCust]

	@AlternateID	varchar(30)
AS
	Select	*
	From	ItemXref
	Where	AlternateID = @AlternateID
	And	AltIDType in ('G','S','M','K','U','E','I','D','P','B')

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
