USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId3]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_UnRlsed_CustId3    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_UnRlsed_CustId3] @parm1 varchar ( 15) as
Select * from Salesord where
	CustId = @parm1
GO
