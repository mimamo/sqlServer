USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_delete]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_delete] @userid varchar(47) as
delete from xardoc where 
userid = @userid
GO
