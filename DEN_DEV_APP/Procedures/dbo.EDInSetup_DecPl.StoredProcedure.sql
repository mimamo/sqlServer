USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInSetup_DecPl]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInSetup_DecPl] As
Select DecPlPrcCst, DecPlQty From Insetup
GO
