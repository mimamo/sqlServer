USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_si21]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_si21] @parm1 varchar (10) , @parm2 varchar (1)  as
select * from PJPROJ
where manager2   =    @parm1
and status_pa  like @parm2
order by project
GO
