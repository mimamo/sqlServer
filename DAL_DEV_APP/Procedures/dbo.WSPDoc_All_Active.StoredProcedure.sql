USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WSPDoc_All_Active]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPDoc_All_Active] @parm1 smallint
AS  
	SELECT *  
	FROM WSPDoc  
	WHERE DocumentID = @parm1 And Active = 1
	ORDER BY DocumentID
GO
