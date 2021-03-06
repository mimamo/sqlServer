USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_CpnyID_BatNbr_BCR]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_CpnyID_BatNbr_BCR    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Mod_CpnyID_BatNbr_BCR] @parm1 varchar(2), @parm2 varchar ( 10), @parm3 varchar ( 10), @parm4 varchar ( 6) as
       Select * from Batch
           where Module  =    @parm1
               and CpnyID like @parm2
             and Status IN ( 'U', 'P')
             and BatNbr  LIKE @parm2
             and PerPost >= @parm3
             order by Module, CpnyID, BatNbr DESC, Status
GO
