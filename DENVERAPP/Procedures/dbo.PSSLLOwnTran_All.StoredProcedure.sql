USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLOwnTran_All]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLOwnTran_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLOwnTran WHERE RefNbr LIKE @parm1 ORDER BY RefNbr
GO
