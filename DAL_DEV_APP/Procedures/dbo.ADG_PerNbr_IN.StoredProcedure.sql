USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PerNbr_IN]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_PerNbr_IN]
as
	select	CurrPerNbr
	from	INSetup (nolock)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
