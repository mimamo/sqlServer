USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ClearPOPrtQueue_RI]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ClearPOPrtQueue_RI]
	@ri_id		smallint
as
	delete from poprintqueue where ri_id = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
