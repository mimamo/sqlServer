USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SO40400_CrRel_Wrk_Del_AutoAdvanced]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SO40400_CrRel_Wrk_Del_AutoAdvanced]
as
	delete
	from	SO40400_CrRel_Wrk
	where	AutoAdvanceDone = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
