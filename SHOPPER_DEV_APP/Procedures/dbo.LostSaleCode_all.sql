USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LostSaleCode_all]    Script Date: 12/16/2015 15:55:24 ******/
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
