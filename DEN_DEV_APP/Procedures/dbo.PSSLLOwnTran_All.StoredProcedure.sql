USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLOwnTran_All]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLOwnTran_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLOwnTran WHERE RefNbr LIKE @parm1 ORDER BY RefNbr
GO
