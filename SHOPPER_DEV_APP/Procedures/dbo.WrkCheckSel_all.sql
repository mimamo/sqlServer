USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCheckSel_all]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WrkCheckSel_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 15 ),
	@parm3 varchar( 2 ),
	@parm4 varchar( 10 )
AS
	set nocount on
	SELECT *
	FROM WrkCheckSel
	WHERE AccessNbr BETWEEN @parm1min AND @parm1max
	   AND VendId LIKE @parm2
	   AND DocType LIKE @parm3
	   AND RefNbr LIKE @parm4
	ORDER BY AccessNbr,
	   VendId,
	   DocType,
	   RefNbr
GO
