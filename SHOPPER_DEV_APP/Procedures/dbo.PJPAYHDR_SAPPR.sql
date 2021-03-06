USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SAPPR]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJPAYHDR_SAPPR] @parm1 varchar (10), @parm2 varchar (10)  as
SELECT pjpayhdr.*,
	pjproj.project,
	pjproj.gl_subacct,
	pjsubcon.*,
	vendor.vendid,
	vendor.Name
FROM pjpayhdr
	left outer join vendor
		on pjpayhdr.vendid = vendor.vendid
	, pjproj, pjsubcon
WHERE pjpayhdr.approver = @parm1 and
	pjpayhdr.status1 =  'C' and
	pjpayhdr.project = pjproj.project and
	pjpayhdr.project = pjsubcon.project and
	pjpayhdr.subcontract = pjsubcon.subcontract and
	pjsubcon.cpnyid = @parm2
ORDER BY pjpayhdr.project, pjpayhdr.subcontract, pjpayhdr.payreqnbr
GO
