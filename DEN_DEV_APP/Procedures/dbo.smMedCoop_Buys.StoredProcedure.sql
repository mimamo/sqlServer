USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smMedCoop_Buys]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMedCoop_Buys]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smMedCoop
  	WHERE
  		MedCoopBuyId = @parm1
  			AND
  		LineNbr BETWEEN @parm2beg AND @parm2end
  	ORDER BY
  		MedCoopBuyId
  		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
