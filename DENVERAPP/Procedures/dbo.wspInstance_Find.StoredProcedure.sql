USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[wspInstance_Find]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[wspInstance_Find] @parm1 smallint
AS
	SELECT * 
	FROM wspinstance
	WHERE sltypeid = @parm1
GO
