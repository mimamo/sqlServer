USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_INStatus_CpnyID]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_INStatus_CpnyID    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Mod_INStatus_CpnyID] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Select * from Batch, Currncy
           Where Batch.CuryId = Currncy.CuryId
             and Module   =   @parm1
             and CpnyId   =   @parm2
             and Batch.Status   IN ('B', 'S', 'I')
           order by Module, BatNbr
GO
