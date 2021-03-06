USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[delete_module_batches]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.delete_module_batches    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc [dbo].[delete_module_batches] @parm1 varchar ( 2), @parm2 varchar ( 6), @parm3 varchar ( 6) As
       Delete batch From Batch
           where Batch.Module = @parm1
             and STATUS IN ('V', 'C', 'D', 'P')
             and PerPost < @parm2

             and PerPost < @parm3
GO
