USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFileAttachType_Active]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFileAttachType_Active] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFileAttachType WHERE FileCode LIKE @parm1 AND Active = 1 ORDER BY FileCode
GO
