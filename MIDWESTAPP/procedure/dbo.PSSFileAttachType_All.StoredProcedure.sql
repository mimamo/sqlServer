USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFileAttachType_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFileAttachType_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFileAttachType WHERE FileCode LIKE @parm1 ORDER BY FileCode
GO
