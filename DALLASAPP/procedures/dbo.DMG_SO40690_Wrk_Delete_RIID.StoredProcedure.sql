USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SO40690_Wrk_Delete_RIID]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SO40690_Wrk_Delete_RIID]
	@RI_ID 		smallint
AS
	Delete
	from	SO40690_Wrk
	where	RI_ID = @RI_ID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
