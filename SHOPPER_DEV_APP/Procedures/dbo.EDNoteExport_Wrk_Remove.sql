USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_Remove]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDNoteExport_Wrk_Remove]  @parm1 varchar(21), @parm2 int AS
delete
from EDNoteExport_Wrk
where  ComputerName like @Parm1
and nID = @parm2
GO
