USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIMoveCl_All]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIMoveCl_All    Script Date: 4/17/98 10:58:19 AM ******/
Create proc [dbo].[PIMoveCl_All] @Parm1 varchar(10) as
    Select * from PIMoveCl where MoveClass like @parm1
    order by MoveClass
GO
