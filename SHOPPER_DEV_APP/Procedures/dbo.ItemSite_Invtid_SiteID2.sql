USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Invtid_SiteID2]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemSite_Invtid_SiteID2]
	@Parm1 varchar (10),
	@parm2 varchar (30),
	@parm3 varchar (10)
AS
	SELECT *
	FROM ItemSite
        WHERE cpnyid = @Parm1
	  And InvtId like @parm2 AND
		SiteId like @parm3
        ORDER BY  InvtID, SiteId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
