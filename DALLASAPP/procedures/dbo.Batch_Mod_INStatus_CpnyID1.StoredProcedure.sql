USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_INStatus_CpnyID1]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_INStatus_CpnyID1  ******/
Create Proc [dbo].[Batch_Mod_INStatus_CpnyID1] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Select * from Batch
           where Module   =   @parm1
             and CpnyId Like  @parm2
             and Status   IN ('B', 'S', 'I')
           order by Module, BatNbr
GO
