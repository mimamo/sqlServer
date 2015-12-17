USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDNoteExport_Wrk_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDNoteExport_Wrk_All    Script Date: 5/28/99 1:17:43 PM ******/
CREATE PROCEDURE [dbo].[EDNoteExport_Wrk_AllDMG] @parm1 varchar(21), @parm2 int AS
Select *
from EDNoteExport_Wrk
where  ComputerName like @Parm1
and nID = @parm2
Order by ComputerName, Nid, LineNbr
GO
