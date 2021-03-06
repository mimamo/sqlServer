USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_LineNbr_All]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReqDet_LineNbr_All    Script Date: 12/17/97 10:49:15 AM ******/
CREATE PROCEDURE [dbo].[POReqDet_LineNbr_All] @parm1 Varchar(10), @parm2 Varchar(2), @parm3min SmallInt, @parm3max SmallInt AS
SELECT * FROM POReqDet
WHERE ReqNbr = @parm1 and
ReqCntr = @Parm2 and
LineNbr BETWEEN @parm3min AND @parm3max
ORDER BY ReqNbr, ReqCntr, LineNbr
GO
