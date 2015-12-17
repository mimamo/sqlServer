USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Mod_Rlsed]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Batch_Mod_Rlsed] @parm1 varchar ( 10), @parm2 varchar ( 2) as
       Select * from Batch
           where BatNbr  = @parm1
             and Module = @parm2
                 and Rlsed = 1
GO
