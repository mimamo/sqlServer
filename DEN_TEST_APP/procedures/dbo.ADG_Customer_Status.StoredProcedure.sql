USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Customer_Status]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Customer_Status]
	@custid	varchar(15)
as
	select	status
	from	customer
	where	custid like @custid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
