USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_RefNbr_BOMLineNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BOMTran_RefNbr_BOMLineNbr]
	@parm1 varchar( 10 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM BOMTran
	WHERE RefNbr LIKE @parm1
	   AND BOMLineNbr BETWEEN @parm2min AND @parm2max
	ORDER BY RefNbr,
	   BOMLineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
