USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLetSign_All]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLetSign_All] @parm1 VARCHAR(10) AS
  SELECT * From PSSLetSign WHERE ImageCode LIKE @parm1 ORDER BY ImageCode
GO
