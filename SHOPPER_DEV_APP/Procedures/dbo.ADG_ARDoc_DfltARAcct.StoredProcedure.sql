USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARDoc_DfltARAcct]    Script Date: 12/21/2015 14:34:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARDoc_DfltARAcct]
as
	select	ARAcct,
		ARSub

	from	ARSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
