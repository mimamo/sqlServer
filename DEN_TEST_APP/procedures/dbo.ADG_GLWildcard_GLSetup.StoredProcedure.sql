USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLWildcard_GLSetup]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GLWildcard_GLSetup]
as
	select	ValidateAcctSub,
		ValidateAtPosting
	from	GLSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
