USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLSector_Nav]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLSector_Nav] @parm1min SMALLINT, @parm1max SMALLINT AS
  SELECT * FROM PSSLLSector WHERE linenbr BETWEEN @parm1min AND @parm1max ORDER BY Sector, LineNbr
GO
