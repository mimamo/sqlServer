USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFileAttach_Nav]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFileAttach_Nav] @parm1 VARCHAR(30), @parm2 VARCHAR(100), @parm3min SMALLINT, @parm3max SMALLINT AS
  SELECT * FROM PSSFileAttach WHERE TableName = @parm1 AND Keyfield = @parm2 AND lineid BETWEEN @parm3min AND @parm3max
GO
