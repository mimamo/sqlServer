USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkc21pv_all]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkc21pv_all] @parm1 varchar (50) as
select * from xkc21pv where id like @parm1
order by id
GO
