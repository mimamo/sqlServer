USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_Rlsed_CpnyID_BCR]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_Rlsed_CpnyID_BCR    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_Rlsed_CpnyID_BCR] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar ( 10) as
       Select * from Batch
           where Module  = @parm1
             And CpnyId = @parm2
                 and Rlsed = 1
             and BatNbr  LIKE @parm3
                 and Status <> 'V'
           order by Module, Rlsed, BatNbr
GO
