USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK0]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK0] @parm1 varchar (16) , @PARM2 varchar (32)   as
select * from PJPENT
where project =  @parm1 and
pjt_entity =  @parm2
order by project, pjt_entity
GO
