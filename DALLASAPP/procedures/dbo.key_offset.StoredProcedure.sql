USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[key_offset]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[key_offset] @parm1 varchar (70), @parm2 varchar (50) as 
select offset  from syscolumns
where id = object_Id(@parm1) and name = @parm2
order by id, number, colid
GO
