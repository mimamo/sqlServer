USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smBatch_EditScrNbr]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smBatch_EditScrNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM smBatch
	WHERE EditScrNbr LIKE @parm1
	   AND Batnbr LIKE @parm2
	ORDER BY EditScrNbr,
	   Batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
