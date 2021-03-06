USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqDet_LineNbr_All]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POItemReqDet_LineNbr_All    Script Date: 12/17/97 10:49:09 AM ******/
CREATE PROCEDURE [dbo].[POItemReqDet_LineNbr_All] @parm1 Varchar(10), @parm2min SmallInt, @parm2max SmallInt AS
SELECT * FROM POItemReqDet
WHERE ItemReqNbr = @parm1 and
LineNbr BETWEEN @parm2min AND @parm2max
ORDER BY ItemReqNbr, LineNbr
GO
