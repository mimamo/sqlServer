USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_sExport]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_sExport] @parm1 varchar (16) , @parm2 varchar (4)   as
SELECT  * from PJREVCAT C, PJREVTSK T
WHERE
c.project =  @parm1 and
c.RevId =  @parm2 and
c.pjt_entity = t.pjt_entity and
c.RevId = t.RevId and
c.project = t.project
ORDER BY
c.project,
c.pjt_entity,
c.acct
GO
