USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_scompany]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_scompany] @parm1  varchar (1), @parm2 varchar(10), @parm3  varchar (1)  as
Select *
From PJEXPHDR
	left outer join PJEMPLOY
		on	pjexphdr.employee = pjemploy.employee
Where
	(pjexphdr.status_1 = @parm1 or pjexphdr.status_1 = @parm3) and
	pjexphdr.cpnyid_home = @parm2
Order by
	pjexphdr.report_date,
	pjexphdr.employee,
	pjexphdr.docnbr
GO
