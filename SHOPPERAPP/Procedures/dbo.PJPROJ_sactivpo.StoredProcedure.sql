USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sactivpo]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sactivpo]  @parm1 varchar (16)  as
-- This proceudre is used by PO Customizations
SELECT   project,
project_desc,
status_pa,
status_po
FROM     PJPROJ
WHERE    status_pa = 'A' and
status_po = 'A' and
project like @parm1
ORDER BY project
GO
