USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRLTHeader_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRLTHeader_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM IRLTHeader
	WHERE LeadTimeID LIKE @parm1
	ORDER BY LeadTimeID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
