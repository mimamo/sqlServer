USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_salloc]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_salloc] @parm1 varchar (16) , @PARM2 varchar (32)   as
select * from PJPENT
where project =  @parm1 and
pjt_entity    =  @parm2 and
status_pa    IN ('A','I')
order by project, pjt_entity
GO
