USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustCommisClass_Descr]    Script Date: 12/21/2015 13:44:41 ******/
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
