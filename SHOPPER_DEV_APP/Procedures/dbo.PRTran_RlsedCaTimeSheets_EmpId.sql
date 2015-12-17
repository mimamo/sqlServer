USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_RlsedCaTimeSheets_EmpId]    Script Date: 12/16/2015 15:55:30 ******/
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
