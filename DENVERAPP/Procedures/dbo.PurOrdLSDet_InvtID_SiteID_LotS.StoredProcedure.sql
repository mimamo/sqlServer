USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_InvtID_SiteID_LotS]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdLSDet_InvtID_SiteID_LotS]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 25 )
AS
	SELECT *
	FROM PurOrdLSDet
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
