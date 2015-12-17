USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK10]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK10] @parm1 varchar (16) , @PARM2 varchar (32)   as
select project, pjt_entity, pjt_entity_desc, status_pa, status_in from PJPENT
where project =  @parm1 and
pjt_entity  Like  @parm2 and
status_pa = 'A' and
status_in = 'A'
order by project, pjt_entity
GO
