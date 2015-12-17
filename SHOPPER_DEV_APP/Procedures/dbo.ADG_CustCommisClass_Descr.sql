USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustCommisClass_Descr]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CustCommisClass_Descr]
	@parm1 varchar (10)
AS
	select	Descr
	from	CustCommisClass
	where	ClassID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
