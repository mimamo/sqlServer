USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_GLTranAll]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_GLTranAll] AS
  SELECT * FROM GLTran
GO
