USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sALL]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sALL] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from PJPENT
where project =  @parm1 and pjt_entity  like  @parm2
order by project, pjt_entity
GO
