USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PJCODE_Descr]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_PJCODE_Descr]
	@code_type varchar(4),
	@code_value varchar(30)
AS
	select	code_value_desc
	from	PJCODE
	where	code_type = @code_type
	and	code_value = @code_value

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
