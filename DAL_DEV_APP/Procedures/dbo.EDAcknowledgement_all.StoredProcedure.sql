USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_all]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDAcknowledgement_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM EDAcknowledgement
	WHERE AcknowledgementID BETWEEN @parm1min AND @parm1max
	ORDER BY AcknowledgementID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
