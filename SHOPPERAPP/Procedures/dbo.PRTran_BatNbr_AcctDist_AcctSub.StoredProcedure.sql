USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_AcctDist_AcctSub]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_BatNbr_AcctDist_AcctSub] @parm1 varchar ( 10), @parm2 smallint as
       Select * from PRTran
           where BatNbr    =  @parm1
             and AcctDist  =  @parm2
             and TranAmt <> 0
           order by BatNbr,
                    Acct  ,
                    Sub
GO
