USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_spk3]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEM_spk3] @parm1 varchar (16), @parm2 varchar (10) as
select * from PJPENTEM
where project like @parm1
and employee like @parm2
GO
