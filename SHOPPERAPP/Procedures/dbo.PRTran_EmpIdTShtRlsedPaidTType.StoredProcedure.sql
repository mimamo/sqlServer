USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EmpIdTShtRlsedPaidTType]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_EmpIdTShtRlsedPaidTType] @parm1 varchar ( 10), @parm2 smallint, @parm3 smallint, @parm4 smallint, @parm5 varchar ( 2) as
       Select * from PRTran
           where EmpId       =  @parm1
             and TimeShtFlg  =  @parm2
             and Rlsed       =  @parm3
             and Paid        =  @parm4
             and TranType    =  @parm5
           order by EmpId,
                    TimeShtFlg,
                    Rlsed     ,
                    Paid
GO
