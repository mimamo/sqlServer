USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Component_Item]    Script Date: 12/21/2015 15:42:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Component_Item]
	@KitID		varchar(30),
	@CmpnentID	varchar(30)
AS
	select	*
	from	Component
     	where	KitId = @KitID
	and	CmpnentID = @CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
