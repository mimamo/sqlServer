USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_delete]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_delete] as
delete from xaccsub
GO
