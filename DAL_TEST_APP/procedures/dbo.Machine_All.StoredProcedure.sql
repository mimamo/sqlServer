USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Machine_All]    Script Date: 12/21/2015 13:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Machine_All] @parm1 varchar ( 10) as
            Select * from Machine where MachineId like @parm1
                order by MachineId
GO
