USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCpnyAcct_delete]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCpnyAcct_delete] as
delete from xkcCpnyAcct
GO
