USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFALocation_Nav]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFALocation_Nav] @parm1min SMALLINT, @parm1max SMALLINT, @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFALocation WHERE LineId BETWEEN @parm1min AND @parm1max AND LocId LIKE @parm2 ORDER BY LocId, LineId
GO
