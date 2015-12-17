USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wspObjExtension_Find]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[wspObjExtension_Find] @parm1 smallint, @parm2 varchar(60)
AS 
	SELECT * 
	FROM wspObjExtension
	WHERE sltypeid = @parm1
		AND slobjid = @parm2
GO
