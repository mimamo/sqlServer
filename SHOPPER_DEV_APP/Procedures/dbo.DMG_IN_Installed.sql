USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IN_Installed]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_IN_Installed]
AS
	select	case when count(*) > 0
		then 1
		else 0
		end
	from	INSetup (nolock)
	where	Init = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
