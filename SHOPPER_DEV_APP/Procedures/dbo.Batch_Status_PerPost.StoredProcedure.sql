USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Status_PerPost]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Status_PerPost    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Status_PerPost] @parm1 varchar ( 1), @parm2 varchar ( 6) as
       Select * from Batch
           where Status   = @parm1
             and PerPost <= @parm2
           order by Module, BatNbr
GO
