USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[getindexinfo]    Script Date: 12/21/2015 15:42:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[getindexinfo] @parm1 varchar (70), @parm2 smallint, @parm3 smallint as
select index_col( @parm1, @parm2,@parm3)
GO
