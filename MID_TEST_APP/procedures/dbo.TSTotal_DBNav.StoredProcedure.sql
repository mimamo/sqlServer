USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TSTotal_DBNav]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[TSTotal_DBNav]
@ETid   varchar (10)
AS
SELECT TSTotal.*, EarnType.*
FROM TSTotal
     LEFT OUTER JOIN EarnType
         ON TSTotal.ETid=EarnType.id
WHERE TSTotal.ETid LIKE @ETid
GO
