USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[table_len]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[table_len] @parm1 int as
select sum (length) from syscolumns where id = @parm1
GO
