USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sactivap]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sactivap] @parm1 varchar (16) , @PARM2 varchar (32)   as
SELECT   project,
pjt_entity,
pjt_entity_desc,
status_pa,
status_ap
FROM     PJPENT
WHERE    project =  @parm1 and
pjt_entity =  @parm2 and
status_pa = 'A' and
status_ap = 'A'
ORDER BY project, pjt_entity
GO
