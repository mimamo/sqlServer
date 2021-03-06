USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SCOMPANY]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJPAYHDR_SCOMPANY] @parm1 varchar (10) as
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
	pjpayhdr.project = pjsubcon.project and
	pjpayhdr.subcontract = pjsubcon.subcontract and
	pjsubcon.cpnyid = @parm1
ORDER BY pjpayhdr.project, pjpayhdr.subcontract, pjpayhdr.payreqnbr
GO
