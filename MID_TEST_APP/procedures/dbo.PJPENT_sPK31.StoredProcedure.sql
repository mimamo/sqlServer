USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK31]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK31] @parm1 varchar (16)   as
select project, pjt_entity, pjt_entity_desc, status_pa, status_ap from PJPENT
where project =  @parm1 and
status_pa = 'A' and
status_ap = 'A'
order by project, pjt_entity
GO
