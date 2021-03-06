USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_SACCT]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJREVHDR_SACCT] @parm1 varchar (24) as
SELECT pjrevhdr.*,
	pjproj.*,
	pjemploy.*,
	pjemploy1.employee, pjemploy1.emp_name,
	pjemploy3.employee, pjemploy3.emp_name,
	pjemploy4.employee, pjemploy4.emp_name,
	pjemploy5.employee, pjemploy5.emp_name
FROM pjrevhdr
	left outer join pjemploy
		on pjrevhdr.approver = pjemploy.employee
	left outer join pjemploy pjemploy1
		on pjrevhdr.preparer = pjemploy1.employee
	left outer join pjemploy pjemploy3
		on pjrevhdr.approved_by1 = pjemploy3.employee
	left outer join pjemploy pjemploy4
		on pjrevhdr.approved_by2 = pjemploy4.employee
	left outer join pjemploy pjemploy5
		on pjrevhdr.approved_by3 = pjemploy5.employee
	, pjproj
WHERE pjproj.gl_subacct LIKE @parm1 and
	pjrevhdr.project = pjproj.project and
	pjrevhdr.status = 'C '
ORDER BY pjrevhdr.project, revid
GO
