USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ProductLine_all]    Script Date: 12/21/2015 15:43:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProductLine_all]
	@parm1 varchar( 4 )
AS
	SELECT *
	FROM ProductLine
	WHERE ProdLineID LIKE @parm1
	ORDER BY ProdLineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
