USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_delete]    Script Date: 12/21/2015 15:49:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_delete]   as
delete from xREAPCHK
GO
