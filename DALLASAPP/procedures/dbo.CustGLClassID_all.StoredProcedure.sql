USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustGLClassID_all]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustGLClassID_all]
	@parm1 varchar(10)
AS
	SELECT *
	FROM CustGLClass
	WHERE s4future11 LIKE @parm1
	ORDER BY s4future11
GO
