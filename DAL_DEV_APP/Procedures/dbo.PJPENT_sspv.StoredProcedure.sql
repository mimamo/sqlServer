USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sspv]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sspv] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from PJPENT
where project like  @parm1 and pjt_entity  like  @parm2
order by project, pjt_entity
GO
