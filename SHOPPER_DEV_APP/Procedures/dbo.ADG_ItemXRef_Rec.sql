USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemXRef_Rec]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ItemXRef_Rec]
	@AlternateID varchar(30),
	@AltIDType varchar(1),
	@EntityID varchar(15),
	@InvtID varchar(30)
AS
	SELECT *
	FROM ItemXRef
	WHERE AlternateID = @AlternateID AND
		AltIDType = @AltIDType AND
		EntityID = @EntityID AND
		InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
