USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[checkModuleYear]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[checkModuleYear] @Module VARCHAR(2), @Year INT, @show_select int
AS
	DECLARE @return_value INT

	SELECT @return_value = COUNT(*) 
	FROM Batch
	WHERE STATUS IN ('B', 'H')
		AND Module LIKE @Module
		AND (PerPost/100) < @Year
	IF @show_select = 1
		SELECT @return_value
	RETURN @return_value
GO
