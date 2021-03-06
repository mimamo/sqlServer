USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_PIID_TagNbr]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIDetail_PIID_TagNbr]
	@Parm1 varchar (10),
	@Parm2 int,
	@Parm3 int,
	@Parm4 smallint ,
	@Parm5 smallint
AS
	SELECT * FROM PIDetail
	WHERE PIID = @Parm1
	AND Number BETWEEN @Parm2 AND @Parm3
	AND LineNbr BETWEEN @Parm4 AND @Parm5
	ORDER BY PIID, LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
