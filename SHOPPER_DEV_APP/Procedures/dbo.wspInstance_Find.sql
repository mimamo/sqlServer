USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wspInstance_Find]    Script Date: 12/16/2015 15:55:37 ******/
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
