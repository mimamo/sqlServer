USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[key_info]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[key_info] @parm1 varchar (70), @parm2 varchar (50) as 
select offset,length from syscolumns
where id = object_Id(@parm1) and name = @parm2
order by id, number, colid
GO
