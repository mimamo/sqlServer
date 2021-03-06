USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjproj_spk2em]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjproj_spk2em] @parm1 varchar (10), @parm2 varchar (16)  as
select * from PJPROJ, pjprojem
where pjproj.project = pjprojem.project and
(pjprojem.employee = @parm1 or pjprojem.employee = '*') and
pjproj.project like @parm2 and
pjproj.status_pa = 'A' and
pjproj.status_lb = 'A'
order by pjproj.project
GO
