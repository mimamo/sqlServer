USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sactivin]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sactivin] @parm1 varchar (16) , @PARM2 varchar (32)   as
SELECT    project,
pjt_entity,
pjt_entity_desc,
status_pa,
status_in
FROM      PJPENT
WHERE     project =  @parm1 and
pjt_entity  Like  @parm2 and
status_pa = 'A' and
status_in = 'A'
ORDER BY  project, pjt_entity
GO
