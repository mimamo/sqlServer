USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAFundSource_All]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAFundSource_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFAFundSource WHERE FundSource LIKE @parm1 ORDER BY FundSource
GO
