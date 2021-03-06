USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_ssub]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_ssub] @Parm1 varchar (24) , @Parm2 varchar (1), @parm3 varchar(10), @Parm4 varchar (1)  as
Select *
From PJEXPHDR
	left outer join PJEMPLOY
		on	pjexphdr.employee = pjemploy.employee
Where
	pjexphdr.gl_subacct like @parm1 and
	(pjexphdr.status_1 = @parm2 or pjexphdr.status_1 = @parm4) and
	pjexphdr.cpnyid_home = @parm3
Order by
	pjexphdr.report_date,
	pjexphdr.employee,
	pjexphdr.docnbr
GO
