USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMTool_Active]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMTool_Active] @ToolId varchar ( 10) as
            Select * from Tool where ToolId like @ToolId
			and Status = 'A'
                order by ToolId
GO
