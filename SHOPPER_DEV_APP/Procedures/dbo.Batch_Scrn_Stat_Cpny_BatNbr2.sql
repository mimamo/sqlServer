USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Scrn_Stat_Cpny_BatNbr2]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Scrn_Stat_Cpny_BatNbr2    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Scrn_Stat_Cpny_BatNbr2] @parm1 varchar ( 10), @parm2 varchar ( 5), @parm3 varchar ( 1), @parm4 varchar ( 10) as
       Select * from Batch
           where cpnyid = @parm1
                 and EditScrnNbr    =  @parm2
             and Status         =  @parm3
             and BatNbr      LIKE  @parm4
           order by CpnyId, EditScrnNbr, BatNbr DESC
GO
