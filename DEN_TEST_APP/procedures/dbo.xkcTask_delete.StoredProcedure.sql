USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_delete]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_delete] as
delete from xkcTask
GO
