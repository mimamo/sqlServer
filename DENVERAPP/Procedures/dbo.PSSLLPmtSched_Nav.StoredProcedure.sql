USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtSched_Nav]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtSched_Nav] @parm1 VARCHAR(20), @parm2min INT, @parm3max INT AS
  SELECT * FROM PSSLLPmtSched WHERE LoanNo = @parm1 AND LineId BETWEEN @parm2min AND @parm3max ORDER BY LoanNo, PmtNbr
GO
