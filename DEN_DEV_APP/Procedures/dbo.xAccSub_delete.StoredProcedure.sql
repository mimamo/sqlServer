USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_delete]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_delete] as
delete from xaccsub
GO
