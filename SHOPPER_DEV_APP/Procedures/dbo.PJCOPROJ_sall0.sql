USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_sall0]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_sall0] @parm1 varchar (16) , @parm2 varchar (16)  as
select * from PJCOPROJ
where project  =    @parm1 and
owner_co like @parm2 and
owner_co <>   ''
order by
project,
owner_co
GO
