USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFACustodian_Nav]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFACustodian_Nav] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSFACustodian WHERE Custodian LIKE @parm1 ORDER BY Custodian
GO
