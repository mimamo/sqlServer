USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_scount]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_scount] @parm1 varchar (16)     as
select count(*), max(pjt_entity) from PJPENT
where project =  @parm1
GO
