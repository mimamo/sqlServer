USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[checkModulePeriod]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[checkModulePeriod] @Module VARCHAR(2), @yearPeriod INT, @show_select int
AS
	DECLARE @return_value INT

	SELECT @return_value = COUNT(*) 
	FROM Batch
	WHERE STATUS IN ('B', 'H')
		AND Module LIKE @Module
		AND PerPost < @yearPeriod
	IF @show_select = 1
		SELECT @return_value
	RETURN @return_value
GO
