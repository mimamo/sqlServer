USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_Rlsed_BCury_BCR]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_Rlsed_BCury_BCR    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_Rlsed_BCury_BCR] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Select * from Batch, Currncy
           where Batch.BaseCuryId = Currncy.CuryId
             and Module  =    @parm1
             and Rlsed = 1
             and BatNbr  LIKE @parm2
           order by Module DESC, Rlsed DESC, BatNbr DESC
GO
