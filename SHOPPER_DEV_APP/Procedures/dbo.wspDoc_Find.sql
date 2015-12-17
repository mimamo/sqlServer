USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wspDoc_Find]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[wspDoc_Find] @parm1 smallint, @parm2 smallint
AS
	SELECT *
	FROM wspdoc
	WHERE instance = @parm1
		AND documentid = @parm2
GO
