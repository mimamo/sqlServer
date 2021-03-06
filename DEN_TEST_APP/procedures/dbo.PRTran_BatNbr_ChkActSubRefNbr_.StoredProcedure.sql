USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_ChkActSubRefNbr_]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_BatNbr_ChkActSubRefNbr_] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 2), @parm6beg smallint, @parm6end smallint as
       Select * from PRTran
           where BatNbr   =        @parm1
             and ChkAcct  =        @parm2
             and ChkSub   =        @parm3
             and RefNbr   =        @parm4
             and TranType =        @parm5
             and LineNbr  BETWEEN  @parm6beg and @parm6end
           order by BatNbr  ,
                    ChkAcct ,
                    ChkSub  ,
                    RefNbr  ,
                    TranType,
                    LineNbr
GO
