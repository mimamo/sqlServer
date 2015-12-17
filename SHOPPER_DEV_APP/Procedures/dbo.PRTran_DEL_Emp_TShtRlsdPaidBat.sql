USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_DEL_Emp_TShtRlsdPaidBat]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_DEL_Emp_TShtRlsdPaidBat] @parm1 varchar ( 10), @parm2 smallint, @parm3 smallint, @parm4 smallint, @parm5 varchar ( 10) as
       Delete prtran from PRTran
           where EmpId       =  @parm1
             and TimeShtFlg  =  @parm2
             and Rlsed       =  @parm3
             and Paid        =  @parm4
             and BatNbr      =  @parm5
GO
