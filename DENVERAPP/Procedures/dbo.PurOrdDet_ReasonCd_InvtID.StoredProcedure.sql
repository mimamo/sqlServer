USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_ReasonCd_InvtID]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdDet_ReasonCd_InvtID]
	@parm1 varchar( 6 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM PurOrdDet
	WHERE ReasonCd LIKE @parm1
	   AND InvtID LIKE @parm2
	ORDER BY ReasonCd,
	   InvtID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
