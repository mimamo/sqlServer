USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInSetup_DecPl]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInSetup_DecPl] As
Select DecPlPrcCst, DecPlQty From Insetup
GO
