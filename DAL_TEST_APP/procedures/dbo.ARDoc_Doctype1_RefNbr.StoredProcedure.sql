USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Doctype1_RefNbr]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Doctype1_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Doctype1_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from ARDoc where
	CpnyId = @parm1
	and doctype IN ('PA', 'CM', 'PP')
	and rlsed = 1
	and refnbr like @parm2
	order by CpnyId, Doctype, Refnbr
GO
