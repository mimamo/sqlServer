USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_BatNbr]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_BatNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_BatNbr] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Select * from Batch
           where Module  = @parm1
             and BatNbr  = @parm2
GO
