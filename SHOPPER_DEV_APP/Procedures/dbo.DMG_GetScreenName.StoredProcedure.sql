USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_GetScreenName]    Script Date: 12/21/2015 14:34:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_GetScreenName]
	@parm1 varchar (7)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	Select	Name
	from 	vs_Screen
	where 	Number Like @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
