USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_RlsedCaTimeSheets_EmpId2]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_RlsedCaTimeSheets_EmpId2] @parm1 varchar ( 10) as
       Select t.* from PRTran t, CalcChk c
           where t.EmpId       =  @parm1
             and t.TranType    =  'CA'
             and t.Rlsed       =  1
             and t.Paid        =  0
             and (t.TimeShtFlg  =  1 or t.Type_ = 'NC')
             and t.EmpId       =  c.EmpId
             and t.ChkSeq      =  c.ChkSeq
             and c.CheckNbr    <> ''
           order by t.EmpId,
                    t.TimeShtFlg,
                    t.Rlsed     ,
                    t.Paid
GO
