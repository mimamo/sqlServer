USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xStudioJob_sactive]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xStudioJob_sactive] @parm1 varchar (16)  as
select * from PJPROJ
where project    like @parm1
and status_pa  =    'A'
and substring(project,9,3) = 'APS'
order by project
GO
