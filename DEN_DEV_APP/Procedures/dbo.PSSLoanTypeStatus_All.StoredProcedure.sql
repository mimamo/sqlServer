USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanTypeStatus_All]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanTypeStatus_All] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSLoanTypeStatus WHERE LoanTypeCode = @parm1  and statuscode like @parm2 ORDER BY LoanTypeCode
GO
