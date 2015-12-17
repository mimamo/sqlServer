USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_Bat_Cust_Type_Ref2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_Bat_Cust_Type_Ref2    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_Bat_Cust_Type_Ref2] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10), @parm5 varchar(1) as
    select * from ARTran where
    BatNbr = @parm1
    and CustId = @parm2
    and TranType = @parm3
    and RefNbr = @parm4
    and DrCr = @parm5
    order by BatNbr, CustID, TranType, RefNbr
GO
