USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_Status]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Module_Status    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Module_Status] @parm1 varchar ( 2), @parm2 varchar ( 1) as
       Select * from Batch
           where Module = @parm1
            and Status  = @parm2
           order by Module, BatNbr
GO
