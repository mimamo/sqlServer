USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_BatType_NINStat_Post]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_BatType_NINStat_Post    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Mod_BatType_NINStat_Post] @parm1 varchar ( 2), @parm2 varchar ( 1), @parm3 varchar ( 1), @parm4 varchar ( 1),
                                           @parm5 varchar ( 1), @parm6 varchar ( 6)   as
       Select * from Batch
           where Module   =        @parm1
             and BatType  =        @parm2
             and Status   NOT IN  (@parm3, @parm4, @parm5)
             and PerPost  =        @parm6
           order by Module, BatNbr, Status
GO
