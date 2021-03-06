USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_PerEnt_Jrnl_Stat_BatNbr]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_PerEnt_Jrnl_Stat_BatNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_PerEnt_Jrnl_Stat_BatNbr] @parm1 varchar ( 6), @parm2 varchar ( 3), @parm3 varchar ( 1), @parm4 varchar ( 10) as
       Select * from Batch
           where PerEnt   =  @parm1
             and JrnlType =  @parm2
             and Status   =  @parm3
             and BatNbr   =  @parm4
       order by EditScrnNbr, BatNbr
GO
