USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Updt_GLTran_Posted]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Updt_GLTran_Posted] @PARM1 VARCHAR(2), @PARM2 VARCHAR (10), @PARM3 CHAR (1) AS
    UPDATE GLTran
    SET Posted = @parm3
    WHERE Module = @parm1 AND
    BatNbr = @parm2
GO
