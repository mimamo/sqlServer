USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDDepositor_All]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDDepositor_All] @parm1 varchar ( 10) as
    Select * from DDDepositor where EmpID like @parm1 ORDER by EmpID
GO
