USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_LineNbr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_BatNbr_LineNbr] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
       Select * from PRTran
           where BatNbr   =        @parm1
             and LineNbr  BETWEEN  @parm2beg and @parm2end
           order by BatNbr  ,
                    ChkAcct ,
                    ChkSub  ,
                    RefNbr  ,
                    TranType,
                    LineNbr
GO
