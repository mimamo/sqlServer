USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_LineRef_Dept_dbnav]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReqHist_LineRef_Dept_dbnav    Script Date: 12/17/97 10:48:50 AM ******/
CREATE PROCEDURE [dbo].[POReqHist_LineRef_Dept_dbnav] @parm1 Varchar(10), @parm2 Varchar(5), @Parm3 Varchar(47),
@parm4Beg SmallDAteTime, @Parm4End SmallDateTime, @Parm5 Varchar(10) AS
SELECT * FROM POReqHist
WHERE ReqNbr = @parm1 and
LineRef Like @parm2 and
TranDate Between @Parm4Beg and @Parm4End and
TranTime LIKE @Parm5 and
UserID LIKE @Parm3 and
ApprPath IN ('D', 'J')
ORDER BY ReqNbr, LineRef, TranDate DESC, TranTime DESC, UserID, ApprPath
GO
