USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcSoAddr_delete]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcSoAddr_delete] as
delete from xkcsoaddr
GO
