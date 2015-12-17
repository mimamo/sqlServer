USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXRef_Rec]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ItemXRef_Rec]

	@AlternateID	varchar(30),
	@AltIDType	varchar(1),
	@EntityID	varchar(15),
	@InvtID	varchar(30)
AS
	Select	*
	From	ItemXRef
	Where	AlternateID = @AlternateID
	And	AltIDType = @AltIDType
	And	EntityID = @EntityID
	And	InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
