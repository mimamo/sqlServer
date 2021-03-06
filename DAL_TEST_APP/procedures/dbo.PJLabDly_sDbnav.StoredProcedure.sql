USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabDly_sDbnav]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJLabDly_sDbnav]  @Parm1 varchar (10) , @parm2 varchar (4) , @Parm3Min smallint , @Parm3Max smallint  AS

SELECT PJLABDLY.*, pjproj.*, pjpent.*, PJLabdly.*
from   PJLABDLY
	left outer join PJPROJ
		on 	pjlabdly.project = pjproj.project
	left outer join PJPENT
		on 	pjlabdly.project = pjpent.project
		and pjlabdly.pjt_entity = pjpent.pjt_entity
WHERE  docNbr = @Parm1 AND
	  ldl_SiteId = @Parm2 AND
	  lineNbr BETWEEN @Parm3Min AND @Parm3Max
ORDER BY pjlabdly.DocNbr, pjlabdly.ldl_SiteId, pjlabdly.lineNbr
GO
