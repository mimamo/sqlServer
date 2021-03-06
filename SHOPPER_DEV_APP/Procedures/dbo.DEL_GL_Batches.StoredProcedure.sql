USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DEL_GL_Batches]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DEL_GL_Batches    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc  [dbo].[DEL_GL_Batches] @parm1 varchar ( 6), @parm2 varchar ( 6) as
       Delete batch from Batch
           where Batch.Module  =  'GL'
             and Batch.Status  in ('V', 'D', 'P')
             and Batch.PerPost <= @parm1
             and Batch.PerEnt  <  @parm2
GO
