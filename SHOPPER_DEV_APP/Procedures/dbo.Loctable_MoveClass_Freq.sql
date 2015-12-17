USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Loctable_MoveClass_Freq]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Loctable_MoveClass_Freq    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Loctable_MoveClass_Freq] @parm1 varchar(10) as
   Select * from LocTable where MoveClass <> ''
	and siteid = @Parm1 and countstatus = 'A'
	order by MoveClass, whseloc
GO
