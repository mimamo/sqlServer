USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sstat2]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sstat2] @parm1 varchar (16) , @parm2 varchar (1) , @parm3 varchar (1)   as
select * from PJPENT
where project =  @parm1 and
(status_pa = @parm2 or
status_pa = @parm3)
order by project, pjt_entity
GO
