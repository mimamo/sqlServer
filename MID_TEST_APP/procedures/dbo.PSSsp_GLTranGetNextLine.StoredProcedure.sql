USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_GLTranGetNextLine]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_GLTranGetNextLine] @pcModule VARCHAR(2), @pcBatNbr VARCHAR(10) AS
  SELECT * FROM GLTran WHERE Module = @pcModule AND BatNbr = @pcBatNbr ORDER BY Module, Batnbr, LineNbr desc
GO
