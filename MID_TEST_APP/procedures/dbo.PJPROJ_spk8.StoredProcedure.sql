USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk8]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk8]  @parm1 varchar (16)  as
-- This procedure is used by ??????
SELECT * from PJPROJ
WHERE    status_pa = 'A' and
status_po = 'A' and
project like @parm1
ORDER BY project
GO
