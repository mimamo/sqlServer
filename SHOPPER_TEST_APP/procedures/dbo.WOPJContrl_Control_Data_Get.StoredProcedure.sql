USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJContrl_Control_Data_Get]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJContrl_Control_Data_Get]
	@Control_Type	varchar( 2 ),
	@Control_Code	varchar( 30 )
AS
	SELECT 		Control_Data
	FROM 		PJContrl (NoLock)
	WHERE 		Control_Type LIKE @Control_Type
	   		and Control_Code LIKE @Control_Code
GO
