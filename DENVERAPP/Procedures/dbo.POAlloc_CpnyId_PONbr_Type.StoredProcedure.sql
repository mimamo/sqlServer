USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POAlloc_CpnyId_PONbr_Type]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POAlloc_CpnyId_PONbr_Type]
	@parm1 varchar ( 10),
	@parm2 varchar ( 10),
	@parm3 varchar ( 1)
As
	SELECT *
	FROM POAlloc
	WHERE CpnyID = @parm1
       		AND PONbr = @parm2
        	AND DocType = @parm3

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
