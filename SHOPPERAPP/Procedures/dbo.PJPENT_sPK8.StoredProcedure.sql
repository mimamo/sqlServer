USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK8]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK8] @parm1 varchar (16) , @PARM2 varchar (32)   as
select project, pjt_entity, pjt_entity_desc, status_pa, status_po from PJPENT
where project =  @parm1 and
pjt_entity  Like  @parm2 and
status_pa = 'A' and
status_po = 'A'
order by project, pjt_entity
GO
