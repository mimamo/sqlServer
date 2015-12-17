USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_BatNbr_Status]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_BatNbr_Status    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_BatNbr_Status] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar ( 1) as
       Select * from Batch
           where Module  = @parm1
             and BatNbr  = @parm2
             and Status  = @parm3
GO
