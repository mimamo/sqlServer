USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BatchNumber_PV2]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[BatchNumber_PV2] @parm2 VARCHAR(5), @parm3 VARCHAR (5),@parm4 varchar (5), @parm5 varchar ( 2), @parm6 varchar ( 10) AS
    SELECT * FROM Batch
    WHERE  (EditScrnNbr = @parm2 OR EditScrnNbr = @parm3 OR EditScrnNbr = @parm4)
        AND module = @parm5
        AND BatNbr LIKE @parm6
   ORDER BY BatNbr
GO
