USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_RefNbr_KitID_CmpnentID]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BOMTran_RefNbr_KitID_CmpnentID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM BOMTran
	WHERE RefNbr LIKE @parm1
	   AND KitID LIKE @parm2
	   AND CmpnentID LIKE @parm3
	ORDER BY RefNbr,
	   KitID,
	   CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
