USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Tool_All]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Tool_All] @parm1 varchar ( 10) as
            Select * from Tool where ToolId like @parm1
                order by ToolId
GO
