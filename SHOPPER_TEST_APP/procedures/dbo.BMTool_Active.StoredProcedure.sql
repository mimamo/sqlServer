USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMTool_Active]    Script Date: 12/21/2015 16:06:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMTool_Active] @ToolId varchar ( 10) as
            Select * from Tool where ToolId like @ToolId
			and Status = 'A'
                order by ToolId
GO
