USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJprojex_sALL]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJprojex_sALL] @parm1 varchar (16)  as
select * from PJprojex
where project like @parm1
order by project
GO
