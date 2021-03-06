USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHist_lineref_dbnav]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POItemReqHist_lineref_dbnav    Script Date: 12/17/97 10:48:50 AM ******/
CREATE PROCEDURE [dbo].[POItemReqHist_lineref_dbnav] @parm1 Varchar(10), @parm2 Varchar(5), @parm3Beg SmallDAteTime,
@Parm3End SmallDateTime, @parm4 Varchar(10), @Parm5 Varchar(47) AS
SELECT * FROM POItemReqHist
WHERE ItemReqNbr = @parm1 and
LineRef Like @parm2 and
TranDate Between @Parm3Beg and @Parm3End and
TranTime LIKE @Parm4 and
UserID LIKE @Parm5
ORDER BY ItemReqNbr, LineRef, TranDate DESC, TranTime DESC, UserID
GO
