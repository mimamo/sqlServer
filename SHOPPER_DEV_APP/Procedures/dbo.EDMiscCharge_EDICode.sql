USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDMiscCharge_EDICode]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDMiscCharge_EDICode] @MiscChrgId varchar(10) As
Select S4Future11 From MiscCharge Where MiscChrgId = @MiscChrgId
GO
