USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLetSign_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLetSign_All] @parm1 VARCHAR(10) AS
  SELECT * From PSSLetSign WHERE ImageCode LIKE @parm1 ORDER BY ImageCode
GO
