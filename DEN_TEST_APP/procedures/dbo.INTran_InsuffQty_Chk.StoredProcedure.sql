USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_InsuffQty_Chk]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_InsuffQty_Chk    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_InsuffQty_Chk    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_InsuffQty_Chk] as
    Select count(*) From INTran Where InsuffQty = 1 Or InsuffQty = 2
GO
