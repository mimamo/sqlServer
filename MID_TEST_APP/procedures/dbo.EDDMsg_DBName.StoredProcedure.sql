USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDMsg_DBName]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDMsg_DBName]
	@CpnyID varchar( 10 )

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	SELECT DatabaseName
	FROM vs_Company
	WHERE CpnyID = @CpnyID
	ORDER BY CpnyID
GO
