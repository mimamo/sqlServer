USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemSite_Invtid_SiteId]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ItemSite_Invtid_SiteId]
	@parm1 varchar (30),
	@parm2 varchar (10)
AS
        SELECT *
	FROM ItemSite
	WHERE InvtId = @parm1 AND SiteId = @parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
