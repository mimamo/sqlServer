USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BatchNumber_PV]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[BatchNumber_PV] @parm1 VARCHAR ( 10), @parm2 VARCHAR( 5), @parm3 VARCHAR ( 5),@parm4 varchar (5), @parm5 varchar ( 2), @parm6 varchar ( 10) AS
    SELECT * FROM Batch
    WHERE
        CpnyId = @parm1
        AND (EditScrnNbr = @parm2 OR EditScrnNbr = @parm3 OR EditScrnNbr = @parm4)
        AND module = @parm5
        AND BatNbr LIKE @parm6
	AND Status <> 'V'
    ORDER BY BatNbr
GO
