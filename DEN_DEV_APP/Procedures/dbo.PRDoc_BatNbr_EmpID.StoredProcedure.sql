USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_BatNbr_EmpID]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRDoc_BatNbr_EmpID] @parm1 varchar ( 10), @parm2 varchar ( 10) as
        Select * from PRDoc where BatNbr = @parm1 and EmpID = @parm2 and
        Status <> 'V'
        order by BatNbr, EmpID
GO
