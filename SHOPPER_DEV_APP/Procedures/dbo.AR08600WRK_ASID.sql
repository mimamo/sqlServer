USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR08600WRK_ASID]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AR08600WRK_ASID] @parm1 int
AS
	SELECT *
	FROM AR08600_WRK
	WHERE ASID = @parm1
	ORDER BY ASID
GO
