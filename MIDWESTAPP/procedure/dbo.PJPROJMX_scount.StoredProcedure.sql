USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJMX_scount]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJMX_scount] @parm1 varchar (16) as
select count(*) from PJPROJMX where project like @parm1
GO
