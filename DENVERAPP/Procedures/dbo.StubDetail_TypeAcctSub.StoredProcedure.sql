USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[StubDetail_TypeAcctSub]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[StubDetail_TypeAcctSub] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 2) as
       Select * from StubDetail
           where StubType =  @parm1
          and Acct     = @parm2
            and Sub      = @parm3
             and ChkNbr   = @parm4
             and DocType  LIKE @parm5
           order by StubType, Acct, Sub, ChkNbr, DocType
GO
