USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SkipTest_AlwaysAdvance]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SkipTest_AlwaysAdvance]
	@cpnyid		varchar(10),
	@ordnbr		varchar(15),
	@shipperid	varchar(15)
as
	select	'Status' = 'NEXT',
		'Descr' = substring('Auto-advance' + space(30),1,30)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
