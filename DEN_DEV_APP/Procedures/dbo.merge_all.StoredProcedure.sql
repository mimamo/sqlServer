USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[merge_all]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[merge_all] @parm1 varchar (50),  @parm2 varchar (50) as
SELECT * FROM merge where 
	TableName = @parm1 and
	KeyField = @parm2
	ORDER BY tablename, KeyField
GO
