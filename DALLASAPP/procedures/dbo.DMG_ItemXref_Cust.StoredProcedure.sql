USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXref_Cust]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ItemXref_Cust]

	@AlternateID	varchar(30),
	@EntityID	varchar(15)
AS
	Select	*
	From	ItemXref
	Where	AlternateID = @AlternateID
	And	(AltIDType = 'C' And EntityID = @EntityID)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
