USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk1]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk1] @parm1 varchar (16)  as
select * from PJPROJ
where project    like @parm1
and status_pa  =    'A'
order by project
GO
