USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFABookCode_All]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFABookCode_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFABookCode WHERE BookCode LIKE @parm1 ORDER BY BookCode
GO
