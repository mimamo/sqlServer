USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SO40400_CrRel_Wrk_Not_AutoAdvanced]    Script Date: 12/21/2015 16:13:08 ******/
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
