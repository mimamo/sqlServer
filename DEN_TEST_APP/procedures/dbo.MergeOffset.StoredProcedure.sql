USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[MergeOffset]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[MergeOffset] @parm1 int, @parm2 varchar (50)as
select offset from syscolumns where 
id = @parm1 and
name = @parm2
GO
