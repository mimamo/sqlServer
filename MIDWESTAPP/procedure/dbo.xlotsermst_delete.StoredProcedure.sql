USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xlotsermst_delete]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xlotsermst_delete] @userid varchar(47) as
delete from xlotsermst where 
userid = @userid
GO
