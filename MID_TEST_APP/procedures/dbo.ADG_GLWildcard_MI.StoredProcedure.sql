USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_MI]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_MI]
	@MiscChrgID	varchar(10)
as
	select		MiscAcct,
			MiscSub
	from		MiscCharge (nolock)
	where		MiscChrgID = @MiscChrgID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
