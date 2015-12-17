USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCCode_Method_Code_Receipt]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCCode_Method_Code_Receipt]
	@parm1 VARCHAR(01),
	@parm2 VARCHAR(01),
	@parm3 VARCHAR(01),
	@parm4 VARCHAR(01),
	@parm5 VARCHAR(10)
AS
	SELECT *
	FROM lccode
	WHERE allocmethod in (@parm1, @parm2, @parm3, @parm4)
	and  lccode like @parm5
	and Applmethod in ('B','R')
	ORDER BY lccode

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
