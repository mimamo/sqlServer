USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_WO_PJCONTRL_Control_Data]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_WO_PJCONTRL_Control_Data]
	@Control_Type	varchar (2),
	@Control_Code	varchar (30)
AS
	SELECT		Control_Data
	FROM		PJContrl
	WHERE		Control_Type = @Control_Type
			and Control_Code = @Control_Code
	ORDER BY	Control_Type, Control_Code
GO
