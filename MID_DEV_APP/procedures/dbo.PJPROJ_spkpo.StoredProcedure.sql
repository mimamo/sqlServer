USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spkpo]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spkpo]    @parm1 varchar (16) as
-- This procedure is used by 04.010, 04.250
SELECT * from PJPROJ
WHERE    status_pa = 'A' and
status_po = 'A' and
project like @parm1
ORDER BY project
GO
