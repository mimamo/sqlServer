USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sallmet]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sallmet] @parm1 varchar (16)  as
select * from PJPROJ
where project    like @parm1
and status_pa  IN   ('A','I')
order by project
GO
