USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId4]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_UnRlsed_CustId4] @parm1 varchar ( 15) as
Select * from SOHeader where
	CustId = @parm1
GO
