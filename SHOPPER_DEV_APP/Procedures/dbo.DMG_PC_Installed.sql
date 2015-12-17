USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PC_Installed]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PC_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	PCSetup (nolock)
	where	S4Future3 = 'S'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
