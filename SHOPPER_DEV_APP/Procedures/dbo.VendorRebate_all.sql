USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendorRebate_all]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[VendorRebate_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM VendorRebate
	WHERE RebateID LIKE @parm1
	ORDER BY RebateID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
