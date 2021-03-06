USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Stat_Mod_Cpny_Ty_LEPost]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Stat_Mod_Cpny_Ty_LEPost    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Stat_Mod_Cpny_Ty_LEPost] @parm1 varchar (1), @parm2 varchar ( 2), @parm3 varchar ( 10), @parm4 varchar ( 1), @parm5 varchar ( 6) as
       Select * from Batch, Currncy
           where Batch.CuryId = Currncy.CuryId
             and Batch.Status  =    @parm1
             and Module  =    @parm2
             and CpnyID like  @parm3
             and BatType like @parm4
             and PerPost <=   @parm5
           order by Batch.Status, Module, CpnyID, BatNbr
GO
