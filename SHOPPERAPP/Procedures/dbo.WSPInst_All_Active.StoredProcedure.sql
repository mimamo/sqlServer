USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WSPInst_All_Active]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPInst_All_Active] @parm1 smallint
AS  
	SELECT *  
	FROM WSPInstance  
	WHERE SLTypeID = @parm1 And Status = "Y"
	ORDER BY SLTypeId
GO
