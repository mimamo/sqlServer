USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SSUBACCT]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJPAYHDR_SSUBACCT] @parm1 varchar (24), @parm2 varchar (10)    as
SELECT pjpayhdr.*,
	pjproj.project,
	pjproj.gl_subacct,
	pjsubcon.*,
	vendor.vendid,
	vendor.Name
FROM pjpayhdr
	left outer join vendor
		on 	pjpayhdr.vendid = vendor.vendid
	, pjproj, pjsubcon
WHERE pjpayhdr.status1 =  'C' and
	pjpayhdr.project = pjproj.project and
	pjproj.gl_subacct Like @parm1 and
	pjpayhdr.project = pjsubcon.project and
	pjpayhdr.subcontract = pjsubcon.subcontract and
	pjsubcon.cpnyid = @parm2
ORDER BY pjpayhdr.project, pjpayhdr.subcontract, pjpayhdr.payreqnbr
GO
