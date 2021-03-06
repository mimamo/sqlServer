USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOLot_all]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOLot_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 5 ),
	@parm5 varchar( 5 )
AS
	SELECT *
	FROM SOLot
	WHERE CpnyID = @parm1
	   AND OrdNbr = @parm2
	   AND LineRef LIKE @parm3
	   AND SchedRef LIKE @parm4
	   AND LotSerRef LIKE @parm5
	ORDER BY CpnyID,
	   OrdNbr,
	   LineRef,
	   SchedRef,
	   LotSerRef
GO
