USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFACustodian_All]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFACustodian_All] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSFACustodian WHERE Custodian LIKE @parm1 ORDER BY Custodian
GO
