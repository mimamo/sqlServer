USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_delete]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_delete] @userid varchar(47) as
delete from xardoc where 
userid = @userid
GO
