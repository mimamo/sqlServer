USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Operation_All]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Operation_All] @parm1 varchar ( 10) as
            Select * from Operation where
			OperationId like @parm1
			order by OperationId
GO
