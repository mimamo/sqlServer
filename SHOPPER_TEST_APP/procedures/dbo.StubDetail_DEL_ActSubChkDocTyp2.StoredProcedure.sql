USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[StubDetail_DEL_ActSubChkDocTyp2]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[StubDetail_DEL_ActSubChkDocTyp2] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar (10) as
       Delete s from StubDetail s, CalcChk c
           where s.Acct     =  @parm1
             and s.Sub      =  @parm2
             and s.ChkNbr   =  c.CheckNbr
             and c.EmpId    =  @parm3
             and c.CheckNbr <> ''
GO
