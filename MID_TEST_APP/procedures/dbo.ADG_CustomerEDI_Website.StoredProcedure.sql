USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustomerEDI_Website]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CustomerEDI_Website]
	@custid	varchar(15)
as
	select	WebSite
	from	customerEDI
	where	custid like @custid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
