USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LostSaleCode_all]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LostSaleCode_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM LostSaleCode
	WHERE LostSaleID LIKE @parm1
	ORDER BY LostSaleID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
