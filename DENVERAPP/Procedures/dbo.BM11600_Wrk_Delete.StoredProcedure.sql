USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BM11600_Wrk_Delete]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM11600_Wrk_Delete] @parm1 varchar (47), @parm2 varchar (5) as
            Delete from BM11600_Wrk where
		LUpd_User = @parm1 and
		LUpd_Prog = @parm2
GO
