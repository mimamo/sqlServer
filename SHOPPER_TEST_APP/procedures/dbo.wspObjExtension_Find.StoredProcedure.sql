USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[wspObjExtension_Find]    Script Date: 12/21/2015 16:07:23 ******/
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
