USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_SDLL]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_SDLL]  @parm1 varchar (16) , @parm2 varchar (32)   as
select pjt_entity_desc from PJPENT
where    project    = @parm1
and      pjt_entity = @parm2
order by project,
pjt_entity
GO
