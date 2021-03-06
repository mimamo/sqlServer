USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCheckSel_AccessNbr_DiscDate]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WrkCheckSel_AccessNbr_DiscDate]
	@parm1min smallint, @parm1max smallint,
	@parm2min smalldatetime, @parm2max smalldatetime,
	@parm3min smalldatetime, @parm3max smalldatetime
AS
	set nocount on
	SELECT *
	FROM WrkCheckSel
	WHERE AccessNbr BETWEEN @parm1min AND @parm1max
	   AND DiscDate BETWEEN @parm2min AND @parm2max
	   AND DueDate BETWEEN @parm3min AND @parm3max
	ORDER BY AccessNbr,
	   DiscDate,
	   DueDate
GO
