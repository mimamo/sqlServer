USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPOSetup_BillTo]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPOSetup_BillTo] As
Select BillName, BillAddr1, BillAddr2, BillAttn, BillCity, BillState, BillZip, BillCountry,
BillPhone, BillFax From POSetup
GO
