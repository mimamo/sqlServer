USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_DEL_Module_BatNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_DEL_Module_BatNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLTran_DEL_Module_BatNbr] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Delete gltran from GLTran
           where Module  = @parm1
                          and BatNbr  = @parm2
GO
