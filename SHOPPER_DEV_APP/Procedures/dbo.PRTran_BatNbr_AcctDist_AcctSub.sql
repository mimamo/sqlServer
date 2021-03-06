USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_AcctDist_AcctSub]    Script Date: 12/16/2015 15:55:30 ******/
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
