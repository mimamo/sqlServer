USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_SCount]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_SCount] @parm1 varchar (16) as
select count(*) from PJPENTEM
where project like @parm1
GO
