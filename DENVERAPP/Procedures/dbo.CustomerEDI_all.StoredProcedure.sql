USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustomerEDI_all]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustomerEDI_all]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM CustomerEDI
	WHERE CustID LIKE @parm1
	ORDER BY CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
