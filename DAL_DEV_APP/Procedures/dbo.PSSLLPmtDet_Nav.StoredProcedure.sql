USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtDet_Nav]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtDet_Nav] @parm1 VARCHAR(20), @parm2 VARCHAR(10), @parm3min SMALLINT, @parm3max SMALLINT AS
  SELECT * FROM PSSLLTran WHERE LoanNo = @parm1 AND PmtRefNbr = @parm2 ORDER BY LoanNo, Refnbr
GO
