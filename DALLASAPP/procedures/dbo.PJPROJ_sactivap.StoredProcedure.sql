USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sactivap]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sactivap]  @parm1 varchar (16)  as
-- This proceudre is used by AP Customizations
SELECT   project,
project_desc,
status_pa,
status_ap
FROM     PJPROJ
WHERE    status_pa = 'A' and
status_ap = 'A' and
project like @parm1
ORDER BY project
GO
