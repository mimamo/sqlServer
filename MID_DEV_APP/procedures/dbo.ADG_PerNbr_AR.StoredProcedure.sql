USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PerNbr_AR]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_PerNbr_AR]
as
	select	CurrPerNbr
	from	ARSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
