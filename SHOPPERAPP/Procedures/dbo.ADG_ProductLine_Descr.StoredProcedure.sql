USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProductLine_Descr]    Script Date: 12/21/2015 16:13:00 ******/
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
