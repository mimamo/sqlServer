USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJWeek_LastBefore]    Script Date: 12/21/2015 13:45:02 ******/
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
