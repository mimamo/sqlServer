USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintQueue_all_ByInvoice]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintQueue_all_ByInvoice]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 10 ),
	@parm3 varchar( 15 ),
	@parm4 varchar( 15 )
AS
	SELECT *
	FROM SOPrintQueue
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND CpnyID LIKE @parm2
	   AND OrdNbr LIKE @parm3
	   AND ShipperID LIKE @parm4
	ORDER BY RI_ID,
	   CpnyID,
	   InvcNbr,
	   ShipperID,
	   OrdNbr
GO
