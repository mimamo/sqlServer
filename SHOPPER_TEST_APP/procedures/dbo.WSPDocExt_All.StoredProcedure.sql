USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WSPDocExt_All]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPDocExt_All] @parm1 smallint, @parm2 varchar(60)
AS  
	SELECT *  
	FROM WSPObjExtension  
	WHERE SLTypeID = @parm1 and SLObjID = @parm2
	ORDER BY SLTypeID
GO
