USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustCommisClass_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustCommisClass_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM CustCommisClass
	WHERE ClassID LIKE @parm1
	ORDER BY ClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
