USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UserRec_All]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_UserRec_All]
	@parm1 varchar( 1 ),
	@parm2 varchar( 47 )

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	declare @Query varchar(255)

	--Execute the query from a variable so this procedure will compile even though the
	--view may not exist

	select @Query = 'SELECT	* FROM vs_UserRec WHERE RecType LIKE '' + @parm1 + '' AND UserId LIKE '' + @parm2 + '' ORDER BY RecType, UserId'

	select @Query

	execute(@Query)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
