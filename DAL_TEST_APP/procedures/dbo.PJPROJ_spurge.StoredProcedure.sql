USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spurge]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spurge] as
SELECT * from PJPROJ
WHERE status_pa = 'D'
ORDER BY project
GO
