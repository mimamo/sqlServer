USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMMachine_Active]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMMachine_Active] @MachId varchar ( 10) as
            Select * from Machine where MachineId like @MachId
			and Status = 'A'
                order by MachineId
GO
