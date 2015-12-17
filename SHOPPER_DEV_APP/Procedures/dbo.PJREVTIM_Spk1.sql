USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTIM_Spk1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTIM_Spk1] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (32) , @parm4 varchar (16)  as
SELECT  *    from PJREVTIM
WHERE              RevId = @parm1 and
Project = @parm2 and
Pjt_Entity = @parm3 and
Acct = @parm4
ORDER BY  revid, project, pjt_entity, acct, fiscalno
GO
