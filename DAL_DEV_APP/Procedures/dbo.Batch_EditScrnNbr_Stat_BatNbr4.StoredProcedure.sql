USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_Stat_BatNbr4]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_EditScrnNbr_Stat_BatNbr4    ******/
Create Proc [dbo].[Batch_EditScrnNbr_Stat_BatNbr4] @Parm1 varchar ( 10), @parm2 varchar ( 5), @parm3 varchar ( 1), @parm4 varchar ( 10) as
       Select * from Batch
           where CpnyID         =  @parm1
             and EditScrnNbr    =  @parm2
             and Status         =  @parm3
             and BatNbr      LIKE  @parm4
           order by CpnyID, EditScrnNbr, BatNbr
GO
