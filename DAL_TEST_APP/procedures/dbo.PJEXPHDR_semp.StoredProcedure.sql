USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_semp]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJEXPHDR_semp] @Parm1 varchar (10) , @Parm2 varchar (10)  as
Select * from PJEXPHDR
Where
	pjexphdr.employee = @parm1 and
	pjexphdr.docnbr like @parm2
Order by
	pjexphdr.docnbr
GO
