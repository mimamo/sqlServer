USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOAcctSubErr_Delete_RIID]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOAcctSubErr_Delete_RIID]
	@RI_ID 		smallint
AS
	Delete
	from	SOAcctSubErr
	where	RI_ID = @RI_ID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
