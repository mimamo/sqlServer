USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_delete]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_delete] as
delete from xaccsub
GO
