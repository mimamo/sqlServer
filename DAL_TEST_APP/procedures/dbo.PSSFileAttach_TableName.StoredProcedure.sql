USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFileAttach_TableName]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFileAttach_TableName] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSFileAttach WHERE TableName LIKE @parm1 ORDER BY TableName
GO
