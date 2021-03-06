USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Status_AutoRev]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Status_AutoRev    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Status_AutoRev] @parm1 varchar ( 1), @parm2 smallint as
       Select * from Batch
           where Status  = @parm1
             and AutoRev = @parm2
           order by Module, BatNbr
GO
