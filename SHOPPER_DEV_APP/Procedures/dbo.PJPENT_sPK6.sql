USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sPK6]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sPK6] @parm1 varchar (16) , @PARM2 varchar (32)  as
SELECT * from PJPENT
WHERE    project =  @parm1 and
pjt_entity =  @parm2 and
status_pa = 'A' and
status_gl = 'A'
ORDER BY project, pjt_entity
GO
