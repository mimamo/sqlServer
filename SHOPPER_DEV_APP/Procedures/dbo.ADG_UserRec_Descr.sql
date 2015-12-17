USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UserRec_Descr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_UserRec_Descr]
	@parm1	char(1),
	@parm2	char(47)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare @Query varchar(255)

	--Execute the query from a variable so this procedure will compile even though the
	--view may not exist

	select @Query = 'select UserName from vs_UserRec where RecType = ''' + @parm1 + ''' and UserID = ''' + @parm2 + ''''

	execute(@Query)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
