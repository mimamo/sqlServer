USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQreqdet_LineNbr_All]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RQreqdet_LineNbr_All] @parm1 Varchar(10), @parm2 Varchar(2), @parm3min SmallInt, @parm3max SmallInt AS
SELECT * FROM RQreqdet
WHERE ReqNbr = @parm1 and
ReqCntr = @Parm2 and
LineNbr BETWEEN @parm3min AND @parm3max
ORDER BY ReqNbr, ReqCntr, LineNbr
GO
