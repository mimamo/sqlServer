USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJPENT_sPK0_Active]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[xPJPENT_sPK0_Active] @parm1 varchar (16), @PARM2 varchar (32) as
select * from PJPENT
where project =  @parm1 and pjpent.status_pa = 'A' 
and pjt_entity =  @parm2
order by project, pjt_entity
GO
