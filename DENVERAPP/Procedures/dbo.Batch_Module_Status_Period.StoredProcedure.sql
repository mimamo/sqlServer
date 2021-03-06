USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_Status_Period]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_Status_Period    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_Status_Period] @parm1 varchar ( 2), @parm2 varchar ( 2), @parm3 varchar ( 6), @parm4 varchar ( 6), @parm5 varchar ( 6), @parm6 varchar ( 6) as
       Select * from Batch
           where Module  IN (@parm1, @parm2)
             and Status  IN ('H', 'B', 'S', 'U', 'P')
                 and (Perpost IN (@parm3, @parm4)
                 or PerEnt IN (@parm5, @parm6))
           order by Module, BatNbr
GO
