USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_sBrowse]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_sBrowse] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32)   as
SELECT  * FROM PJREVTSK
WHERE project = @parm1 and
pjt_entity IN
(Select pjt_entity from pjrevcat where project =  @parm1 and revid = @parm2) and
pjt_entity = @parm3
	ORDER BY  	project,
		pjt_entity
GO
