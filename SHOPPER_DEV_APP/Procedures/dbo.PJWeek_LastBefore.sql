USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJWeek_LastBefore]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJWeek_LastBefore]
@Date smalldatetime
AS
SELECT *
FROM PJWeek
WHERE WE_Date <= @Date
ORDER BY WE_Date DESC
GO
