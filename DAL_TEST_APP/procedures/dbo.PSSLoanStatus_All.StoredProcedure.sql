USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanStatus_All]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanStatus_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLoanStatus WHERE StatusCode LIKE @parm1 ORDER BY Statuscode
GO
