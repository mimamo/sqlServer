USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sHTML]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sHTML] as
SELECT   p.project,
p.project_desc,
e.project,
e.pjt_entity,
e.pjt_entity_desc
FROM     PJPROJ P,PJPENT E
WHERE    p.project = e.project and
p.status_pa = 'A' and
e.status_pa = 'A'
ORDER BY p.project, e.pjt_entity
GO
