USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Country_Descr]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Country_Descr]
	@parm1 varchar(3)
AS
	Select	Descr
	from	Country
	where CountryID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
