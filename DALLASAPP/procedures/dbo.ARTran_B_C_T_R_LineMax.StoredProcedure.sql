USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_B_C_T_R_LineMax]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_B_C_T_R_LineMax    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_B_C_T_R_LineMax] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    select MAX(LineNbr) from ARTran where
    BatNbr = @parm1
    and CustId = @parm2
    and TranType = @parm3
    and RefNbr = @parm4
    and DrCr <> 'U'
GO
