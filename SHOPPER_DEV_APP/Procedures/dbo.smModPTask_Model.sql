USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smModPTask_Model]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smModPTask_Model]
		@parm1 	varchar(10)
		,@parm2	varchar(40)
AS
	SELECT
		*
	FROM
		smModPTask
	WHERE
		Manuf LIKE @parm1
			AND
		Model LIKE @parm2
	ORDER BY
		smModPTask.Manuf
		,smModPTask.Model
		,smModPTask.PMCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
