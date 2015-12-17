USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_SPK1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_SPK1] @parm1 varchar (16) , @parm2 varchar (4)  as
SELECT  *    from PJREVCAT
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2
ORDER BY        pjrevcat.project,
pjrevcat.revid,
pjrevcat.pjt_entity,
pjrevcat.acct
GO
