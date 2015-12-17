USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WSPDocExt_All]    Script Date: 12/16/2015 15:55:37 ******/
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
