USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabdet_sduptc]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjlabdet_sduptc] @parm1 varchar (10), @parm2 varchar(10)  as
select PjLabdet.*, PJProj.PM_ID40, PJPent.PE_ID40
from PjLabdet
INNER JOIN PJProj
ON PjLabdet.Project = PJProj.Project
INNER JOIN PJPent
ON PjLabdet.Project = PJPent.Project and PjLabdet.PJT_Entity = PJPent.PJT_Entity
INNER JOIN pjprojem
ON PjLabdet.Project = pjprojem.Project
where
PjLabdet.docnbr = @parm1 And
(pjprojem.employee = @parm2 or pjprojem.employee = '*') and
PJLABDET.rate_source <> 'A' and
PJProj.status_pa = 'A' and
PJProj.status_lb = 'A' and
PJPent.status_pa = 'A' and
PJPent.status_lb = 'A'
order by PjLabdet.docnbr
GO
