USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_FOBPoint_Descr]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_FOBPoint_Descr]	@parm1 VARCHAR(15)
AS
	SELECT Descr
	FROM FOBPoint
	WHERE FOBID = @parm1
GO
