USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWeek_FirstAfter]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJWeek_FirstAfter]
@Date smalldatetime
AS
SELECT *
FROM PJWeek
WHERE WE_Date >= @Date
ORDER BY WE_Date ASC
GO
