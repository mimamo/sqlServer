USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[unique_test]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[unique_test] @parm1  int  as
select indid  from sysindexes where 
id = @parm1 and
status&2 = 2
GO
