USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFARetMethod_Nav]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFARetMethod_Nav] @parm1min SMALLINT, @parm1max SMALLINT, @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFARetMethod WHERE LineId BETWEEN @parm1min AND @parm1max AND RetireMethod LIKE @parm2 ORDER BY RetireMethod, LineId
GO
