USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_spk13]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_spk13] @parm1 varchar (16) , @PARM2 varchar (32)   as
select pjt_entity, pjt_entity_desc from PJPENT
where   project     =     @parm1
and		pjt_entity  like  @parm2
and		status_pa    IN ('A','M')
order by project,
pjt_entity
GO
