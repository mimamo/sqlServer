USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpClass_GDB]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmpClass_GDB]
AS
	SELECT
		EmpClassID
	FROM
		smEmpClass
GO
