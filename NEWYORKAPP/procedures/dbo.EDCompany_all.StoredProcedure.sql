USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCompany_all]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDCompany_all]
 @CpnyID varchar( 10 )

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
 SELECT *
 FROM Company
 WHERE CpnyID LIKE @CpnyID
 ORDER BY CpnyID
GO
