USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSite_InvtID_Delete]    Script Date: 12/21/2015 16:13:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ItemSite_InvtID_Delete]
	@InvtID varchar(30)
AS

	DELETE FROM ItemSite WHERE InvtID = @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
