USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSSegDef]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSSegDef] @parm1 SMALLINT, @parm2 VARCHAR(24) AS
  SELECT * FROM SegDef WHERE FieldClassName = 'SUBACCOUNT' AND SegNumber = @parm1 AND ID LIKE @parm2 ORDER BY FieldClassName, SegNumber, ID
GO
