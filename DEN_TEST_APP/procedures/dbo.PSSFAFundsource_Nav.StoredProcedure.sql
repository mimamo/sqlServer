USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAFundsource_Nav]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAFundsource_Nav] @parm1min SMALLINT, @parm1max SMALLINT AS
  SELECT * FROM PSSFAFundsource WHERE LineNbr BETWEEN @parm1min AND @parm1max ORDER BY FundSource, LineNbr
GO
