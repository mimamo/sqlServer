USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrc_CatalogNbr]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SlsPrc_CatalogNbr]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM SlsPrc
	WHERE CatalogNbr LIKE @parm1
	ORDER BY CatalogNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
