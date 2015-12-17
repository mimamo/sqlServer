USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_PR_Stat_BatNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Batch_PR_Stat_BatNbr] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 10) as
       Select * from Batch
           where ( EditScrnNbr  = '02635' or EditScrnNbr    = '02630' )
             and Status         =  @parm1
             and CpnyId         =  @parm2
             and BatNbr      LIKE  @parm3
           order by EditScrnNbr, BatNbr
GO
