USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_Stat_BatNbr]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_EditScrnNbr_Stat_BatNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_EditScrnNbr_Stat_BatNbr] @parm1 varchar ( 5), @parm2 varchar ( 1), @parm3 varchar ( 10) as
       Select * from Batch
           where EditScrnNbr    =  @parm1
             and Status         =  @parm2
             and BatNbr      LIKE  @parm3
           order by EditScrnNbr, BatNbr
GO
