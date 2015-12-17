USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StubDetail_DEL_ActSubChkDocTyp]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[StubDetail_DEL_ActSubChkDocTyp] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10), @parm4 varchar ( 2) as
       Delete stubdetail from StubDetail
           where Acct     =  @parm1
             and Sub      =  @parm2
             and ChkNbr   =  @parm3
             and DocType  =  @parm4
GO
