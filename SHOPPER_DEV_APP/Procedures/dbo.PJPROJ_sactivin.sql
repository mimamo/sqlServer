USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sactivin]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sactivin]  @parm1 varchar (16)  as
-- This proceudre is used by IN Customizations
SELECT   project,
project_desc,
status_pa,
status_in
FROM     PJPROJ
WHERE    status_pa = 'A' and
status_in = 'A' and
project like @parm1
ORDER BY project
GO
