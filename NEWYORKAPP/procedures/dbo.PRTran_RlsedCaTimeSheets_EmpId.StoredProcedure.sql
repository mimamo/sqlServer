USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_RlsedCaTimeSheets_EmpId]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_RlsedCaTimeSheets_EmpId] @parm1 varchar ( 10) as
       Select * from PRTran
           where EmpId       =  @parm1
             and TranType    =  'CA'
             and Rlsed       =  1
             and Paid        =  0
             and (TimeShtFlg  =  1 or Type_ = 'NC')
           order by EmpId,
                    TimeShtFlg,
                    Rlsed     ,
                    Paid
GO
