USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WSPPubDoc_All_Active]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPPubDoc_All_Active] @parm1 smallint, @parm2 varchar(60) 
AS  
	SELECT *  
	FROM WSPPubDocLib
	WHERE DocumentID = @parm1 And SLObjId = @parm2 And Status = '1'
	ORDER BY SLTypeId
GO
