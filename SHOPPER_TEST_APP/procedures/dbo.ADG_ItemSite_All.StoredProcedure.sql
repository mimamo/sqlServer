USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemSite_All]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ItemSite_All]
	@parm1 varchar (30),
	@parm2 varchar (10)
AS
	SELECT *
	FROM ItemSite
        WHERE InvtId = @parm1 AND
		SiteId like @parm2
        ORDER BY InvtID, SiteId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
