USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDMiscCharge_EDICode]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDMiscCharge_EDICode] @MiscChrgId varchar(10) As
Select S4Future11 From MiscCharge Where MiscChrgId = @MiscChrgId
GO
