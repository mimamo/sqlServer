USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DummyARTran_Bat_Cust_Type_Cost]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DummyARTran_Bat_Cust_Type_Cost] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    select * from ARTran where
    BatNbr = @parm1
    and DrCr = 'U'
    and CustId = @parm2
    and TranType = @parm3
    and RefNbr = @parm4
    order by CostType
GO
