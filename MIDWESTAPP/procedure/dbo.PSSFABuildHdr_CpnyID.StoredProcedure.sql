USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFABuildHdr_CpnyID]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFABuildHdr_CpnyID] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFABuildHdr WHERE CpnyId = @parm1 AND BuildNbr LIKE @parm2 ORDER BY BuildNbr
GO
