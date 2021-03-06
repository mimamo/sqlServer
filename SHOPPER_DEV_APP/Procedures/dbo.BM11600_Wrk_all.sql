USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM11600_Wrk_all]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BM11600_Wrk_all]
	@parm1min int, @parm1max int,
	@parm2 varchar( 8 ),
	@parm3 varchar( 47 )
AS
	SELECT *
	FROM BM11600_Wrk
	WHERE ISequence BETWEEN @parm1min AND @parm1max
	   AND LUpd_Prog LIKE @parm2
	   AND LUpd_User LIKE @parm3
	ORDER BY ISequence,
	   LUpd_Prog,
	   LUpd_User
GO
