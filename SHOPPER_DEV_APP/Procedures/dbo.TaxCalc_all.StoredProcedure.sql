USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TaxCalc_all]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TaxCalc_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM TaxCalc
	WHERE DetLineID BETWEEN @parm1min AND @parm1max
	ORDER BY DetLineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
