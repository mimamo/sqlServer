USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_spk0]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_spk0] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32)  as
SELECT  *    from PJREVTSK
WHERE       project = @parm1 and
	    revid = @parm2 and
pjt_entity = @parm3
ORDER BY        project, revid,  pjt_entity
GO
