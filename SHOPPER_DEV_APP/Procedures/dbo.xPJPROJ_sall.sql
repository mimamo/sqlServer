USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJPROJ_sall]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[xPJPROJ_sall] @parm1 varchar (16)  as
select * from PJPROJ
where project like @parm1 And pjproj.status_pa = 'A'
order by project
GO
