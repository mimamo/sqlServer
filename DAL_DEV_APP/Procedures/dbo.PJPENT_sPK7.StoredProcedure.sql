USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK7]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK7] @parm1 varchar (16) , @PARM2 varchar (32)   as
select * from PJPENT
where project =  @parm1 and
pjt_entity Like  @parm2 and
status_pa = 'A' and
status_lb = 'A'
order by project, pjt_entity
GO
