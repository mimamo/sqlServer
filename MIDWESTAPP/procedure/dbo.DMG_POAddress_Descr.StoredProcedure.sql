USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POAddress_Descr]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POAddress_Descr]
	@VendID 	varchar(10),
	@OrdFromID	varchar(10)
AS
	select	Descr
	from	POAddress
	where	VendID = @VendID
	and	OrdFromID = @OrdFromID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
