USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFileAttach_KeyField]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFileAttach_KeyField] @parm1 VARCHAR(20), @parm2 VARCHAR(100) AS
  SELECT * FROM PSSFileAttach WHERE TableName = @parm1 AND KeyField LIKE @parm2 ORDER BY TableName, KeyField
GO
