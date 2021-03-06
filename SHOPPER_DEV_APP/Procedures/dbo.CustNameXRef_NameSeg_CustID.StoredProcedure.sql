USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustNameXRef_NameSeg_CustID]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustNameXRef_NameSeg_CustID]
	@parm1 varchar( 20 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM CustNameXRef
	WHERE NameSeg LIKE @parm1
	   AND CustID LIKE @parm2
	ORDER BY NameSeg,
	   CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
