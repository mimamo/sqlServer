USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Status_AutoRevCopy]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Status_AutoRevCopy    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Status_AutoRevCopy] @parm1 varchar ( 1), @parm2 smallint as
       Select * from Batch
           where Status      = @parm1
             and AutoRevCopy = @parm2
           order by Module, BatNbr
GO
