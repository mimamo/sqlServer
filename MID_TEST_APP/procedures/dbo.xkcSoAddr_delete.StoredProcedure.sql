USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcSoAddr_delete]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcSoAddr_delete] as
delete from xkcsoaddr
GO
