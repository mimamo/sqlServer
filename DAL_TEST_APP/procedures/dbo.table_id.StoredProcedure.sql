USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[table_id]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[table_id] @parm1  varchar (70) as
select object_id (@parm1)
GO
