USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInSetup_DecPl]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInSetup_DecPl] As
Select DecPlPrcCst, DecPlQty From Insetup
GO
