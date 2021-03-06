USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_sapp]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_sapp] @Parm1 varchar (10) , @Parm2 varchar (1), @parm3 varchar(10), @parm4 varchar(1)  as
Select *
From PJEXPHDR
	left outer join PJEMPLOY
		on pjexphdr.employee = pjemploy.employee
Where
	pjexphdr.approver = @parm1 and
	(pjexphdr.status_1 = @parm2 or pjexphdr.status_1 = @parm4) and
	pjexphdr.cpnyid_home = @parm3
Order by
	pjexphdr.report_date,
	pjexphdr.employee,
	pjexphdr.docnbr
GO
