USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_SCount]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_SCount] @parm1 varchar (16) as
select count(*) from PJPENTEM
where project like @parm1
GO
