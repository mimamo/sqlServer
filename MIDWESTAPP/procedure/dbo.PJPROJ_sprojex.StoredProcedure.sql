USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sprojex]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sprojex] @parm1 varchar (16)  as
select *
from PJPROJ
	left outer join PJPROJEX
		on PJPROJ.project = PJPROJEX.project
where PJPROJ.project = @parm1
order by pjproj.project
GO
