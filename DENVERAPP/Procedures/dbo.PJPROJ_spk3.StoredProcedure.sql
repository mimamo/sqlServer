USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk3]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk3]  @parm1 varchar (16)  as
-- This procedure is used by 03.010
SELECT * from PJPROJ
WHERE    status_pa = 'A' and
status_ap = 'A' and
project like @parm1
ORDER BY project
GO
