USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sProjAct]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sProjAct]  @parm1 varchar (16)  as
SELECT   *
FROM     PJPROJ
WHERE    project = @parm1 and
status_pa = 'A'
ORDER BY project
GO
