USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId4]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_UnRlsed_CustId4] @parm1 varchar ( 15) as
Select * from SOHeader where
	CustId = @parm1
GO
