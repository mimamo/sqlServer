USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProductLine_Descr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ProductLine_Descr]
	@parm1 varchar( 4 )
AS
	SELECT Descr
	FROM ProductLine
	WHERE ProdLineID LIKE @parm1
	ORDER BY ProdLineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
