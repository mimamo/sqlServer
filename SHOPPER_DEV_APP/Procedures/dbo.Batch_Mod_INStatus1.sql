USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_INStatus1]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Mod_INStatus1    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Mod_INStatus1] @parm1 varchar ( 2) as
       Select * from Batch
           Where Module   =   @parm1
             and Status   IN ('B', 'S', 'I')
           order by Module, BatNbr
GO
