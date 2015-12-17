USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sactivgl]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sactivgl]  @parm1 varchar (16)  as
-- This proceudre is used by GL Customizations
SELECT   project,
project_desc,
status_pa,
status_gl
FROM     PJPROJ
WHERE    status_pa = 'A' and
status_gl = 'A' and
project like @parm1
ORDER BY project
GO
