USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLSector_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLSector_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLSector WHERE Sector LIKE @parm1 ORDER BY Sector
GO
