USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CustomerEDI_all]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CustomerEDI_all]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM CustomerEDI
	WHERE CustID LIKE @parm1
	ORDER BY CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
