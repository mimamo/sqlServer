USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFABookCode_Nav]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFABookCode_Nav] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFABookCode WHERE BookCode LIKE @parm1 ORDER BY BookCode
GO
