USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_spk11]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_spk11] @parm1 varchar (16) , @PARM2 varchar (32)   as
select pjt_entity, pjt_entity_desc from PJPENT
where    project     =     @parm1
and    pjt_entity  like  @parm2
and    status_pa   =    'A'
order by project,
pjt_entity
GO
