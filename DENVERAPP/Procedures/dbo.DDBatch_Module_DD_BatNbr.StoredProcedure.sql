USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DDBatch_Module_DD_BatNbr]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDBatch_Module_DD_BatNbr] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar ( 10)  as
    Select * from Batch
     where Module = @parm1
       and JrnlType = 'DD'
       and Status = 'U'
       and BatNbr LIKE @parm2
       and CpnyId LIKE @parm3
     order by Module, BatNbr DESC
GO
