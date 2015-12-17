USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SO40400_CrRel_Wrk_Not_AutoAdvanced]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SO40400_CrRel_Wrk_Not_AutoAdvanced]
as
	select	*
	from	SO40400_CrRel_Wrk
	where	AutoAdvanceDone = 0

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
