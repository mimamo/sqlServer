USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMTool_Active]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMTool_Active] @ToolId varchar ( 10) as
            Select * from Tool where ToolId like @ToolId
			and Status = 'A'
                order by ToolId
GO
