USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk10]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk10]  @parm1 varchar (16)  as
-- This proceudre is used by IN Customizations
select project, project_desc, status_pa, status_in from PJPROJ
where
status_pa = 'A' and
status_in = 'A' and
project like @parm1
order by project
GO
