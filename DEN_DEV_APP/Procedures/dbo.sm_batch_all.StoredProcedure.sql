USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_batch_all]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sm_batch_all]
	@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		batch
	WHERE
		batnbr LIKE @parm1
	ORDER BY
		batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
