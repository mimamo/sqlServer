USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk6]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk6]   @parm1 varchar (16)  as
-- This procecure is used by 01.010
SELECT * from PJPROJ
WHERE    status_pa = 'A' and
status_gl = 'A' and
project like @parm1
ORDER BY project
GO
