USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[table_len]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[table_len] @parm1 int as
select sum (length) from syscolumns where id = @parm1
GO
