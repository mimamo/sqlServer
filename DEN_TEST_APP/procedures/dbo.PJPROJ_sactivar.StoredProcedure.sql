USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sactivar]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sactivar]  @parm1 varchar (16)  as
-- This proceudre is used by AR Customizations
SELECT   project,
project_desc,
status_pa,
status_ar
FROM     PJPROJ
WHERE    status_pa = 'A' and
status_ar = 'A' and
project like @parm1
ORDER BY project
GO
